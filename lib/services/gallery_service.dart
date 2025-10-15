import 'dart:typed_data';

// 간단한 갤러리 아이템 클래스
class GalleryItem {
  final Uint8List imageBytes;
  final String category;
  final DateTime date;

  GalleryItem(this.imageBytes, this.category, this.date);
}

// 갤러리 서비스
class GalleryService {
  static final GalleryService _instance = GalleryService._internal();
  factory GalleryService() => _instance;
  GalleryService._internal();

  final List<GalleryItem> items = [];

  void addItem(Uint8List imageBytes, String category) {
    items.insert(0, GalleryItem(imageBytes, category, DateTime.now()));
  }
}