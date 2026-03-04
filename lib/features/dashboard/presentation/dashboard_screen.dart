import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text("Parent Dashboard"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            ProfileCard(),
            SizedBox(height: 16),
            ProgressCard(),
            SizedBox(height: 16),
            WeeklyBarChartCard(),
            SizedBox(height: 16),
            StreakCard(),
            SizedBox(height: 16),
            WordProgressCard(),
            SizedBox(height: 16),
            SettingsCard(),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: const [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue,
            child: Icon(Icons.child_care, color: Colors.white, size: 30),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mustafa",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text("Learning Level: Beginner"),
            ],
          ),
        ],
      ),
    );
  }
}

// progress bar card
class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    double progress = 0.75; // Example: 75%

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          const Text(
            "Alphabet Progress",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(seconds: 2),
            builder: (context, value, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),

                  Text(
                    "${(value * 100).toInt()}%",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 10),
          const Text("24 / 32 Letters Completed"),
        ],
      ),
    );
  }
}

// weakly barchart
class WeeklyBarChartCard extends StatelessWidget {
  const WeeklyBarChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Weekly Activity",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                barGroups: [
                  _bar(0, 3),
                  _bar(1, 5),
                  _bar(2, 2),
                  _bar(3, 6),
                  _bar(4, 4),
                  _bar(5, 7),
                  _bar(6, 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _bar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 16,
          borderRadius: BorderRadius.circular(6),
          color: Colors.blue,
        ),
      ],
    );
  }
}

// streak card
class StreakCard extends StatelessWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    int streakDays = 5; // Example

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.orange,
              size: 30,
            ),
          ),

          const SizedBox(width: 20),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Learning Streak",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                "$streakDays Days 🔥",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WordProgressCard extends StatelessWidget {
  const WordProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Word Levels",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ListTile(title: Text("One Syllable"), trailing: Text("80%")),
          ListTile(title: Text("Two Syllable"), trailing: Text("40%")),
          ListTile(title: Text("Three Syllable"), trailing: Text("10%")),
        ],
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          SwitchListTile(
            value: true,
            onChanged: (value) {},
            title: const Text("Sound Enabled"),
          ),
          SwitchListTile(
            value: false,
            onChanged: (value) {},
            title: const Text("Dark Mode"),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5)),
    ],
  );
}
