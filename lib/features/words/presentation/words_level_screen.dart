import 'package:child_sound/features/words/presentation/five_syllable.dart';
import 'package:child_sound/features/words/presentation/four_syllable.dart';
import 'package:child_sound/features/words/presentation/single_syllable.dart';
import 'package:child_sound/features/words/presentation/three_syllable.dart';
import 'package:child_sound/features/words/presentation/two_syllable.dart';
import 'package:child_sound/shared/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class WordLevelsScreen extends StatelessWidget {
  const WordLevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      drawerEnableOpenDragGesture: true,
      drawerScrimColor: Colors.white.withOpacity(0.55),
      appBar: AppBar(
        title: const Text(
          "تمرین کلمات",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              AspectRatio(
                aspectRatio: 1.2,
                child: Image.asset('assets/webInterFace.png'),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.width / 1.2 - 24.0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.0),
                  topRight: Radius.circular(32.0),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color(0xFF3A5160).withOpacity(0.2),
                    offset: Offset(1.1, 1.1),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildLevelCard(
                    context,
                    "کلمات یک هجایی",
                    Colors.orange,
                    const SingleSyllableScreen(),
                  ),
                  _buildLevelCard(
                    context,
                    "کلمات دو هجایی",
                    Colors.blue,
                    const TwoSyllableScreen(),
                  ),
                  _buildLevelCard(
                    context,
                    "کلمات سه هجایی",
                    Colors.green,
                    const ThreeSyllableScreen(),
                  ),
                  _buildLevelCard(
                    context,
                    "کلمات چهار و پنج هجایی",
                    Colors.purple,
                    const FourSyllableScreen(),
                  ),
                  _buildLevelCard(
                    context,
                    "کلمات پنج هجایی",
                    Colors.deepOrangeAccent,
                    const FiveSyllableScreen(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(
    BuildContext context,
    String title,
    Color color,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [color.withOpacity(0.7), color]),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
