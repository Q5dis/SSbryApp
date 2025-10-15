import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math';
import '../widgets/bottom_nav.dart';
import 'dictionary_screen.dart';
import 'waste_gallery.dart'; // 🚨 추가
import 'pond_screen.dart'; // 🚨 추가
import '../widgets/appbar_layout.dart';
import '../datas/energy_facts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> posts = const [
    {'title': '나의 연못', 'content': '현재 나의 연못 상태는?'},
    {'title': '쓰레기 백과사전', 'content': '쓰레기에 대한 흥미로운 아티클'},
    {'title': '쓰레기 갤러리', 'content': '나의 쓰레기 기록들'}
  ];

  late String randomFact;

  @override
  void initState() {
    super.initState();
    _updateRandomFact();
  }

  void _updateRandomFact() {
    final random = Random();
    setState(() {
      randomFact = energyFacts[random.nextInt(energyFacts.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBarLayout(
      body: Container(
        padding: const EdgeInsets.all(20),
        color: const Color(0xFFF5F4D4),
        child: Column(
          children: [
            // 랜덤 팩트 섹션
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/icon.svg',
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '랜덤 에너지 팩트',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF27631F),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _updateRandomFact,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F4D4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              randomFact,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 기존 리스트
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    color: Colors.white,
                    elevation: 0,
                    child: ListTile(
                      title: Text(post['title']!),
                      subtitle: Text(
                        post['content']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        // 🚨 수정된 부분
                        if (post['title'] == '쓰레기 백과사전') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DictionaryScreen(),
                            ),
                          );
                        } else if (post['title'] == '쓰레기 갤러리') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WasteGallery(),
                            ),
                          );
                        } else if (post['title'] == '나의 연못') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PondScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}