import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math';
import 'dart:async';
import '../widgets/bottom_nav.dart';
import 'dictionary_screen.dart';
import 'waste_gallery.dart';
import 'pond_screen.dart';
import '../widgets/appbar_layout.dart';
import '../datas/energy_facts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> posts = const [
    {'title': '연못 타이머', 'content': '연못이 더러워지면 쓰레기를 분리할 시간'},
    {'title': '쓰레기 백과사전', 'content': '쓰레기에 대한 흥미로운 아티클'},
    {'title': '쓰레기 갤러리', 'content': '나의 쓰레기 기록들'}
  ];

  late String randomFact;
  String currentPondImage = 'assets/images/pond_good.png';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateRandomFact();
    _checkPondState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkPondState();
    });
  }

  Future<void> _checkPondState() async {
    final prefs = await SharedPreferences.getInstance();
    final startTimestamp = prefs.getInt('timer_start_timestamp');

    if (startTimestamp == null) {
      if (mounted) {
        setState(() {
          currentPondImage = 'assets/images/pond_good.png';
        });
      }
      return;
    }

    final hours = prefs.getInt('timer_hours') ?? 0;
    final minutes = prefs.getInt('timer_minutes') ?? 0;
    final seconds = prefs.getInt('timer_seconds') ?? 0;

    final timerDuration = Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );

    final startTime = DateTime.fromMillisecondsSinceEpoch(startTimestamp);
    final currentTime = DateTime.now();
    final elapsed = currentTime.difference(startTime);

    if (mounted) {
      if (elapsed >= timerDuration) {
        setState(() {
          currentPondImage = 'assets/images/pond_evil.png';
        });
      } else {
        setState(() {
          currentPondImage = 'assets/images/pond_good.png';
        });
      }
    }
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
        color: const Color(0xFFF5F4D4),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                              '💡랜덤 에너지 지식',
                              style: TextStyle(
                                fontSize: 19,
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
                                  color: const Color(0xFF27631F),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  randomFact,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Color(0xFFF5F4D4),
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

                const SizedBox(height: 60),
                const Text(
                  '올바른 분리수거 습관으로\n나의 연못을 가꾸어 보세요',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 80),
                Image.asset(
                  currentPondImage,
                  width: 300,
                  height: 300,
                ),
                const SizedBox(height: 50),

                const SizedBox(height: 20),
                // 기존 리스트
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      color: Colors.white,
                      elevation: 0,
                      child: ListTile(
                        title: Text(
                          post['title']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          post['content']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () async {
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
                          } else if (post['title'] == '연못 타이머') {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PondScreen(),
                              ),
                            );
                            // PondScreen에서 돌아온 후 연못 상태 다시 확인
                            _checkPondState();
                          }
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
