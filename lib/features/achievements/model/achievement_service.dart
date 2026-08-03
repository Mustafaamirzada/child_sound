import 'package:child_sound/core/services/stats_service.dart';
import 'package:child_sound/core/services/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'achievement.dart';

class AchievementService {
  static const _unlockedKey = StorageKeys.achievementsUnlocked;

  static final List<Achievement> allAchievements = [
    const Achievement(id: "first_letter", title: "اولین حرف", description: "اولین حرف را یاد گرفتی", icon: "🔤"),
    const Achievement(id: "alphabet_master", title: "استاد الفبا", description: "همه حروف الفبا را یاد گرفتی", icon: "🏆"),
    const Achievement(id: "first_word", title: "اولین کلمه", description: "اولین کلمه را خواندی", icon: "📖"),
    const Achievement(id: "word_collector", title: "کلمه جمع‌کن", description: "۱۰ کلمه را یاد گرفتی", icon: "📚"),
    const Achievement(id: "word_master", title: "استاد کلمات", description: "۵۰ کلمه را یاد گرفتی", icon: "👑"),
    const Achievement(id: "quiz_champion", title: "قهرمان کوئیز", description: "اولین کوئیز را انجام دادی", icon: "🎯"),
    const Achievement(id: "perfect_score", title: "نمره کامل", description: "۱۰۰٪ در کوئیز", icon: "⭐"),
    const Achievement(id: "streak_7", title: "یک هفته مداوم", description: "۷ روز متوالی یادگیری", icon: "🔥"),
    const Achievement(id: "streak_30", title: "یک ماه مداوم", description: "۳۰ روز متوالی یادگیری", icon: "💪"),
    const Achievement(id: "writer", title: "نویسنده", description: "اولین کلمه را نوشتی", icon: "✍️"),
  ];

  static Future<List<Achievement>> getUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_unlockedKey) ?? [];
    return allAchievements.map((a) => a.copyWith(isUnlocked: saved.contains(a.id))).toList();
  }

  static Future<bool> isUnlocked(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_unlockedKey) ?? [];
    return saved.contains(id);
  }

  static Future<void> unlock(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_unlockedKey) ?? [];
    if (!saved.contains(id)) {
      saved.add(id);
      await prefs.setStringList(_unlockedKey, saved);
    }
  }

  static Future<void> checkAndUnlock(String id) async {
    if (!await isUnlocked(id)) {
      await unlock(id);
    }
  }

  static Future<void> evaluateAll() async {
    final completedLetters = await StatsService.getCompletedLetters();
    final totalLetters = await StatsService.getTotalLetters();
    final completedWords = await StatsService.getCompletedWords();
    final streak = await StatsService.getStreak();

    if (completedLetters >= 1) await checkAndUnlock("first_letter");
    if (completedLetters >= totalLetters) await checkAndUnlock("alphabet_master");
    if (completedWords >= 1) await checkAndUnlock("first_word");
    if (completedWords >= 10) await checkAndUnlock("word_collector");
    if (completedWords >= 50) await checkAndUnlock("word_master");
    if (streak >= 7) await checkAndUnlock("streak_7");
    if (streak >= 30) await checkAndUnlock("streak_30");
  }
}
