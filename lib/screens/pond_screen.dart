import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PondScreen extends StatefulWidget {
  const PondScreen({super.key});

  @override
  State<PondScreen> createState() => _PondScreenState();
}

class _PondScreenState extends State<PondScreen> {
  // 요일별 선택 상태 (월~일)
  List<bool> selectedDays = [false, false, false, false, false, false, false];

  final List<String> dayNames = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  void initState() {
    super.initState();
    _loadWeeklySettings();
  }

  Future<void> _loadWeeklySettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < 7; i++) {
        selectedDays[i] = prefs.getBool('weekly_day_$i') ?? false;
      }
    });
  }

  Future<void> _saveWeeklySettings() async {
    // 최소 1개 이상 선택했는지 확인
    if (!selectedDays.contains(true)) {
      if (mounted) {
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
                  Icon(Icons.warning, color: Colors.orange, size: 28),
                  SizedBox(width: 10),
                  Text(
                    '요일 선택 필요',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              content: const Text(
                '최소 1개 이상의 요일을 선택해주세요.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
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
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    // 선택된 요일 저장
    for (int i = 0; i < 7; i++) {
      await prefs.setBool('weekly_day_$i', selectedDays[i]);
    }

    // 현재 주의 완료 상태 초기화
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    await prefs.setString('current_week_start', weekStart.toIso8601String());

    // 각 요일별 완료 상태 초기화
    for (int i = 0; i < 7; i++) {
      await prefs.setBool('weekly_completed_$i', false);
    }

    if (mounted) {
      // 선택된 요일 목록 생성
      List<String> selectedDayNames = [];
      for (int i = 0; i < 7; i++) {
        if (selectedDays[i]) {
          selectedDayNames.add(dayNames[i]);
        }
      }

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
                Icon(Icons.check_circle, color: Color(0xFF27631F), size: 28),
                SizedBox(width: 10),
                Text(
                  '요일 설정 완료',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF27631F),
                  ),
                ),
              ],
            ),
            content: Text(
              '${selectedDayNames.join(', ')}요일마다 연못이 오염됩니다.\n올바른 분리수거로 연못을 정화해주세요!',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4D4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F4D4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(
          'assets/images/textlogo.png',
          height: 20,
          fit: BoxFit.contain,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '연못 요일 설정',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF27631F),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '분리수거할 요일을 설정해주세요',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ...List.generate(7, (index) {
                      return CheckboxListTile(
                        title: Text(
                          '${dayNames[index]}요일',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        value: selectedDays[index],
                        activeColor: const Color(0xFF27631F),
                        onChanged: (bool? value) {
                          setState(() {
                            selectedDays[index] = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveWeeklySettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27631F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '요일 설정 완료',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF5F4D4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Color(0xFF27631F), size: 20),
                        SizedBox(width: 8),
                        Text(
                          '요일 설정 안내',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF27631F),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '• 선택한 요일마다 홈 화면의 연못이 오염됩니다.\n'
                          '• 올바른 분리수거로 연못을 다시 밝게 만들어보세요!\n'
                          '• 해당 요일에 분리수거를 하면 연못이 정화됩니다.\n'
                          '• 설정은 앱을 종료해도 계속 유지됩니다.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}