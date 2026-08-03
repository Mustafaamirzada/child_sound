import 'package:child_sound/features/achievements/model/achievement_service.dart';
import 'package:child_sound/features/words/data/words_list.dart';
import 'package:child_sound/core/services/stats_service.dart';
import 'package:flutter/material.dart';

class WritingScreen extends StatefulWidget {
  const WritingScreen({super.key});

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  final List<_WordPuzzle> _puzzles = [];
  int _currentIndex = 0;
  int _completedCount = 0;
  final List<String> _placed = [];
  final List<String> _unplaced = [];

  @override
  void initState() {
    super.initState();
    _generatePuzzles();
  }

  void _generatePuzzles() {
    final all = [...oneSyllableWords, ...twoSyllableWords, ...threeSyllableWords]..shuffle();
    final selected = all.take(10).toList();
    for (final w in selected) {
      final letters = w.word.split('');
      final shuffled = List<String>.from(letters)..shuffle();
      _puzzles.add(_WordPuzzle(word: w.word, emoji: w.emoji, letters: shuffled));
    }
    _initPuzzle();
  }

  void _initPuzzle() {
    final p = _puzzles[_currentIndex];
    _placed.clear();
    _unplaced.clear();
    _unplaced.addAll(p.letters);
  }

  void _placeLetter(String letter) {
    if (_unplaced.isEmpty) return;
    setState(() {
      _unplaced.remove(letter);
      _placed.add(letter);
    });
    _checkAnswer();
  }

  void _removeLetter(int index) {
    setState(() {
      final l = _placed.removeAt(index);
      _unplaced.add(l);
    });
  }

  void _checkAnswer() {
    final p = _puzzles[_currentIndex];
    if (_placed.join('') == p.word) {
      _completedCount++;
      StatsService.trackWord();
      AchievementService.checkAndUnlock("writer");
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        if (_currentIndex < _puzzles.length - 1) {
          setState(() {
            _currentIndex++;
            _initPuzzle();
          });
        } else {
          _showCompletion();
        }
      });
    }
  }

  void _showCompletion() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("🎉", style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text("آفرین! تمرین نوشتن تمام شد!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("$_completedCount کلمه نوشتی", style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
              child: const Text("باشه"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = _puzzles[_currentIndex];
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E6),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("تمرین نوشتن"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / _puzzles.length,
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation(Colors.teal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "کلمه ${_currentIndex + 1} از ${_puzzles.length}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            flex: 3,
            child: Center(
              child: Image.asset(
                p.emoji,
                height: 180,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Text("🖼️", style: TextStyle(fontSize: 100)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text("حروف را به ترتیب بچین:", style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 12),
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.3), width: 2),
            ),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_placed.length, (i) {
                    return GestureDetector(
                      onTap: () => _removeLetter(i),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.teal),
                        ),
                        child: Text(_placed[i], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.teal)),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          if (_placed.join('') == p.word)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text("✅ درست است!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            ),
          const SizedBox(height: 20),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: _unplaced.map((l) {
                  return GestureDetector(
                    onTap: () => _placeLetter(l),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.deepPurple.withOpacity(0.4)),
                      ),
                      child: Center(
                        child: Text(l, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_unplaced.isEmpty && _placed.join('') != p.word)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _initPuzzle,
                icon: const Icon(Icons.refresh),
                label: const Text("دوباره"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WordPuzzle {
  final String word;
  final String emoji;
  final List<String> letters;
  const _WordPuzzle({required this.word, required this.emoji, required this.letters});
}
