import 'package:audioplayers/audioplayers.dart';
import 'package:child_sound/core/services/settings_service.dart';
import 'package:child_sound/features/words/model/words.dart';
import 'package:child_sound/shared/widgets/learning_pager_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WordPagerScreen extends StatelessWidget {
  final List<WordItem> words;
  final int initialIndex;
  final String storageKey;
  final AudioPlayer _player = AudioPlayer();
  final FlutterTts _tts = FlutterTts();

  WordPagerScreen({
    super.key,
    required this.words,
    required this.initialIndex,
    required this.storageKey,
  });

  Future<void> _playWord(String word, String sound) async {
    if (!await SettingsService.isSoundEnabled()) return;
    await _tts.setLanguage("fa");
    await _tts.setSpeechRate(0.5);
    if (sound.isNotEmpty) {
      try {
        await _player.play(AssetSource(sound));
      } catch (_) {
        await _tts.speak(word);
      }
    } else {
      await _tts.speak(word);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LearningPagerScreen(
      itemCount: words.length,
      initialIndex: initialIndex,
      storageKey: storageKey,
      title: "یادگیری کلمه",
      appBarColor: Colors.pink,
      progressColor: Colors.greenAccent,
      onPageChanged: (index) => _playWord(words[index].word, words[index].sound),
      onPlay: (index) => _playWord(words[index].word, words[index].sound),
      itemBuilder: (context, index) {
        final item = words[index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1.9,
              child: Image.asset(
                item.emoji,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.white,
                  child: const Center(child: Text("📦", style: TextStyle(fontSize: 80))),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.word,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 90,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
