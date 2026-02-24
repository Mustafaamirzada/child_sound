import 'package:child_sound/features/alphabets/presentation/alphabets_screen.dart';
import 'package:child_sound/features/dashboard/presentation/dashboard_screen.dart';
import 'package:child_sound/features/onboarding/presentation/onboarding_screen.dart';
import 'package:child_sound/features/words/presentation/words_level_screen.dart';
import 'package:child_sound/shared/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    AlphabetScreen(),
    WordLevelsScreen(),
    ParentDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: "الفبا",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "کلمات"),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'DashBoard',
          ),
        ],
      ),

      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   selectedItemColor: Colors.deepPurple,
      //   unselectedItemColor: Colors.grey,
      //   selectedFontSize: 14,
      //   onTap: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.text_fields),
      //       label: "الفبا",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.menu_book),
      //       label: "کلمات",
      //     ),
      //   ],
      // ),
    );
  }
}
