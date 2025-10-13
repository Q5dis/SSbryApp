import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import 'result_screen.dart';
import '../services/waste_detector.dart'; // 🚨 추가

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  bool _isLoading = false;

  // 🚨 수정: 이미지 선택 후 모델 추론 실행
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();

        setState(() {
          _imageBytes = bytes;
          _isLoading = true;
        });

        // 🚨 모델 추론 실행
        final result = await WasteDetector.instance.detectWaste(bytes);

        setState(() {
          _isLoading = false;
        });

        // 🚨 추론 결과를 ResultScreen으로 전달
        if (result != null && mounted) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                imageBytes: bytes,
                category: result['category'] ?? 'unknown',
                confidence: result['confidence'] ?? 0.0,
              ),
            ),
          );
        } else {
          // 추론 실패 시
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('쓰레기 분류에 실패했습니다.')),
          );
        }

        setState(() {
          _imageBytes = null;
        });
      }
    } catch (e) {
      print('이미지 선택 또는 추론 오류: $e');
      if (_isLoading) setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류가 발생했습니다: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _imageBytes == null ? _buildInitialState() : _buildImageState(),
    );
  }

  // 초기 화면 (버튼)
  Widget _buildInitialState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'SSbry',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 60),

        // 갤러리 선택 버튼
        _buildActionButton(
          onPressed: () => _pickImage(ImageSource.gallery),
          icon: Icons.photo_library,
          label: '갤러리에서 선택',
          isPrimary: true,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // 이미지 로딩 화면
  Widget _buildImageState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.memory(
              _imageBytes!,
              fit: BoxFit.contain,
            ),
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF27631F)),
                SizedBox(width: 15),
                Text(
                  '쓰레기를 분석 중입니다...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        else
          const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required bool isPrimary,
  }) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : onPressed,
      icon: Icon(icon, size: 28),
      label: Text(label, style: const TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? const Color(0xFF27631F) : Colors.white,
        foregroundColor: isPrimary ? const Color(0xFFF5F4D4) : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPrimary
              ? BorderSide.none
              : const BorderSide(color: Color(0xFF27631F), width: 1.5),
        ),
        disabledBackgroundColor: Colors.grey,
      ),
    );
  }
}