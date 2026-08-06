import 'package:child_sound/core/services/settings_service.dart';
import 'package:child_sound/core/services/stats_service.dart';
import 'package:child_sound/core/services/storage_keys.dart';
import 'package:child_sound/core/theme/app_theme.dart';
import 'package:child_sound/features/achievements/model/achievement.dart';
import 'package:child_sound/features/achievements/model/achievement_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = "";
  int _streak = 0;
  int _todayWords = 0;
  double _accuracy = 0;
  int _totalLetters = 0;
  List<Achievement> _achievements = [];
  bool _soundEnabled = true;
  bool _darkMode = false;
  bool _reminderEnabled = true;

  final List<String> _avatars = [
    "🧒", "👧", "👦", "👶", "🧑", "👨‍🎓", "👩‍🎓", "🦸", "🧝", "🧙"
  ];
  String _selectedAvatar = "🧒";

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString("userName") ?? "";
    final avatar = prefs.getString("userAvatar") ?? "🧒";

    final streak = await StatsService.getStreak();
    final todayWords = await StatsService.getTodayWords();
    final accuracy = await StatsService.getOverallAccuracy();
    final letters = await StatsService.getCompletedLetters();
    final ach = await AchievementService.getUnlocked();
    final sound = await SettingsService.isSoundEnabled();
    final dark = await SettingsService.isDarkMode();
    final reminder = await SettingsService.isReminderEnabled();

    setState(() {
      _name = name;
      _selectedAvatar = avatar;
      _streak = streak;
      _todayWords = todayWords;
      _accuracy = accuracy;
      _totalLetters = letters;
      _achievements = ach;
      _soundEnabled = sound;
      _darkMode = dark;
      _reminderEnabled = reminder;
    });
  }

  Future<void> _editName() async {
    final controller = TextEditingController(text: _name);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("ویرایش نام"),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "نام کودک را وارد کنید",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("لغو")),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
            child: const Text("ذخیره"),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("userName", result);
      setState(() => _name = result);
    }
  }

  Future<void> _resetProgress() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("پاک کردن پیشرفت"),
        content: const Text("همه حروف، کلمات و دستاوردها پاک خواهند شد. مطمئن هستی؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("لغو")),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("پاک کن"),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final prefs = await SharedPreferences.getInstance();
    for (final key in StorageKeys.allProgressKeys) {
      await prefs.remove(key);
    }
    for (final legacyKey in StorageKeys.legacyWordKeys.values) {
      await prefs.remove(legacyKey);
    }
    await StatsService.reset();
    setState(() {});
    await _load();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("پیشرفت پاک شد")),
    );
  }

  Future<void> _pickAvatar() async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("انتخاب آواتار"),
        content: Wrap(
          spacing: 12, runSpacing: 12,
          alignment: WrapAlignment.center,
          children: _avatars.map((a) => GestureDetector(
            onTap: () => Navigator.pop(ctx, a),
            child: Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: _selectedAvatar == a ? Colors.deepPurple.withOpacity(0.1) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _selectedAvatar == a ? Colors.deepPurple : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Center(child: Text(a, style: const TextStyle(fontSize: 28))),
            ),
          )).toList(),
        ),
      ),
    );
    if (result != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("userAvatar", result);
      setState(() => _selectedAvatar = result);
    }
  }

  String _levelLabel() {
    if (_totalLetters >= 32) return "استاد";
    if (_totalLetters >= 16) return "پیشرفته";
    if (_totalLetters >= 8) return "متوسط";
    return "مبتدی";
  }

  @override
  Widget build(BuildContext context) {
    final unlockedCount = _achievements.where((a) => a.isUnlocked).length;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: Colors.deepPurple,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: _pickAvatar,
                        child: Stack(
                          children: [
                            Container(
                              width: 80, height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))],
                              ),
                              child: Center(child: Text(_selectedAvatar, style: const TextStyle(fontSize: 40))),
                            ),
                            Positioned(
                              bottom: 0, right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                                child: const Icon(Icons.edit, size: 14, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _editName,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _name.isNotEmpty ? _name : "مصطفی",
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.edit, size: 18, color: Colors.white70),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _levelLabel(),
                          style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildStatsGrid(),
                  const SizedBox(height: 16),
                  _buildAchievementsCard(unlockedCount),
                  const SizedBox(height: 16),
                  _buildSettingsCard(),
                  const SizedBox(height: 16),
                  _buildResetCard(),
                  const SizedBox(height: 16),
                  _buildAboutCard(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.deepPurple.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.analytics, color: Colors.deepPurple, size: 20),
              ),
              const SizedBox(width: 10),
              const Text("آمار کلی", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _statTile(Icons.abc, "حروف", "$_totalLetters", Colors.deepPurple)),
              const SizedBox(width: 8),
              Expanded(child: _statTile(Icons.menu_book, "امروز", "$_todayWords", Colors.teal)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _statTile(Icons.local_fire_department, "مداومت", "$_streak روز", Colors.orange)),
              const SizedBox(width: 8),
              Expanded(child: _statTile(Icons.check_circle, "دقت", "${(_accuracy * 100).toInt()}%", Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statTile(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsCard(int unlockedCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
              ),
              const SizedBox(width: 10),
              const Text("دستاوردها", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
              const Spacer(),
              Text("$unlockedCount/${AchievementService.allAchievements.length}",
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 14),
          if (_achievements.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text("هنوز دستاوردی نداری! شروع به یادگیری کن 🎯", style: TextStyle(color: Colors.grey)),
            )
          else
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _achievements.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, i) {
                  final a = _achievements[i];
                  return Column(
                    children: [
                      Container(
                        width: 46, height: 46,
                        decoration: BoxDecoration(
                          color: a.isUnlocked ? Colors.amber.withOpacity(0.15) : Colors.grey.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: a.isUnlocked ? Colors.amber : Colors.grey.shade300),
                        ),
                        child: Center(child: Text(a.isUnlocked ? a.icon : "🔒", style: const TextStyle(fontSize: 22))),
                      ),
                      const SizedBox(height: 4),
                      Text(a.title, style: TextStyle(fontSize: 9, color: a.isUnlocked ? Colors.black87 : Colors.grey)),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.settings, color: Colors.blueGrey, size: 20),
              ),
              const SizedBox(width: 10),
              const Text("تنظیمات", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
            ],
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: _soundEnabled, onChanged: (v) async {
              setState(() => _soundEnabled = v);
              await SettingsService.setSoundEnabled(v);
            },
            title: const Text("صدا", style: TextStyle(fontSize: 14)),
            secondary: const Icon(Icons.volume_up, color: Colors.teal, size: 22),
            activeColor: Colors.deepPurple, contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            value: _darkMode, onChanged: (v) async {
              setState(() => _darkMode = v);
              await ThemeController.setDarkMode(v);
            },
            title: const Text("حالت شب", style: TextStyle(fontSize: 14)),
            secondary: const Icon(Icons.dark_mode, color: Colors.indigo, size: 22),
            activeColor: Colors.deepPurple, contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            value: _reminderEnabled, onChanged: (v) async {
              setState(() => _reminderEnabled = v);
              await SettingsService.setReminderEnabled(v);
            },
            title: const Text("یادآوری روزانه", style: TextStyle(fontSize: 14)),
            secondary: const Icon(Icons.notifications, color: Colors.orange, size: 22),
            activeColor: Colors.deepPurple, contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildResetCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.delete_forever, color: Colors.red, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("پاک کردن پیشرفت", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
                SizedBox(height: 2),
                Text("همه حروف، کلمات و دستاوردها را پاک کن", style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          TextButton(
            onPressed: _resetProgress,
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("پاک کن"),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.pink.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.info, color: Colors.pink, size: 20),
              ),
              const SizedBox(width: 10),
              const Text("درباره", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
            ],
          ),
          const SizedBox(height: 12),
          _aboutRow("نسخه", "۱.۰.۰"),
          const Divider(height: 20),
          _aboutRow("توسعه‌دهنده", "Child Sound Team"),
          const Divider(height: 20),
          _aboutRow("هدف", "آموزش الفبا و کلمات دری به کودکان"),
        ],
      ),
    );
  }

  Widget _aboutRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2D2D2D))),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4)),
      ],
    );
  }
}
