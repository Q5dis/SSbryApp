import 'package:flutter/material.dart';
// import 'widgets/bottom_nav.dart'; // 더 이상 필요 없음
import 'screens/main_screen.dart'; // 🚨 새로 추가: MainScreen import

void main(){
  // ⚠️ 추후에 모델 로드 기능 등을 추가하려면 이 곳에 코드를 넣으셔야 합니다.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'SSbry',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF27631F)),
        useMaterial3: true,
      ),

      // 🚨 변경: Scaffold 대신 MainScreen을 앱의 Home으로 지정
      home: const MainScreen(),
    );
  }
}