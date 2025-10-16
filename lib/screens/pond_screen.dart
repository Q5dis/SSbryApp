import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PondScreen extends StatefulWidget {
  const PondScreen({super.key});

  @override
  State<PondScreen> createState() => _PondScreenState();
}

class _PondScreenState extends State<PondScreen> {
  int selectedHours = 1;
  int selectedMinutes = 0;
  int selectedSeconds = 30;

  @override
  void initState() {
    super.initState();
    _loadTimerSettings();
  }

  Future<void> _loadTimerSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedHours = prefs.getInt('timer_hours') ?? 1;
      selectedMinutes = prefs.getInt('timer_minutes') ?? 0;
      selectedSeconds = prefs.getInt('timer_seconds') ?? 0;
    });
  }

  Future<void> _saveTimerSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timer_hours', selectedHours);
    await prefs.setInt('timer_minutes', selectedMinutes);
    await prefs.setInt('timer_seconds', selectedSeconds);
    await prefs.setInt(
        'timer_start_timestamp', DateTime.now().millisecondsSinceEpoch);

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
                Icon(Icons.check_circle, color: Color(0xFF27631F), size: 28),
                SizedBox(width: 10),
                Text(
                  '타이머 설정 완료',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF27631F),
                  ),
                ),
              ],
            ),
            content: Text(
              '${selectedHours.toString().padLeft(2, '0')}:${selectedMinutes.toString().padLeft(2, '0')}:${selectedSeconds.toString().padLeft(2, '0')} 후에 연못이 어두워집니다.',
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
                '연못 타이머 설정',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF27631F),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '설정한 시간이 지나면 연못이 오염됩니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),

              // 타이머 선택기
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 시
                    _buildTimePicker(
                      label: '시',
                      value: selectedHours,
                      maxValue: 23,
                      onChanged: (value) {
                        setState(() {
                          selectedHours = value;
                        });
                      },
                    ),
                    const Text(':',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    // 분
                    _buildTimePicker(
                      label: '분',
                      value: selectedMinutes,
                      maxValue: 59,
                      onChanged: (value) {
                        setState(() {
                          selectedMinutes = value;
                        });
                      },
                    ),
                    const Text(':',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    // 초
                    _buildTimePicker(
                      label: '초',
                      value: selectedSeconds,
                      maxValue: 59,
                      onChanged: (value) {
                        setState(() {
                          selectedSeconds = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 저장 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveTimerSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27631F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '타이머 설정 완료',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF5F4D4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 안내 문구
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
                          '타이머 안내',
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
                      '• 타이머를 설정하면 홈 화면의 연못이 점차 오염됩니다.\n'
                      '• 올바른 분리수거로 연못을 다시 밝게 만들어보세요\n'
                      '• 타이머는 앱을 종료해도 계속 작동합니다',
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

  Widget _buildTimePicker({
    required String label,
    required int value,
    required int maxValue,
    required Function(int) onChanged,
  }) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_drop_up, size: 32),
          onPressed: () {
            if (value < maxValue) {
              onChanged(value + 1);
            }
          },
        ),
        Container(
          width: 60,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F4D4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF27631F),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_drop_down, size: 32),
          onPressed: () {
            if (value > 0) {
              onChanged(value - 1);
            }
          },
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
