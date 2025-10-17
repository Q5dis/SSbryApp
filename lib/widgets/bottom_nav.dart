import 'package:flutter/material.dart';
import '../screens/camera_screen.dart';
import '../screens/credit_screen.dart';
import '../screens/home_screen.dart';
import 'dart:math' as math;

class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: 90 + bottomPadding,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // 녹색 바텀바
          Positioned(
            bottom: bottomPadding,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 70),
              painter: BottomBarPainter(),
            ),
          ),

          // 왼쪽 메뉴 아이콘 (Home)
          Positioned(
            bottom: 10 + bottomPadding,
            left: 80,
            child: IconButton(
              icon: Icon(
                Icons.menu,
                color: selectedIndex == 0 ? Color(0xFFF5F4D4) : const Color(0xAAFFFFFF),
                size: 28,
              ),
              onPressed: () => onTap(0),
            ),
          ),

          // 오른쪽 메뉴 아이콘 (Credit)
          Positioned(
            bottom: 10 + bottomPadding,
            right: 80,
            child: IconButton(
              icon: Icon(
                Icons.menu,
                color: selectedIndex == 2 ? Color(0xFFF5F4D4) : const Color(0xAAFFFFFF),
                size: 28,
              ),
              onPressed: () => onTap(2),
            ),
          ),

          // 중앙 카메라 버튼
          Positioned(
            bottom: 25 + bottomPadding,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Color(0xFFFF9900),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  color: Color(0xFFF5F4D4),
                  size: 32,
                ),
                onPressed: () => onTap(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 중앙이 둥글게 파인 녹색 바 CustomPainter
class BottomBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF27631F)
      ..style = PaintingStyle.fill;

    final path = Path();

    double centerX = size.width / 2;
    double notchRadius = 70;
    double barHeight = 50;

    path.moveTo(0, size.height);
    path.lineTo(0, size.height - barHeight);
    path.quadraticBezierTo(0, size.height - barHeight - 0, 0, size.height - barHeight - 10);
    path.lineTo(centerX - notchRadius - 20, size.height - barHeight - 10);
    path.quadraticBezierTo(centerX - notchRadius, size.height - barHeight - 10, centerX - notchRadius + 10, size.height - barHeight);
    path.arcToPoint(
      Offset(centerX + notchRadius - 10, size.height - barHeight),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );
    path.quadraticBezierTo(centerX + notchRadius, size.height - barHeight - 10, centerX + notchRadius + 20, size.height - barHeight - 10);
    path.lineTo(size.width, size.height - barHeight - 10);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}