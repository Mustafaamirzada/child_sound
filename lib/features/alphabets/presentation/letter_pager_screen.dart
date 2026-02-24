import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../model/alphabet.dart';

class LetterPagerScreen extends StatefulWidget {
  final List<AlphabetItem> alphabets;
  final int initialIndex;
  final int lockedIndex;

  const LetterPagerScreen({
    super.key,
    required this.alphabets,
    required this.initialIndex,
    required this.lockedIndex,
  });

  @override
  State<LetterPagerScreen> createState() => _LetterPagerScreenState();
}

class _LetterPagerScreenState extends State<LetterPagerScreen> {
  late PageController _pageController;
  final FlutterTts flutterTts = FlutterTts();
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
    flutterTts.stop();
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
        backgroundColor: Colors.purpleAccent,
        title: const Text("یادگیری حرف"),
      ),
      body: PageView.builder(
        controller: _pageController,
        // itemCount: widget.alphabets.length,
        itemCount: 1,
        onPageChanged: (index) async {
          await playSwipeSound();
          playCount = 0;
          confettiPlayed = false;
          // speak(widget.alphabets[index]); // Auto speak when swiping
        },
        itemBuilder: (context, index) {
          final item = widget.alphabets[widget.lockedIndex];

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
                                  (widget.lockedIndex + 1) /
                                  widget.alphabets.length,
                              minHeight: 10,
                              borderRadius: BorderRadius.circular(20),
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation(
                                Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "پیشرفت ${(widget.lockedIndex + 1)} از ${widget.alphabets.length}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      Text(item.emoji, style: const TextStyle(fontSize: 140)),
                      const SizedBox(height: 30),
                      Text(
                        item.letter,
                        style: const TextStyle(
                          fontSize: 90,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        item.word,
                        style: const TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: () {
                          player.play(AssetSource(item.word));
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
