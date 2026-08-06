import 'package:audioplayers/audioplayers.dart';
import 'package:child_sound/core/services/settings_service.dart';
import 'package:child_sound/core/services/stats_service.dart';
import 'package:child_sound/features/achievements/model/achievement_service.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LearningPagerScreen extends StatefulWidget {
  final int itemCount;
  final int initialIndex;
  final String storageKey;
  final String title;
  final Color appBarColor;
  final Color progressColor;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Future<void> Function(int index) onPageChanged;
  final Future<void> Function(int index) onPlay;

  const LearningPagerScreen({
    super.key,
    required this.itemCount,
    required this.initialIndex,
    required this.storageKey,
    required this.title,
    required this.appBarColor,
    required this.progressColor,
    required this.itemBuilder,
    required this.onPageChanged,
    required this.onPlay,
  });

  @override
  State<LearningPagerScreen> createState() => _LearningPagerScreenState();
}

class _LearningPagerScreenState extends State<LearningPagerScreen> {
  late PageController _pageController;
  final AudioPlayer player = AudioPlayer();
  final FlutterTts flutterTts = FlutterTts();
  late ConfettiController _confettiController;
  final Set<int> _visitedPages = {};
  int playCount = 0;
  bool confettiPlayed = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _confettiController.dispose();
    player.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> playSwipeSound() async {
    if (!await SettingsService.isSoundEnabled()) return;
    await player.play(AssetSource('sounds/swipe.mp3'));
  }

  Future<void> _markCompleted(int index) async {
    if (_visitedPages.contains(index)) return;
    _visitedPages.add(index);

    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(widget.storageKey) ?? [];
    final completed = saved.map(int.parse).toSet();
    completed.add(index);
    await prefs.setStringList(
      widget.storageKey,
      completed.map((e) => e.toString()).toList(),
    );
  }

  void _onSwipe(int index) async {
    await playSwipeSound();
    playCount = 0;
    confettiPlayed = false;
    await widget.onPageChanged(index);
    if (!_visitedPages.contains(index)) {
      await StatsService.trackWord();
    }
  }

  void _onPlayTap(int index) async {
    await widget.onPlay(index);
    playCount++;
    if (playCount >= 3 && !confettiPlayed) {
      _confettiController.play();
      confettiPlayed = true;
      await _markCompleted(index);
      await AchievementService.evaluateAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E6),
      appBar: AppBar(
        backgroundColor: widget.appBarColor,
        title: Text(widget.title),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.itemCount,
        onPageChanged: _onSwipe,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            LinearProgressIndicator(
                              value: (index + 1) / widget.itemCount,
                              minHeight: 10,
                              borderRadius: BorderRadius.circular(20),
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation(widget.progressColor),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "پیشرفت ${index + 1} از ${widget.itemCount}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: Center(child: widget.itemBuilder(context, index)),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => _onPlayTap(index),
                        icon: const Icon(Icons.volume_up),
                        label: const Text("پخش دوباره"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: const [
                      Colors.red,
                      Colors.blue,
                      Colors.green,
                      Colors.orange,
                      Colors.purple,
                      Colors.black,
                      Colors.amber,
                      Colors.brown,
                      Colors.cyan,
                      Colors.indigo,
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
