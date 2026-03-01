// ignore_for_file: deprecated_member_use

import 'package:child_sound/features/words/model/words.dart';
import 'package:child_sound/features/words/presentation/widgets/word_pager_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordListScreen extends StatefulWidget {
  final String title;
  final List<WordItem> words;
  final List<Color> gradientColors;

  const WordListScreen({
    super.key,
    required this.title,
    required this.words,
    required this.gradientColors,
  });

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  Set<int> completedLetters = {};

  @override
  void initState() {
    _loadCompleted();
    super.initState();
  }

  Future<void> _loadCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? saved = prefs.getStringList(
      widget.title,
    ); // unique key per screen

    if (saved != null) {
      setState(() {
        completedLetters = saved.map(int.parse).toSet();
      });
    }
  }

  Future<void> _saveCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      widget.title,
      completedLetters.map((e) => e.toString()).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: widget.gradientColors.last,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.words.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  pageBuilder: (_, animation, __) {
                    return WordPagerScreen(
                      words: widget.words,
                      initialIndex: index,
                      // lockedIndex: index,
                    );
                  },
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween(begin: 0.9, end: 1.0).animate(animation),
                        child: child,
                      ),
                    );
                  },
                ),
              );

              if (!completedLetters.contains(index)) {
                setState(() {
                  completedLetters.add(index);
                });
                await _saveCompleted();
              }
            },
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: widget.gradientColors
                          .map((color) => color.withOpacity(0.7))
                          .toList(),
                    ), //transparent effect
                    border: Border.all(
                      color: widget.gradientColors.last.withOpacity(0.9),
                      width: 2, // dark border
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.words[index].word,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Completed Indicator
                if (completedLetters.contains(index))
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.gradientColors.last,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.check, color: Colors.white, size: 20),
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
