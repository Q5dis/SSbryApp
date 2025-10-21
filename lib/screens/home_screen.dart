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
    {'title': '연못 설정', 'content': '연못이 더러워지면 쓰레기를 분리할 시간'},
    {'title': '쓰레기 백과사전', 'content': '쓰레기에 대한 흥미로운 아티클'},
    {'title': '쓰레기 갤러리', 'content': '나의 쓰레기 기록들'}
  ];

  late String randomFact;
  String currentPondImage = 'assets/images/pond_good.png';
  Timer? _timer;
  bool _hasShownPopup = false;

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
    // 1분마다 체크 (너무 자주 체크할 필요 없음)
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkPondState();
    });
  }

  Future<void> _checkPondState() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    // 현재 요일 (월요일=1, 일요일=7) → 인덱스 (월요일=0, 일요일=6)
    final currentDayIndex = now.weekday - 1;

    // 선택된 요일들 불러오기
    List<bool> selectedDays = [];
    for (int i = 0; i < 7; i++) {
      selectedDays.add(prefs.getBool('weekly_day_$i') ?? false);
    }

    // 선택된 요일이 없으면 기본 상태 (깨끗한 연못)
    if (!selectedDays.contains(true)) {
      if (mounted) {
        setState(() {
          currentPondImage = 'assets/images/pond_good.png';
        });
      }
      return;
    }

    // 주가 바뀌었는지 확인 (매주 월요일에 리셋)
    final savedWeekStart = prefs.getString('current_week_start');
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartStr = DateTime(weekStart.year, weekStart.month, weekStart.day).toIso8601String();

    if (savedWeekStart != weekStartStr) {
      // 새로운 주가 시작됨 - 모든 완료 상태 초기화
      await prefs.setString('current_week_start', weekStartStr);
      for (int i = 0; i < 7; i++) {
        await prefs.setBool('weekly_completed_$i', false);
      }
    }

    // 오늘이 선택된 요일인지 확인
    final isTodaySelected = selectedDays[currentDayIndex];

    if (!isTodaySelected) {
      // 오늘은 선택된 요일이 아님 → 깨끗한 연못
      if (mounted) {
        setState(() {
          currentPondImage = 'assets/images/pond_good.png';
        });
      }
      return;
    }

    // 오늘의 완료 여부 확인
    final isTodayCompleted = prefs.getBool('weekly_completed_$currentDayIndex') ?? false;

    if (isTodayCompleted) {
      // 오늘 이미 분리수거 완료 → 깨끗한 연못
      if (mounted) {
        setState(() {
          currentPondImage = 'assets/images/pond_good.png';
        });
      }
    } else {
      // 오늘 아직 분리수거 안 함 → 오염된 연못
      if (mounted) {
        setState(() {
          currentPondImage = 'assets/images/pond_evil.png';
        });

        // 팝업을 오늘 아직 보여주지 않았다면 표시
        final lastPopupDate = prefs.getString('last_popup_date');
        final todayStr = DateTime(now.year, now.month, now.day).toIso8601String();

        if (!_hasShownPopup && lastPopupDate != todayStr) {
          _hasShownPopup = true;
          await prefs.setString('last_popup_date', todayStr);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _showPollutionAlert();
            }
          });
        }
      }
    }
  }

  void _showPollutionAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 10),
              Text(
                '연못이 오염됐어요!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          content: const Text(
            '정화하기 위해 쓰레기를 분리수거 합시다!\n\n카메라 탭에서 쓰레기를 촬영하면 연못이 깨끗해집니다.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '확인',
                style: TextStyle(
                  color: Color(0xFF27631F),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
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
                          } else if (post['title'] == '연못 설정') {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PondScreen(),
                              ),
                            );
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