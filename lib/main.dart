import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'services/waste_detector.dart'; // 🚨 추가

void main() async {
  // 🚨 Flutter 바인딩 초기화 (비동기 작업 전 필수)
  WidgetsFlutterBinding.ensureInitialized();

  // 🚨 모델 로드
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