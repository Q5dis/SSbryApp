// lib/services/waste_detector.dart (ONNX 크로스플랫폼 버전)

import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:onnxruntime/onnxruntime.dart';
import 'dart:math' as math;

class DetectionResult {
  final String category;
  final double confidence;
  final List<double> bbox;

  DetectionResult({
    required this.category,
    required this.confidence,
    required this.bbox,
  });
}

class WasteDetector {
  static final WasteDetector _instance = WasteDetector._internal();
  factory WasteDetector() => _instance;
  WasteDetector._internal();
  static WasteDetector get instance => _instance;

  OrtSession? _session;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  static const int INPUT_SIZE = 416;
  final List<String> _classes = [
    'can', 'glass', 'paper', 'plastic', 'trash', 'vinyl'
  ];

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      OrtEnv.instance.init();

      final modelBytes = await rootBundle.load('assets/models/best_waste_model.onnx');
      final bytes = modelBytes.buffer.asUint8List();

      final sessionOptions = OrtSessionOptions();
      _session = OrtSession.fromBuffer(bytes, sessionOptions);

      _isInitialized = true;
      print('✅ ONNX 모델 로드 성공');
      print('입력: ${_session!.inputNames}');
      print('출력: ${_session!.outputNames}');

    } catch (e) {
      print('❌ ONNX 모델 로드 실패: $e');
      rethrow;
    }
  }

  Float32List _preprocessImage(Uint8List imageBytes) {
    final originalImage = img.decodeImage(imageBytes)!;
    final resized = img.copyResize(
      originalImage,
      width: INPUT_SIZE,
      height: INPUT_SIZE,
      interpolation: img.Interpolation.linear,
    );

    final input = Float32List(1 * 3 * INPUT_SIZE * INPUT_SIZE);

    int pixelIndex = 0;

    // R 채널
    for (int y = 0; y < INPUT_SIZE; y++) {
      for (int x = 0; x < INPUT_SIZE; x++) {
        final pixel = resized.getPixel(x, y);
        input[pixelIndex++] = pixel.r / 255.0;
      }
    }

    // G 채널
    for (int y = 0; y < INPUT_SIZE; y++) {
      for (int x = 0; x < INPUT_SIZE; x++) {
        final pixel = resized.getPixel(x, y);
        input[pixelIndex++] = pixel.g / 255.0;
      }
    }

    // B 채널
    for (int y = 0; y < INPUT_SIZE; y++) {
      for (int x = 0; x < INPUT_SIZE; x++) {
        final pixel = resized.getPixel(x, y);
        input[pixelIndex++] = pixel.b / 255.0;
      }
    }

    return input;
  }

  Future<Map<String, dynamic>?> detectWaste(Uint8List imageBytes) async {
    if (!_isInitialized || _session == null) {
      throw Exception('모델이 초기화되지 않았습니다.');
    }

    try {
      final inputData = _preprocessImage(imageBytes);

      final inputOrt = OrtValueTensor.createTensorWithDataList(
        inputData,
        [1, 3, INPUT_SIZE, INPUT_SIZE],
      );

      final inputs = {'images': inputOrt};
      final runOptions = OrtRunOptions();
      final outputs = _session!.run(runOptions, inputs);

      final outputTensor = outputs[0]?.value as List<List<List<double>>>;
      inputOrt.release();
      runOptions.release();

      final detections = _parseYOLOOutput(outputTensor);

      if (detections.isEmpty) {
        return {'category': 'unknown', 'confidence': 0.0};
      }

      final best = detections.first;
      return {
        'category': best.category,
        'confidence': best.confidence,
        'bbox': best.bbox,
      };
    } catch (e) {
      print('❌ 추론 실패: $e');
      return null;
    }
  }

  List<DetectionResult> _parseYOLOOutput(List<List<List<double>>> output) {
    final results = <DetectionResult>[];
    const confThreshold = 0.5;
    const iouThreshold = 0.4;

    final predictions = output[0];

    for (int i = 0; i < predictions[0].length; i++) {
      final x = predictions[0][i];
      final y = predictions[1][i];
      final w = predictions[2][i];
      final h = predictions[3][i];

      double maxScore = 0.0;
      int maxIndex = -1;

      for (int c = 0; c < _classes.length; c++) {
        final score = predictions[4 + c][i];
        if (score > maxScore) {
          maxScore = score;
          maxIndex = c;
        }
      }

      if (maxScore >= confThreshold) {
        final x1 = (x - w / 2) * INPUT_SIZE;
        final y1 = (y - h / 2) * INPUT_SIZE;
        final x2 = (x + w / 2) * INPUT_SIZE;
        final y2 = (y + h / 2) * INPUT_SIZE;

        results.add(DetectionResult(
          category: _classes[maxIndex],
          confidence: maxScore,
          bbox: [x1, y1, x2, y2],
        ));
      }
    }

    return _applyNMS(results, iouThreshold);
  }

  List<DetectionResult> _applyNMS(
      List<DetectionResult> detections,
      double iouThreshold,
      ) {
    if (detections.isEmpty) return [];

    detections.sort((a, b) => b.confidence.compareTo(a.confidence));

    final selected = <DetectionResult>[];

    while (detections.isNotEmpty) {
      final current = detections.removeAt(0);
      selected.add(current);

      detections.removeWhere((det) {
        final iou = _calculateIoU(current.bbox, det.bbox);
        return iou > iouThreshold;
      });
    }

    return selected;
  }

  double _calculateIoU(List<double> box1, List<double> box2) {
    final x1 = math.max(box1[0], box2[0]);
    final y1 = math.max(box1[1], box2[1]);
    final x2 = math.min(box1[2], box2[2]);
    final y2 = math.min(box1[3], box2[3]);

    final intersectionArea = math.max(0, x2 - x1) * math.max(0, y2 - y1);

    final box1Area = (box1[2] - box1[0]) * (box1[3] - box1[1]);
    final box2Area = (box2[2] - box2[0]) * (box2[3] - box2[1]);

    final unionArea = box1Area + box2Area - intersectionArea;

    return intersectionArea / unionArea;
  }

  void dispose() {
    _session?.release();
    _session = null;
    OrtEnv.instance.release();
    _isInitialized = false;
    print('🗑️ WasteDetector ONNX 세션 해제 완료');
  }
}