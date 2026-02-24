import 'package:flutter/material.dart';
import '../model/alphabet.dart';

class DetailScreen extends StatelessWidget {
  final AlphabetItem item;
  final Function(String) speak;

  const DetailScreen({super.key, required this.item, required this.speak});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E6),
      appBar: AppBar(
        title: Text(item.letter),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.emoji,
              style: const TextStyle(fontSize: 120), // BIG emoji
            ),
            const SizedBox(height: 30),
            Text(
              item.letter,
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              item.word,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => speak("${item.letter} برای ${item.word}"),
              icon: const Icon(Icons.volume_up),
              label: const Text("پخش صدا"),
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
    );
  }
}
