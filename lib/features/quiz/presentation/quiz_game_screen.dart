import 'package:audioplayers/audioplayers.dart';
import 'package:child_sound/features/achievements/model/achievement_service.dart';
import 'package:child_sound/features/quiz/model/quiz_data.dart';
import 'package:child_sound/features/quiz/model/quiz_question.dart';
import 'package:child_sound/features/quiz/presentation/quiz_result_screen.dart';
import 'package:child_sound/core/services/stats_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class QuizGameScreen extends StatefulWidget {
  final QuizType quizType;
  const QuizGameScreen({super.key, this.quizType = QuizType.imageToWord});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  late List<QuizQuestion> _questions;
  int _currentIndex = 0;
  int? _selectedIndex;
  int _correctCount = 0;
  bool _isAnswered = false;
  final AudioPlayer _player = AudioPlayer();
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _questions = switch (widget.quizType) {
      QuizType.letterToWord => generateLetterQuiz(),
      QuizType.audioToWord => generateAudioQuiz(),
      QuizType.imageToWord => generateWordQuiz(),
    };
    if (_questions.isNotEmpty && _questions.first.type == QuizType.audioToWord) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _playPrompt(_questions.first));
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _tts.stop();
    super.dispose();
  }

  String get _title => switch (widget.quizType) {
    QuizType.letterToWord => "امتحان حروف",
    QuizType.imageToWord => "امتحان تصاویر",
    QuizType.audioToWord => "امتحان صوتی",
  };

  Future<void> _playPrompt(QuizQuestion q) async {
    if (q.soundAsset != null && q.soundAsset!.isNotEmpty) {
      try {
        await _player.play(AssetSource(q.soundAsset!));
        return;
      } catch (_) {
        // fall through to TTS
      }
    }
    await _tts.setLanguage("fa");
    await _tts.setSpeechRate(0.5);
    await _tts.speak(q.options[q.correctIndex]);
  }

  void _answer(int index) {
    if (_isAnswered) return;
    setState(() {
      _selectedIndex = index;
      _isAnswered = true;
      if (index == _questions[_currentIndex].correctIndex) {
        _correctCount++;
      }
    });
  }

  void _next() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
        _isAnswered = false;
      });
      if (_questions[_currentIndex].type == QuizType.audioToWord) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _playPrompt(_questions[_currentIndex]));
      }
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await StatsService.trackQuizScore(_correctCount, _questions.length);
    if (_correctCount == _questions.length) {
      await AchievementService.checkAndUnlock("perfect_score");
    }
    await AchievementService.checkAndUnlock("quiz_champion");
    if (!mounted) return;
    final resolvedQuizType = widget.quizType;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          correct: _correctCount,
          total: _questions.length,
          onRetry: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => QuizGameScreen(quizType: resolvedQuizType)),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentIndex];
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E6),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(_title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation(Colors.deepPurple),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "سوال ${_currentIndex + 1} از ${_questions.length}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
          if (q.type == QuizType.audioToWord)
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("🔊", style: TextStyle(fontSize: 90)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _playPrompt(q),
                      icon: const Icon(Icons.volume_up),
                      label: const Text("پخش دوباره صدا"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (q.promptEmoji != null && q.promptEmoji!.isNotEmpty)
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  q.promptEmoji!,
                  style: const TextStyle(fontSize: 110),
                ),
              ),
            )
          else if (q.imageAsset != null && q.imageAsset!.isNotEmpty)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  q.imageAsset!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Text("🖼️", style: TextStyle(fontSize: 80)),
                ),
              ),
            )
          else
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  q.question.contains("حرف") ? "🔤" : "❓",
                  style: const TextStyle(fontSize: 100),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              q.question,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                itemCount: q.options.length,
                itemBuilder: (context, i) {
                  final isCorrect = i == q.correctIndex;
                  final isSelected = i == _selectedIndex;
                  Color? bg;
                  if (_isAnswered) {
                    if (isCorrect) {
                      bg = Colors.green;
                    } else if (isSelected && !isCorrect) {
                      bg = Colors.red;
                    } else {
                      bg = Colors.white;
                    }
                  }
                  return GestureDetector(
                    onTap: () => _answer(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: bg ?? Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isAnswered
                              ? (isCorrect ? Colors.green : (isSelected ? Colors.red : Colors.grey.shade300))
                              : (isSelected ? Colors.deepPurple : Colors.grey.shade300),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3)),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          q.options[i],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _isAnswered ? (isCorrect || !isSelected ? Colors.black : Colors.white) : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (_isAnswered)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    _currentIndex < _questions.length - 1 ? "بعدی" : "مشاهده نتیجه",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
