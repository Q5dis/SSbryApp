import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

// 프로젝트 구조에 맞게 import
import 'result_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  bool _isLoading = false;

  // 이미지 선택 후 바로 ResultScreen으로 이동
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

        // 바로 ResultScreen으로 이동
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              imageBytes: bytes,
              text: '선택한 이미지입니다.', // 심플 UI용 임시 텍스트
            ),
          ),
        );

        setState(() {
          _isLoading = false;
          _imageBytes = null;
        });
      }
    } catch (e) {
      print('이미지 선택 오류: $e');
      if (_isLoading) setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 불러오는 중 오류가 발생했습니다.')),
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
                  '이미지를 준비 중입니다...',
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
