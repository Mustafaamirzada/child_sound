import 'package:child_sound/core/services/storage_keys.dart';
import 'package:child_sound/features/words/data/words_list.dart';
import 'package:child_sound/features/words/presentation/widgets/word_list_screen.dart';
import 'package:flutter/material.dart';

class FiveSyllableScreen extends StatelessWidget {
  const FiveSyllableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WordListScreen(
      title: "کلمات پنج هجایی",
      storageKey: StorageKeys.wordLevelFive,
      words: fiveSyllableWords,
      gradientColors: [Colors.blueAccent, Colors.blue],
    );
  }
}
