import 'package:child_sound/core/services/storage_keys.dart';
import 'package:child_sound/features/words/data/words_list.dart';
import 'package:child_sound/features/words/presentation/widgets/word_list_screen.dart';
import 'package:flutter/material.dart';

class TwoSyllableScreen extends StatelessWidget {
  const TwoSyllableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WordListScreen(
      title: "کلمات دو هجایی",
      storageKey: StorageKeys.wordLevelTwo,
      words: twoSyllableWords,
      gradientColors: [Colors.blue.shade300, Colors.blue],
    );
  }
}
