import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:child_sound/main.dart';

void main() {
  testWidgets('App boots to main navigation when onboarding is done',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      "onboarding_done": true,
      "userName": "مصطفی",
    });

    await tester.pumpWidget(MyApp());

    // Let the splash delay elapse and the startup decision run.
    await tester.pump(const Duration(milliseconds: 500));

    // Main navigation should now be visible with all 5 tabs.
    expect(find.text("الفبا"), findsOneWidget);
    expect(find.text("کلمات"), findsOneWidget);
    expect(find.text("کوئیز"), findsOneWidget);
    expect(find.text("داشبورد"), findsOneWidget);
    expect(find.text("پروفایل"), findsOneWidget);
  });

  testWidgets('First launch shows the name input screen',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(MyApp());
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text("به Child Sound خوش آمدی!"), findsOneWidget);
  });
}
