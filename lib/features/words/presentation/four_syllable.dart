import 'package:child_sound/features/words/data/words_list.dart';
import 'package:child_sound/features/words/presentation/widgets/word_list_screen.dart';
import 'package:flutter/material.dart';

class FourSyllableScreen extends StatelessWidget {
  const FourSyllableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WordListScreen(
      title: "کلمات چهار و پنج هجایی",
      words: fourSyllableWords,
      gradientColors: [Colors.purple.shade300, Colors.purple],
    );
  }
}
