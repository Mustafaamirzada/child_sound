import 'package:child_sound/features/onboarding/model/onboarding.dart';
import 'package:child_sound/main.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_animated_buttons/pretty_animated_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<OnboardItem> pages = [
    OnboardItem(
      title: "یادگیری الفبا",
      description: "کودک شما با صدا و تصویر الفبا را یاد میگیرد",
      animationAsset: "assets/animations/Boy-reading-book.json",
    ),
    OnboardItem(
      title: "هجای کلمات",
      description: "یادگیری کلمات یک تا چهار هجایی",
      animationAsset: "assets/animations/Student-studying-orange.json",
    ),
    OnboardItem(
      title: "پیشرفت روزانه",
      description: "ردیابی پیشرفت کودک شما",
      animationAsset: "assets/animations/reading-book.json",
    ),
  ];

  Future<void> _markOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("onboarding_done", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 20,
              right: 30,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.teal, Colors.tealAccent]),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: TextButton(
                  onPressed: () async {
                    await _markOnboardingDone();
                    _goToHome();
                  },
                  child: const Text("رد کردن", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: pages.length,
                    onPageChanged: (index) => setState(() => currentIndex = index),
                    itemBuilder: (context, index) {
                      final item = pages[index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(item.animationAsset, height: 320),
                            const SizedBox(height: 30),
                            Text(item.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 15),
                            Text(item.description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                _buildDots(),
                const SizedBox(height: 20),
                _buildNextButton(),
                const SizedBox(height: 80),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pages.length, (index) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 8,
        width: currentIndex == index ? 24 : 8,
        decoration: BoxDecoration(
          color: currentIndex == index ? Colors.blue : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(10),
        ),
      )),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: PrettySlideIconButton(
        foregroundColor: Colors.teal,
        icon: Icons.arrow_back,
        onPressed: () async {
          if (currentIndex == pages.length - 1) {
            await _markOnboardingDone();
            _goToHome();
          } else {
            _controller.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
          }
        },
        label: currentIndex == pages.length - 1 ? "شروع یادگیری" : "بعدی",
        labelStyle: Theme.of(context).textTheme.bodyLarge!,
      ),
    );
  }

  void _goToHome() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainNavigationScreen()));
  }
}
