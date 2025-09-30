import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90, // 높이를 90으로 증가 (카메라 버튼이 위로 나오도록)
      child: Stack(
        clipBehavior: Clip.none, // 중요! Stack 밖으로 나갈 수 있게
        alignment: Alignment.bottomCenter,
        children: [
          // 녹색 바텀바 (중앙이 둥글게 파인 형태)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 70),
              painter: BottomBarPainter(),
            ),
          ),

          // 왼쪽 메뉴 아이콘
          Positioned(
            bottom: 20,
            left: 40,
            child: IconButton(
              icon: Icon(Icons.menu, color: Color(0xFFF5F4D4), size: 28),
              onPressed: () {},
            ),
          ),

          // 오른쪽 메뉴 아이콘
          Positioned(
            bottom: 20,
            right: 40,
            child: IconButton(
              icon: Icon(Icons.menu, color: Color(0xFFF5F4D4), size: 28),
              onPressed: () {},
            ),
          ),

          // 중앙 카메라 버튼 (위로 떠있는 느낌)
          Positioned(
            bottom: 30, // 바텀바보다 30픽셀 위로
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Color(0xFFFF9900),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.white, size: 32),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 중앙이 둥글게 파인 녹색 바를 그리는 CustomPainter
class BottomBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF27631F)
      ..style = PaintingStyle.fill;

    final path = Path();

    double centerX = size.width / 2;
    double notchRadius = 40; // 파인 부분의 반지름
    double barHeight = 60;

    // 시작점 (왼쪽 하단)
    path.moveTo(0, size.height);

    // 왼쪽 변
    path.lineTo(0, size.height - barHeight);

    // 왼쪽 상단 모서리 (둥글게)
    path.quadraticBezierTo(0, size.height - barHeight - 10, 10, size.height - barHeight - 10);

    // 왼쪽에서 중앙 파인 부분까지
    path.lineTo(centerX - notchRadius - 20, size.height - barHeight - 10);

    // 중앙 파인 부분 (둥글게 파임)
    path.quadraticBezierTo(
        centerX - notchRadius, size.height - barHeight - 10,
        centerX - notchRadius + 10, size.height - barHeight
    );

    path.arcToPoint(
      Offset(centerX + notchRadius - 10, size.height - barHeight),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    path.quadraticBezierTo(
        centerX + notchRadius, size.height - barHeight - 10,
        centerX + notchRadius + 20, size.height - barHeight - 10
    );

    // 오른쪽 상단 모서리까지
    path.lineTo(size.width - 10, size.height - barHeight - 10);

    // 오른쪽 상단 모서리 (둥글게)
    path.quadraticBezierTo(
        size.width, size.height - barHeight - 10,
        size.width, size.height - barHeight
    );

    // 오른쪽 변
    path.lineTo(size.width, size.height);

    // 하단 닫기
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}