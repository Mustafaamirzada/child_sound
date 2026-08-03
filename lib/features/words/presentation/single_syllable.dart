import 'package:child_sound/core/services/storage_keys.dart';
import 'package:child_sound/features/words/data/words_list.dart';
import 'package:child_sound/features/words/presentation/widgets/word_list_screen.dart';
import 'package:flutter/material.dart';

class SingleSyllableScreen extends StatelessWidget {
  const SingleSyllableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WordListScreen(
      title: "کلمات یک هجایی",
      storageKey: StorageKeys.wordLevelOne,
      words: oneSyllableWords,
      gradientColors: [Colors.orange.shade300, Colors.deepOrange],
    );
  }
}
