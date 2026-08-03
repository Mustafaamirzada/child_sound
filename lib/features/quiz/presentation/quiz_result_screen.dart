import 'package:flutter/material.dart';

class QuizResultScreen extends StatelessWidget {
  final int correct;
  final int total;
  const QuizResultScreen({super.key, required this.correct, required this.total});

  @override
  Widget build(BuildContext context) {
    final score = correct / total;
    final emoji = score >= 0.9 ? "🎉" : score >= 0.7 ? "👍" : score >= 0.5 ? "💪" : "📚";
    final msg = score >= 0.9 ? "عالی! تو استادی!" : score >= 0.7 ? "خوب بود! ادامه بده" : score >= 0.5 ? "می‌توانی بهتر شوی!" : "بیشتر تمرین کن!";

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("نتیجه کوئیز"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 80)),
              const SizedBox(height: 20),
              Text(
                "$correct از $total",
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 8),
              Text(
                "${(score * 100).toInt()}%",
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Text(
                msg,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFF2D2D2D)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: score),
                duration: const Duration(seconds: 1),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return SizedBox(
                    width: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: value,
                        minHeight: 14,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(score >= 0.7 ? Colors.green : Colors.orange),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.home),
                  label: const Text("بازگشت", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
