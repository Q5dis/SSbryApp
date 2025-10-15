import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import 'result_screen.dart';
import '../services/waste_detector.dart';
import '../services/gallery_service.dart'; // 🚨 추가
import '../widgets/appbar_layout.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  final GalleryService _galleryService = GalleryService(); // 🚨 추가
  Uint8List? _imageBytes;
  bool _isLoading = false;

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

        final result = await WasteDetector.instance.detectWaste(bytes);

        setState(() {
          _isLoading = false;
        });

        if (result != null && mounted) {
          final category = result['category'] ?? 'unknown'; // 🚨 변수 추출
          final confidence = result['confidence'] ?? 0.0; // 🚨 변수 추출

          // 유효한 이미지만 저장
          if (category != 'unknown') {
            _galleryService.addItem(bytes, category);
          }
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                imageBytes: bytes,
                category: category,
                confidence: confidence,
              ),
            ),
          );
        } else {
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
    return AppBarLayout(
      body: Container(
        color: const Color(0xFFF5F4D4),
        child: Center(
          child: _imageBytes == null ? _buildInitialState() : _buildImageState(),
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/icon.png',width: 70,height: 70,),
        const SizedBox(height: 40),

        _buildActionButton(
          onPressed: () => _pickImage(ImageSource.gallery),
          icon: Icons.photo_library,
          label: '갤러리',
          isPrimary: true,
          iconColor: const Color(0xFFF5F4D4),
        ),

        const Text(
          '\n\n갤러리에서 분석할 쓰레기 \n사진을 선택해주세요.\n\n',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            height: 1.5,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

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
    required Color iconColor,
  }) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : onPressed,
      icon: Icon(icon, size: 28, color: iconColor),
      label: Text(label, style: TextStyle(fontSize: 18, color: iconColor)),
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
        disabledBackgroundColor: const Color(0xFFF5F4D4),
      ),
    );
  }
}