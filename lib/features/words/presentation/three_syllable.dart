import 'package:child_sound/core/services/storage_keys.dart';
import 'package:child_sound/features/words/data/words_list.dart';
import 'package:child_sound/features/words/presentation/widgets/word_list_screen.dart';
import 'package:flutter/material.dart';

class ThreeSyllableScreen extends StatelessWidget {
  const ThreeSyllableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WordListScreen(
      title: "کلمات سه هجایی",
      storageKey: StorageKeys.wordLevelThree,
      words: threeSyllableWords,
      gradientColors: [Colors.green.shade300, Colors.green],
    );
  }
}
