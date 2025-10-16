import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreditScreen extends StatelessWidget {
  const CreditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F4D4),
      extendBody: true,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              SvgPicture.asset(
                'assets/images/icon.svg',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 40),
              const Text(
                'TEAM.\n쓰벌자들',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const Text(
                '쓰레기를 버리는것을\n도와주는 자들',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 40),
              const Text(
                '쓰버리(SSbry)란?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.5),
              ),
              const Text(
                '올바른 분리수거 방식 교육과\n신재생에너지에 대한 인식을\n높이기 위한 프로젝트',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 16, color: Colors.black87, height: 1.6),
              ),
              const SizedBox(height: 60),
              const Text(
                '팀장 오왕경\n디자인 및 앱개발\nqowkqowk@gmail.com',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 40),
              const Text(
                '최하연\n쓰레기 분류 모델개발\nemailex@naver.com',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 40),
              const Text(
                '윤태훈\n쓰레기 분류 모델개발\nemailrandom@gmail.com',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
