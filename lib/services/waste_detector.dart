// lib/services/waste_detector.dart (TFLite 버전)

import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
// 🚨 ONNX 대신 TFLite 라이브러리 임포트
import 'package:tflite_flutter/tflite_flutter.dart';

class WasteDetector {
  static final WasteDetector _instance = WasteDetector._internal();
  factory WasteDetector() => _instance;
  WasteDetector._internal();
  static WasteDetector get instance => _instance;

  // 🚨 변경: Interpreter 사용
  Interpreter? _interpreter;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // 모델 입력/출력 설정 (YOLOv8 TFLite 416x416 기준)
  static const int INPUT_SIZE = 416;
  // 클래스는 사용자 모델에 맞게 조정하세요.
  final List<String> _classes = ['can', 'glass', 'paper', 'plastic', 'trash', 'vinyl'];

  // 모델 로드 및 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 🚨 모델 경로 변경: .tflite 파일 로드
      _interpreter = await Interpreter.fromAsset('assets/models/best_waste_model.tflite');
      _isInitialized = true;
      print('✅ TFLite 모델 로드 성공');

    } catch (e) {
      print('❌ TFLite 모델 로드 실패: $e');
      rethrow;
    }
  }

  // 이미지 전처리 (TFLite 형식에 맞게 HWC로 변환)
  Uint8List _preprocessImage(Uint8List imageBytes) {
    final originalImage = img.decodeImage(imageBytes)!;
    final resized = img.copyResize(originalImage, width: INPUT_SIZE, height: INPUT_SIZE);

    // 크기: 1 (배치) * 416 * 416 * 3 (채널)
    final inputData = Float32List(1 * INPUT_SIZE * INPUT_SIZE * 3);

    int pixelIndex = 0;

    // TFLite 표준 (HWC)에 맞춰서 데이터 저장
    for (int y = 0; y < INPUT_SIZE; y++) {
      for (int x = 0; x < INPUT_SIZE; x++) {
        final pixel = resized.getPixel(x, y);

        // 픽셀 값 정규화 (0~1)
        inputData[pixelIndex++] = pixel.r / 255.0; // Red
        inputData[pixelIndex++] = pixel.g / 255.0; // Green
        inputData[pixelIndex++] = pixel.b / 255.0; // Blue
      }
    }

    return inputData.buffer.asUint8List();
  }

  // 추론 실행
  Future<Map<String, dynamic>?> detectWaste(Uint8List imageBytes) async {
    if (!_isInitialized || _interpreter == null) {
      throw Exception('모델이 초기화되지 않았습니다.');
    }

    try {
      // 1. 입력 데이터 준비
      final inputBytes = _preprocessImage(imageBytes);

      // 2. 출력 배열 초기화 (TFLite YOLO 출력 Shape에 맞춰야 함)
      final outputShape = _interpreter!.getOutputTensor(0).shape;
      final outputTensor = List.filled(
        outputShape.reduce((a, b) => a * b),
        0.0,
      ).reshape(outputShape);

      // 3. 모델 추론 실행
      // 🚨 TFLite는 입력 형태를 [1, 416, 416, 3]의 Float32List로 자동 변환하여 사용합니다.
      _interpreter!.run(inputBytes, outputTensor);

      // 4. 결과 파싱 (이 부분은 사용자 모델 출력 형태에 맞게 조정 필요)
      final result = _parseOutput(outputTensor);

      return result;
    } catch (e) {
      print('❌ TFLite 모델 추론 실패: $e');
      return null;
    }
  }

  Map<String, dynamic>? _parseOutput(List<dynamic> outputTensor) {
    // 💡 경고: TFLite YOLO 모델의 후처리는 복잡하며, 이 코드는 임시 로직입니다.
    double maxConfidence = 0.0;
    int maxClassIndex = -1;
    Map<String, dynamic>? bestResult;

    // TFLite YOLO 출력: [1, N, M] 형태 가정 (N: 디텍션 수, M: 4box+1conf+6classes)
    if (outputTensor.isNotEmpty && outputTensor[0] is List) {
      final detections = outputTensor[0];

      for (var detection in detections) {
        if (detection is List<double> && detection.length >= 6) {
          final objectConf = detection[4]; // 객체 신뢰도

          for (int i = 0; i < _classes.length; i++) {
            final classScore = detection[5 + i]; // 클래스별 점수

            final finalScore = classScore * objectConf;

            if (finalScore > maxConfidence) {
              maxConfidence = finalScore;
              maxClassIndex = i;
              bestResult = {
                'category': _classes[maxClassIndex],
                'confidence': maxConfidence,
              };
            }
          }
        }
      }
    }

    if (maxConfidence < 0.5) { // 50% 미만은 'unknown'
      return {'category': 'unknown', 'confidence': maxConfidence};
    }

    return bestResult;
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isInitialized = false;
    print('🗑️ WasteDetector TFLite 세션 해제 완료');
  }
}