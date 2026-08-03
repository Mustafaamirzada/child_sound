import 'package:child_sound/core/services/stats_service.dart';
import 'package:child_sound/core/theme/app_theme.dart';
import 'package:child_sound/features/alphabets/presentation/alphabets_screen.dart';
import 'package:child_sound/features/dashboard/presentation/dashboard_screen.dart';
import 'package:child_sound/features/onboarding/presentation/onboarding_screen.dart';
import 'package:child_sound/features/profile/presentation/profile_screen.dart';
import 'package:child_sound/features/quiz/presentation/quiz_screen.dart';
import 'package:child_sound/features/splash/presentation/name_input_screen.dart';
import 'package:child_sound/features/words/presentation/words_level_screen.dart';
import 'package:child_sound/shared/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await StatsService.migrateLegacyKeys();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    ThemeController.applySaved();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.notifier,
      builder: (context, themeMode, _) => MaterialApp(
        title: 'Child Sound',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        locale: const Locale('fa'),
        supportedLocales: const [Locale('fa')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const _AppStartupScreen(),
      ),
    );
  }
}

class _AppStartupScreen extends StatefulWidget {
  const _AppStartupScreen();

  @override
  State<_AppStartupScreen> createState() => _AppStartupScreenState();
}

class _AppStartupScreenState extends State<_AppStartupScreen> {
  Widget? _destination;

  @override
  void initState() {
    super.initState();
    _checkStartup();
  }

  Future<void> _checkStartup() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool("onboarding_done") ?? false;
    final hasName = (prefs.getString("userName") ?? "").isNotEmpty;

    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() {
      if (!hasName) {
        _destination = NameInputScreen(
          onDone: () {
            if (!onboardingDone) {
              setState(() => _destination = const OnboardingScreen());
            } else {
              setState(() => _destination = const MainNavigationScreen());
            }
          },
        );
      } else if (!onboardingDone) {
        _destination = const OnboardingScreen();
      } else {
        _destination = const MainNavigationScreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_destination != null) return _destination!;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("🎓", style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text("Child Sound", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 24),
            SizedBox(
              width: 28, height: 28,
              child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white.withOpacity(0.8)),
            ),
          ],
        ),
      ),
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
    QuizScreen(),
    ParentDashboardScreen(),
    ProfileScreen(),
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
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.text_fields), label: "الفبا"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "کلمات"),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: "کوئیز"),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "داشبورد"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "پروفایل"),
        ],
      ),
    );
  }
}
