import 'package:child_sound/core/services/settings_service.dart';
import 'package:child_sound/core/services/storage_keys.dart';
import 'package:child_sound/shared/widgets/learning_pager_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../model/alphabet.dart';

class LetterPagerScreen extends StatelessWidget {
  final List<AlphabetItem> alphabets;
  final int initialIndex;
  final FlutterTts _tts = FlutterTts();

  LetterPagerScreen({
    super.key,
    required this.alphabets,
    required this.initialIndex,
  });

  Future<void> _speak(String text) async {
    if (!await SettingsService.isSoundEnabled()) return;
    await _tts.setLanguage("fa");
    await _tts.setSpeechRate(0.5);
    await _tts.speak(text);
    await _tts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return LearningPagerScreen(
      itemCount: alphabets.length,
      initialIndex: initialIndex,
      storageKey: StorageKeys.completedAlphabets,
      title: "یادگیری حرف",
      appBarColor: Colors.purpleAccent,
      progressColor: Colors.deepPurple,
      onPageChanged: (index) => _speak(
        "${alphabets[index].letter} ${alphabets[index].word}",
      ),
      onPlay: (index) => _speak(
        "${alphabets[index].letter} ${alphabets[index].word}",
      ),
      itemBuilder: (context, index) {
        final item = alphabets[index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 140)),
            const SizedBox(height: 30),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.letter,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 90,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              item.word,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 45, fontWeight: FontWeight.w600),
            ),
          ],
        );
      },
    );
  }
}
