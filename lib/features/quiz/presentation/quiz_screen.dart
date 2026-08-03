import 'package:child_sound/features/quiz/model/quiz_question.dart';
import 'package:child_sound/features/quiz/presentation/quiz_game_screen.dart';
import 'package:child_sound/shared/widgets/app_icons.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text("امتحان", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "کدام را امتحان می‌کنی؟",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D)),
            ),
            const SizedBox(height: 40),
            _buildQuizCard(
              context,
              icon: Icons.abc,
              title: "امتحان حروف",
              subtitle: "حرف اول تصویر را پیدا کن",
              color: Colors.deepPurple,
              quizType: QuizType.letterToWord,
            ),
            const SizedBox(height: 20),
            _buildQuizCard(
              context,
              icon: Icons.image,
              title: "امتحان تصاویر",
              subtitle: "کلمه درست را برای تصویر انتخاب کن",
              color: Colors.teal,
              quizType: QuizType.imageToWord,
            ),
            const SizedBox(height: 20),
            _buildQuizCard(
              context,
              icon: Icons.volume_up,
              title: "امتحان صوتی",
              subtitle: "صدا را گوش کن و کلمه درست را پیدا کن",
              color: Colors.orange,
              quizType: QuizType.audioToWord,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required QuizType quizType,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => QuizGameScreen(quizType: quizType)),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withOpacity(0.8), color]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: Colors.white, size: 36),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.85))),
                ],
              ),
            ),
            Icon(
              AppIcons.forward(context),
              color: Colors.white.withOpacity(0.7),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
