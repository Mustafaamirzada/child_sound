import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> notifier = ValueNotifier(ThemeMode.light);

  static Future<void> applySaved() async {
    final prefs = await SharedPreferences.getInstance();
    final dark = prefs.getBool(_darkKey) ?? false;
    notifier.value = dark ? ThemeMode.dark : ThemeMode.light;
  }

  static const _darkKey = "settings_dark_mode";

  static Future<void> setDarkMode(bool dark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkKey, dark);
    notifier.value = dark ? ThemeMode.dark : ThemeMode.light;
  }
}

class AppColors {
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFFFF6584);
  static const Color accent = Color(0xFFFFC24B);
  static const Color success = Color(0xFF4CAF50);
  static const Color background = Color(0xFFF4F6FF);
  static const Color card = Colors.white;
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color purple = Color(0xFF6C63FF);
  static const Color purpleAccent = Color(0xFF9F7BFF);
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF23233A);
  static const Color darkText = Color(0xFFECECF4);
}

class AppTheme {
  static ThemeData get light => _base(
    brightness: Brightness.light,
    background: AppColors.background,
    card: AppColors.card,
    text: AppColors.textPrimary,
  );

  static ThemeData get dark => _base(
    brightness: Brightness.dark,
    background: AppColors.darkBackground,
    card: AppColors.darkCard,
    text: AppColors.darkText,
  );

  static ThemeData _base({
    required Brightness brightness,
    required Color background,
    required Color card,
    required Color text,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamilyFallback: const ['Vazirmatn', 'Tahoma'],
      textTheme: TextTheme(
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: text),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: text),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: text),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text),
        bodyLarge: TextStyle(fontSize: 16, color: text),
        bodyMedium: TextStyle(fontSize: 14, color: text),
        bodySmall: TextStyle(fontSize: 12, color: text),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      cardTheme: CardThemeData(color: card),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: card,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? Colors.white : Colors.grey.shade400),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? AppColors.primary : Colors.grey.shade300),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
