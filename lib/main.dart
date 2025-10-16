import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'screens/main_screen.dart';
import 'services/waste_detector.dart';

// 전역 변수로 카메라 리스트 선언
List<CameraDescription> cameras = [];

Future<void> main() async {
  // Flutter 바인딩 초기화 (비동기 작업 전 필수)
  WidgetsFlutterBinding.ensureInitialized();

  // 카메라 초기화
  try {
    cameras = await availableCameras();
    print('✅ 카메라 초기화 완료: ${cameras.length}개');
  } catch (e) {
    print('❌ 카메라 초기화 실패: $e');
  }

  // 모델 로드
  try {
    await WasteDetector.instance.initialize();
    print('✅ 모델 초기화 완료');
  } catch (e) {
    print('❌ 모델 초기화 실패: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SSbry',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF27631F)),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}