import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:child_sound/core/services/settings_service.dart';
import 'package:child_sound/core/services/stats_service.dart';
import 'package:child_sound/core/theme/app_theme.dart';
import 'package:child_sound/features/achievements/model/achievement.dart';
import 'package:child_sound/features/achievements/model/achievement_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  int _streak = 0;
  int _todayWords = 0;
  double _accuracy = 0;
  String _userName = '';
  List<Achievement> _achievements = [];
  int _completedLetters = 0;
  int _totalLetters = 0;
  int _completedWords = 0;
  int _totalWords = 0;
  List<WordLevelProgress> _wordLevels = [];
  Map<String, int> _weekly = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await StatsService.getStreak();
    final tw = await StatsService.getTodayWords();
    final a = await StatsService.getOverallAccuracy();
    final ach = await AchievementService.getUnlocked();
    final prefs = await SharedPreferences.getInstance();
    final completedLetters = await StatsService.getCompletedLetters();
    final totalLetters = await StatsService.getTotalLetters();
    final completedWords = await StatsService.getCompletedWords();
    final totalWords = await StatsService.getTotalWords();
    final wordLevels = await StatsService.getWordLevelProgress();
    final weekly = await StatsService.getWeeklyWords();
    setState(() {
      _streak = s;
      _todayWords = tw;
      _accuracy = a;
      _achievements = ach;
      _userName = prefs.getString("userName") ?? '';
      _completedLetters = completedLetters;
      _totalLetters = totalLetters;
      _completedWords = completedWords;
      _totalWords = totalWords;
      _wordLevels = wordLevels;
      _weekly = weekly;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text("داشبورد والدین", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ProfileCard(userName: _userName),
              const SizedBox(height: 16),
              TodayStatsCard(todayWords: _todayWords, accuracy: _accuracy),
              const SizedBox(height: 16),
              ProgressCard(completed: _completedLetters, total: _totalLetters),
              const SizedBox(height: 16),
              StreakCard(streakDays: _streak),
              const SizedBox(height: 16),
              AchievementsCard(achievements: _achievements),
              const SizedBox(height: 16),
              WeeklyBarChartCard(values: _weekly.values.toList()),
              const SizedBox(height: 16),
              WordProgressCard(
                levels: _wordLevels,
                completedWords: _completedWords,
                totalWords: _totalWords,
              ),
              const SizedBox(height: 16),
              const SettingsCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String userName;
  const ProfileCard({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _gradientCard([Colors.deepPurple, Colors.purpleAccent]),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Colors.amber, Colors.orange]),
            ),
            child: const CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              child: Icon(Icons.child_care, color: Colors.deepPurple, size: 32),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName.isNotEmpty ? userName : "فرزند عزیز",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              const Text("سطح: مبتدی", style: TextStyle(fontSize: 14, color: Colors.white70)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 18),
                SizedBox(width: 4),
                Text("ستاره", style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TodayStatsCard extends StatelessWidget {
  final int todayWords;
  final double accuracy;
  const TodayStatsCard({super.key, required this.todayWords, required this.accuracy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _whiteCard(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(Icons.menu_book, "امروز", "$todayWords کلمه", Colors.teal),
          const SizedBox(width: 1, child: VerticalDivider(color: Colors.grey)),
          _statItem(Icons.check_circle, "دقت", "${(accuracy * 100).toInt()}%", Colors.deepPurple),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

class AchievementsCard extends StatelessWidget {
  final List<Achievement> achievements;
  const AchievementsCard({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    final unlocked = achievements.where((a) => a.isUnlocked).length;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _whiteCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.emoji_events, color: Colors.amber, size: 24),
              ),
              const SizedBox(width: 12),
              const Text("دستاوردها", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
              const Spacer(),
              Text("$unlocked/${AchievementService.allAchievements.length}",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: achievements.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final a = achievements[i];
                return Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: a.isUnlocked ? Colors.amber.withOpacity(0.15) : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: a.isUnlocked ? Colors.amber : Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text(a.isUnlocked ? a.icon : "🔒", style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(a.title, style: TextStyle(fontSize: 10, color: a.isUnlocked ? Colors.black87 : Colors.grey)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressCard extends StatelessWidget {
  final int completed;
  final int total;
  const ProgressCard({super.key, required this.completed, required this.total});

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0.0 : completed / total;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _whiteCard(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.deepPurple.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.abc, color: Colors.deepPurple, size: 24),
              ),
              const SizedBox(width: 12),
              const Text("پیشرفت الفبا", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
            ],
          ),
          const SizedBox(height: 20),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: percent),
            duration: const Duration(seconds: 2),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 140, width: 140,
                    child: CircularProgressIndicator(
                      value: value, strokeWidth: 12,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation(Colors.deepPurple),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("${(value * 100).toInt()}%",
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                      const Text("تکمیل شده", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.deepPurple.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
            child: Text("$completed از $total حرف تکمیل شده",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.deepPurple)),
          ),
        ],
      ),
    );
  }
}

class WeeklyBarChartCard extends StatelessWidget {
  final List<int> values;
  const WeeklyBarChartCard({super.key, required this.values});

  final List<String> days = const ["ش", "ی", "د", "س", "چ", "پ", "ج"];

  @override
  Widget build(BuildContext context) {
    final maxVal = values.isEmpty ? 1 : (values.reduce((a, b) => a > b ? a : b) > 0 ? values.reduce((a, b) => a > b ? a : b) : 1);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _whiteCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.teal.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.bar_chart, color: Colors.teal, size: 24),
              ),
              const SizedBox(width: 12),
              const Text("فعالیت هفتگی", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal * 1.2, minY: 0,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true, drawVerticalLine: false, horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true, reservedSize: 28,
                      getTitlesWidget: (value, meta) => Text(value.toInt().toString(),
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= days.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(days[index],
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(values.length, (i) => BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: values[i].toDouble(), width: 22,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                      gradient: LinearGradient(
                        colors: values[i] >= 5 ? [Colors.teal, Colors.greenAccent] : [Colors.deepPurple.shade300, Colors.purpleAccent],
                        begin: Alignment.bottomCenter, end: Alignment.topCenter,
                      ),
                    ),
                  ],
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StreakCard extends StatelessWidget {
  final int streakDays;
  const StreakCard({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _gradientCard([Colors.orange, Colors.deepOrange]),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: const Icon(Icons.local_fire_department, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("مداومت یادگیری", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text("$streakDays روز",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(width: 8),
                    ...List.generate(streakDays > 7 ? 7 : streakDays, (i) => Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WordProgressCard extends StatelessWidget {
  final List<WordLevelProgress> levels;
  final int completedWords;
  final int totalWords;
  const WordProgressCard({
    super.key,
    required this.levels,
    required this.completedWords,
    required this.totalWords,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _whiteCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.pink.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.menu_book, color: Colors.pink, size: 24),
              ),
              const SizedBox(width: 12),
              const Text("سطوح کلمات", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
              const Spacer(),
              Text(
                "$completedWords از $totalWords کلمه",
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...levels.map((level) {
            final percent = level.percent;
            final color = level.color;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(level.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF444444))),
                      Text("${level.completed}/${level.total} (${(percent * 100).toInt()}%)",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: percent),
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: value, minHeight: 10,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class SettingsCard extends StatefulWidget {
  const SettingsCard({super.key});

  @override
  State<SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  bool _soundEnabled = true;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sound = await SettingsService.isSoundEnabled();
    final dark = await SettingsService.isDarkMode();
    setState(() {
      _soundEnabled = sound;
      _darkMode = dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _whiteCard(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.settings, color: Colors.blueGrey, size: 24),
              ),
              const SizedBox(width: 12),
              const Text("تنظیمات", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
            ],
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: _soundEnabled, onChanged: (v) async {
              setState(() => _soundEnabled = v);
              await SettingsService.setSoundEnabled(v);
            },
            title: const Text("صدا فعال", style: TextStyle(fontSize: 14)),
            activeColor: Colors.deepPurple, contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            value: _darkMode, onChanged: (v) async {
              setState(() => _darkMode = v);
              await ThemeController.setDarkMode(v);
            },
            title: const Text("حالت شب", style: TextStyle(fontSize: 14)),
            activeColor: Colors.deepPurple, contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

BoxDecoration _whiteCard() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 6)),
      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
    ],
  );
}

BoxDecoration _gradientCard(List<Color> colors) {
  return BoxDecoration(
    gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(color: colors.last.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6)),
      BoxShadow(color: colors.first.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 2)),
    ],
  );
}
