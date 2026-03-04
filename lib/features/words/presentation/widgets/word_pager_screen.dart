import 'package:audioplayers/audioplayers.dart';
import 'package:child_sound/features/words/model/words.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class WordPagerScreen extends StatefulWidget {
  final List<WordItem> words;
  final int initialIndex;
  final int completed;

  const WordPagerScreen({
    super.key,
    required this.words,
    required this.initialIndex,
    required this.completed,
  });

  @override
  State<WordPagerScreen> createState() => _WordPagerScreenState();
}

class _WordPagerScreenState extends State<WordPagerScreen> {
  late PageController _pageController;
  final AudioPlayer player = AudioPlayer();
  late ConfettiController _confettiController;

  Future<void> playSwipeSound() async {
    await player.play(AssetSource('sounds/swipe.mp3'));
  }

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  int playCount = 0;
  bool confettiPlayed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E6),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text("یادگیری کلمه"),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.words.length,
        onPageChanged: (index) async {
          await playSwipeSound();
          playCount = 0;
          confettiPlayed = false;
        },
        itemBuilder: (context, index) {
          final item = widget.words[widget.initialIndex];

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
                              value:
                                  (widget.completed + 1) / widget.words.length,
                              minHeight: 20,
                              borderRadius: BorderRadius.circular(20),
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation(
                                Colors.greenAccent,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "پیشرفت ${(index + 1)} از ${widget.words.length}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      AspectRatio(
                        aspectRatio: 1.9,
                        child: Image.asset(item.emoji),
                      ),

                      // Text(item.emoji, style: const TextStyle(fontSize: 140)),
                      const SizedBox(height: 30),
                      Text(
                        item.word,
                        style: const TextStyle(
                          fontSize: 90,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: () {
                          player.play(AssetSource(item.sound));
                          playCount++;
                          if (playCount >= 3 && !confettiPlayed) {
                            _confettiController.play();
                            confettiPlayed = true;
                          }
                        },
                        icon: const Icon(Icons.volume_up),
                        label: const Text("پخش دوباره"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
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
