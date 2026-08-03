import 'package:child_sound/core/services/storage_keys.dart';
import 'package:child_sound/features/alphabets/data/alphabets_list.dart';
import 'package:child_sound/features/alphabets/presentation/letter_pager_screen.dart';
import 'package:child_sound/shared/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({super.key});

  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen> {
  Set<int> completedLetters = {};
  Future<void> _loadCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    const storageKey = StorageKeys.completedAlphabets;
    final List<String>? saved = prefs.getStringList(storageKey);

    if (saved != null) {
      setState(() {
        completedLetters = saved.map(int.parse).toSet();
      });
    }
  }

  Future<void> _saveCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    const storageKey = StorageKeys.completedAlphabets;
    await prefs.setStringList(
      storageKey,
      completedLetters.map((e) => e.toString()).toList(),
    );
  }

  Future<bool> canOpenLetter(int index) async {
    final prefs = await SharedPreferences.getInstance();
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    String? lastDate = prefs.getString("last_date");
    int? lastIndex = prefs.getInt("last_index");

    if (lastDate == today) {
      // Already opened today
      if (lastIndex == index) {
        return true; // allow same letter
      } else {
        return false; // block new letter
      }
    }

    return true; // new day
  }

  Future<void> saveOpenedLetter(int index) async {
    final prefs = await SharedPreferences.getInstance();
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    await prefs.setString("last_date", today);
    await prefs.setInt("last_index", index);
  }

  @override
  void initState() {
    super.initState();
    _loadCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: const Color(0xFFF4F6FF),
      appBar: AppBar(
        title: const Text(
          "آموزش الفبا 🇦🇫",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: alphabets.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // smaller cards
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final item = alphabets[index];

            return GestureDetector(
              onTap: () async {
                bool allowed = await canOpenLetter(index);
                if (!allowed) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                "امروز فقط یک حرف می‌توانی یاد بگیری 😊",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.black),
                              onPressed: () {
                                ScaffoldMessenger.of(
                                  context,
                                ).hideCurrentSnackBar();
                              },
                            ),
                          ],
                        ),
                        backgroundColor: Colors.white,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Color(0xFFFFD3E0),
                            width: 1,
                          ),
                        ),
                        duration: const Duration(seconds: 10),
                      ),
                    );
                  }
                  return;
                }

                await saveOpenedLetter(index);

                if (!completedLetters.contains(index)) {
                  setState(() {
                    completedLetters.add(index);
                  });
                  await _saveCompleted();
                }

                await Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (_, animation, __) {
                      return LetterPagerScreen(
                        alphabets: alphabets,
                        initialIndex: index,
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

                if (mounted) {
                  await _loadCompleted();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD3E0), Color(0xFFD9E4FF)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Small emoji in corner
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Text(
                        item.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.letter,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(item.word, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    // Completed Indicator
                    if (completedLetters.contains(index))
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            // color: Color(0x5FFFD6E0),
                            color: Colors.lime,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
