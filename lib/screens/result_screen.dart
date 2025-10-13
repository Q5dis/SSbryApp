import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../datas/waste_info.dart'; // 🚨 추가

class ResultScreen extends StatelessWidget {
  final Uint8List imageBytes;
  final String category; // 🚨 변경: 카테고리 받기
  final double confidence; // 🚨 추가: 신뢰도 받기

  const ResultScreen({
    Key? key,
    required this.imageBytes,
    required this.category,
    required this.confidence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 🚨 카테고리에 맞는 정보 가져오기
    final wasteInfo = wasteDatabase[category];
    final isUnknown = category == 'unknown' || wasteInfo == null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4D4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F4D4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'SSbry',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 선택한 이미지
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    imageBytes,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🚨 분류 결과 상자
              if (!isUnknown) ...[
                _buildInfoCard(
                  title: '분류 결과',
                  content: '${wasteInfo!.koreanName} (${(confidence * 100).toStringAsFixed(1)}%)',
                  color: Color(wasteInfo.colorCode),
                ),
                const SizedBox(height: 16),

                _buildInfoCard(
                  title: '배출 방법',
                  content: wasteInfo.disposalMethod,
                ),
                const SizedBox(height: 16),

                _buildInfoCard(
                  title: '에너지 정보',
                  content: wasteInfo.energyInfo,
                ),

                if (wasteInfo.caution.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    title: '⚠️ 주의사항',
                    content: wasteInfo.caution,
                    color: Colors.orange[100],
                  ),
                ],
              ] else ...[
                // 🚨 인식 실패 시
                _buildInfoCard(
                  title: '분류 실패',
                  content: '쓰레기를 인식할 수 없습니다. 다른 각도에서 다시 촬영해주세요.',
                  color: Colors.red[100],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // 정보 카드 위젯
  Widget _buildInfoCard({
    required String title,
    required String content,
    Color? color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}