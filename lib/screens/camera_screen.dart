import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'result_screen.dart';
import '../services/waste_detector.dart';
import '../services/gallery_service.dart';
import '../widgets/appbar_layout.dart';
import '../main.dart'; // cameras 전역 변수 가져오기

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  final GalleryService _galleryService = GalleryService();
  Uint8List? _imageBytes;
  bool _isLoading = false;

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        await _processImage(bytes);
      }
    } catch (e) {
      print('갤러리 선택 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
    }
  }

  Future<void> _takePhoto() async {
    try {
      if (cameras.isEmpty) {
        throw Exception('사용 가능한 카메라가 없습니다.');
      }

      if (!mounted) return;

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPreviewScreen(camera: cameras.first),
        ),
      );

      if (result != null && result is Uint8List) {
        await _processImage(result);
      }
    } catch (e) {
      print('카메라 촬영 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('카메라 오류: $e')),
        );
      }
    }
  }

  // 이미지 처리 공통 함수
  Future<void> _processImage(Uint8List bytes) async {
    setState(() {
      _imageBytes = bytes;
      _isLoading = true;
    });

    try {
      final result = await WasteDetector.instance.detectWaste(bytes);

      setState(() {
        _isLoading = false;
      });

      if (result != null && mounted) {
        final category = result['category'] ?? 'unknown';
        final confidence = result['confidence'] ?? 0.0;

        if (category != 'unknown') {
          _galleryService.addItem(bytes, category);
        }

        // =========================
        // 타이머 초기화
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(
            'timer_start_timestamp', DateTime.now().millisecondsSinceEpoch);
        // =========================

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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('쓰레기 분류에 실패했습니다.')),
          );
        }
      }
    } catch (e) {
      print('이미지 처리 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('처리 오류: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _imageBytes = null;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarLayout(
      body: Container(
        color: const Color(0xFFF5F4D4),
        child: Center(
          child:
          _imageBytes == null ? _buildInitialState() : _buildImageState(),
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '\n\n카메라로 촬영하거나\n갤러리에서 분석할 쓰레기\n사진을 선택해주세요.\n\n',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            height: 1.5,
            letterSpacing: 0.5,
          ),
        ),
        _buildActionButton(
          onPressed: _takePhoto,
          icon: Icons.camera_alt,
          label: '카메라로 촬영',
          isPrimary: true,
          iconColor: const Color(0xFFF5F4D4),
        ),
        const SizedBox(height: 16),
        _buildActionButton(
          onPressed: _pickFromGallery,
          icon: Icons.photo_library,
          label: '갤러리에서 선택',
          isPrimary: false,
          iconColor: const Color(0xFF27631F),
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

// 카메라 프리뷰 화면
class CameraPreviewScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraPreviewScreen({super.key, required this.camera});

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      final bytes = await File(image.path).readAsBytes();

      if (mounted) {
        Navigator.pop(context, bytes);
      }
    } catch (e) {
      print('사진 촬영 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Center(child: CameraPreview(_controller)),
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.white, size: 32),
                        onPressed: () => Navigator.pop(context),
                      ),
                      FloatingActionButton(
                        backgroundColor: const Color(0xFF27631F),
                        onPressed: _takePicture,
                        child: const Icon(Icons.camera_alt, size: 32),
                      ),
                      const SizedBox(width: 56),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
