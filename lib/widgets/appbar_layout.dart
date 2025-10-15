// widget/appbar_layout.dart
import 'package:flutter/material.dart';

class AppBarLayout extends StatelessWidget {
  final Widget body;

  const AppBarLayout({
    Key? key,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F4D4),
        centerTitle: true,
        title: Image.asset(
          'assets/images/textlogo.png',
          height: 20, // 로고 높이 조절
          fit: BoxFit.contain,
        ),
      ),
      body: body,
    );
  }
}