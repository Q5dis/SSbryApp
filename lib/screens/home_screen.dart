import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'dictionary_screen.dart'; // dictionary_screen.dart import

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> posts = const [
    {'title': '나의 연못', 'content': '현재 나의 연못 상태는?'},
    {'title': '쓰레기 백과사전', 'content': '쓰레기에 대한 흥미로운 아티클'},
    {'title': '쓰레기 갤러리', 'content': '나의 쓰레기 기록들'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4D4),
      extendBody: true,
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              title: Text(post['title']!),
              subtitle: Text(
                post['content']!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                if (post['title'] == '쓰레기 백과사전') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DictionaryScreen(),
                    ),
                  );
                }
                // '나의 연못' 같은 다른 글은 아무 동작 없음
              },
            ),
          );
        },
      ),
    );
  }
}
