import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

void main() async {
  // 플러터 엔진 초기화를 기다림
  WidgetsFlutterBinding.ensureInitialized();
  // 기기의 카메라 목록을 가져옴
  final cameras = await availableCameras();
  runApp(CameraScreen(cameras: cameras));
}

class CameraScreen extends StatelessWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F4D4),
      extendBody: true,
      body: Center(
        child: Text('Camera Screen'),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}
