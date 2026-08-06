import 'dart:convert';
import 'package:child_sound/core/services/storage_keys.dart';
import 'package:child_sound/features/alphabets/data/alphabets_list.dart';
import 'package:child_sound/features/words/data/words_list.dart';
import 'package:child_sound/features/words/model/words.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordLevelProgress {
  final String title;
  final int completed;
  final int total;
  final Color color;

  const WordLevelProgress({
    required this.title,
    required this.completed,
    required this.total,
    required this.color,
  });

  double get percent => total == 0 ? 0 : completed / total;
}

class StatsService {
  static const _wordsKey = "stats_words_per_day";
  static const _quizKey = "stats_quiz_scores";
  static const _dateKey = "stats_last_active";
  static const _streakKey = "stats_streak";

  static String _today() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  static Future<void> trackWord() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _today();
    final raw = prefs.getString(_wordsKey) ?? "{}";
    final map = Map<String, dynamic>.from(jsonDecode(raw));
    map[today] = ((map[today] as int?) ?? 0) + 1;
    await prefs.setString(_wordsKey, jsonEncode(map));
    await _updateActivity(today);
  }

  static Future<void> trackQuizScore(int correct, int total) async {
    final prefs = await SharedPreferences.getInstance();
    final today = _today();
    final raw = prefs.getString(_quizKey) ?? "{}";
    final map = Map<String, dynamic>.from(jsonDecode(raw));
    final entries = map[today] as List<dynamic>? ?? [];
    entries.add({"c": correct, "t": total});
    map[today] = entries;
    await prefs.setString(_quizKey, jsonEncode(map));
    await _updateActivity(today);
  }

  static Future<void> _updateActivity(String date) async {
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString(_dateKey);
    final streak = prefs.getInt(_streakKey) ?? 0;
    if (lastDate == null) {
      await prefs.setInt(_streakKey, 1);
    } else if (lastDate != date) {
      final yesterday = DateFormat('yyyy-MM-dd').format(
        DateTime.now().subtract(const Duration(days: 1)),
      );
      await prefs.setInt(_streakKey, lastDate == yesterday ? streak + 1 : 1);
    }
    await prefs.setString(_dateKey, date);
  }

  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  static Future<int> getTodayWords() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_wordsKey) ?? "{}";
    final map = Map<String, dynamic>.from(jsonDecode(raw));
    return (map[_today()] as int?) ?? 0;
  }

  static Future<Map<String, int>> getWeeklyWords() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_wordsKey) ?? "{}";
    final map = Map<String, dynamic>.from(jsonDecode(raw));
    final result = <String, int>{};
    for (int i = 6; i >= 0; i--) {
      final d = DateFormat('yyyy-MM-dd').format(
        DateTime.now().subtract(Duration(days: i)),
      );
      result[d] = (map[d] as int?) ?? 0;
    }
    return result;
  }

  static Future<int> getCompletedLetters() async {
    final prefs = await SharedPreferences.getInstance();
    const key = StorageKeys.completedAlphabets;
    final saved = prefs.getStringList(key) ?? [];
    return saved.length;
  }

  static Future<int> getTotalLetters() async => alphabets.length;

  static Future<int> getCompletedWords() async {
    final prefs = await SharedPreferences.getInstance();
    var count = 0;
    for (final entry in _wordLevels) {
      count += (prefs.getStringList(entry.storageKey) ?? []).length;
    }
    return count;
  }

  static Future<int> getTotalWords() async {
    var count = 0;
    for (final entry in _wordLevels) {
      count += entry.words.length;
    }
    return count;
  }

  static Future<List<WordLevelProgress>> getWordLevelProgress() async {
    final prefs = await SharedPreferences.getInstance();
    return _wordLevels.map((entry) {
      final completed = (prefs.getStringList(entry.storageKey) ?? []).length;
      return WordLevelProgress(
        title: entry.title,
        completed: completed,
        total: entry.words.length,
        color: entry.color,
      );
    }).toList();
  }

  static Future<void> migrateLegacyKeys() async {
    final prefs = await SharedPreferences.getInstance();
    for (final entry in StorageKeys.legacyWordKeys.entries) {
      if (prefs.getStringList(entry.key) == null) {
        final legacy = prefs.getStringList(entry.value);
        if (legacy != null) {
          await prefs.setStringList(entry.key, legacy);
        }
      }
    }
  }

  static final _wordLevels = <_WordLevel>[
    _WordLevel(
      title: "یک هجایی",
      storageKey: StorageKeys.wordLevelOne,
      words: oneSyllableWords,
      color: Colors.teal,
    ),
    _WordLevel(
      title: "دو هجایی",
      storageKey: StorageKeys.wordLevelTwo,
      words: twoSyllableWords,
      color: Colors.purple,
    ),
    _WordLevel(
      title: "سه هجایی",
      storageKey: StorageKeys.wordLevelThree,
      words: threeSyllableWords,
      color: Colors.orange,
    ),
    _WordLevel(
      title: "چهار هجایی",
      storageKey: StorageKeys.wordLevelFour,
      words: fourSyllableWords,
      color: Colors.pink,
    ),
    _WordLevel(
      title: "پنج هجایی",
      storageKey: StorageKeys.wordLevelFive,
      words: fiveSyllableWords,
      color: Colors.indigo,
    ),
  ];

  static Future<Map<String, int>> getQuizHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_quizKey) ?? "{}";
    final map = Map<String, dynamic>.from(jsonDecode(raw));
    final result = <String, int>{};
    for (int i = 6; i >= 0; i--) {
      final d = DateFormat('yyyy-MM-dd').format(
        DateTime.now().subtract(Duration(days: i)),
      );
      final entries = map[d] as List<dynamic>? ?? [];
      if (entries.isEmpty) {
        result["$d-correct"] = 0;
        result["$d-total"] = 0;
      } else {
        int c = 0, t = 0;
        for (final e in entries) {
          c += (e["c"] as int?) ?? 0;
          t += (e["t"] as int?) ?? 0;
        }
        result["$d-correct"] = c;
        result["$d-total"] = t;
      }
    }
    return result;
  }

  static Future<double> getOverallAccuracy() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_quizKey) ?? "{}";
    final map = Map<String, dynamic>.from(jsonDecode(raw));
    int correct = 0, total = 0;
    for (final entries in map.values) {
      for (final e in entries as List<dynamic>) {
        correct += (e["c"] as int?) ?? 0;
        total += (e["t"] as int?) ?? 0;
      }
    }
    if (total == 0) return 0;
    return correct / total;
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_wordsKey);
    await prefs.remove(_quizKey);
    await prefs.remove(_dateKey);
    await prefs.remove(_streakKey);
  }
}

class _WordLevel {
  final String title;
  final String storageKey;
  final List<WordItem> words;
  final Color color;

  const _WordLevel({
    required this.title,
    required this.storageKey,
    required this.words,
    required this.color,
  });
}
