import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'home_screen.dart';       // (기존 파일)
import 'camera_screen.dart';     // (기존 파일)
import 'credit_screen.dart';     // (기존 파일)

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 현재 선택된 탭 인덱스 (Home: 0, Camera: 1, Credit: 2)
  int _selectedIndex = 0;

  // 각 인덱스에 매핑될 화면 목록
  final List<Widget> _screens = [
    const HomeScreen(),      // Index 0
    const CameraScreen(),    // Index 1
    const CreditScreen(),    // Index 2
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4D4),
      extendBody: true,

      // 1. 선택된 인덱스에 따라 body 화면을 변경합니다.
      body: _screens[_selectedIndex],

      // 2. CustomBottomBar에 현재 상태와 콜백 함수를 전달합니다.
      bottomNavigationBar: CustomBottomBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}