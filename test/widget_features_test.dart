import 'package:child_sound/features/alphabets/presentation/letter_pager_screen.dart';
import 'package:child_sound/features/alphabets/model/alphabet.dart';
import 'package:child_sound/features/quiz/model/quiz_question.dart';
import 'package:child_sound/features/quiz/presentation/quiz_game_screen.dart';
import 'package:child_sound/features/quiz/presentation/quiz_screen.dart';
import 'package:child_sound/features/words/model/words.dart';
import 'package:child_sound/features/words/presentation/widgets/word_list_screen.dart';
import 'package:child_sound/features/words/presentation/widgets/word_pager_screen.dart';
import 'package:child_sound/shared/widgets/app_icons.dart';
import 'package:child_sound/shared/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_helpers.dart';

final testWords = [
  WordItem(word: 'آب', emoji: 'assets/images/icons8-water-100.png', sound: 'sounds/one_syllable/آب.mp3'),
  WordItem(word: 'باد', emoji: 'assets/images/icons8-wind-100.png', sound: 'sounds/one_syllable/باد.mp3'),
  WordItem(word: 'کتاب', emoji: 'assets/images/icons8-book-100.png', sound: 'sounds/one_syllable/کتاب.mp3'),
];

final testAlphabets = [
  AlphabetItem(letter: 'الف', word: 'آب', emoji: '💧'),
  AlphabetItem(letter: 'ب', word: 'باد', emoji: '🌬️'),
  AlphabetItem(letter: 'ج', word: 'جانور', emoji: '🐾'),
];

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockAudioAndTtsChannels();
  });

  group('WordListScreen', () {
    testWidgets('renders every word from the list', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WordListScreen(
            title: 'کلمات یک هجایی',
            storageKey: 'word_level_one',
            words: testWords,
            gradientColors: [Colors.orange, Colors.deepOrange],
          ),
        ),
      );

      expect(find.text('آب'), findsOneWidget);
      expect(find.text('باد'), findsOneWidget);
      expect(find.text('کتاب'), findsOneWidget);
    });

    testWidgets('marks a word completed after tapping it', (tester) async {
      usePhoneViewport(tester);
      await tester.pumpWidget(
        MaterialApp(
          home: WordListScreen(
            title: 'کلمات یک هجایی',
            storageKey: 'word_level_one',
            words: testWords,
            gradientColors: [Colors.orange, Colors.deepOrange],
          ),
        ),
      );

      await tester.tap(find.text('باد'));
      await tester.pumpAndSettle();

      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('word_level_one') ?? [];
      expect(saved, isNotEmpty);
    });
  });

  group('WordPagerScreen', () {
    testWidgets('shows the word and progress text', (tester) async {
      usePhoneViewport(tester);
      await tester.pumpWidget(
        MaterialApp(
          home: WordPagerScreen(
            words: testWords,
            initialIndex: 0,
            storageKey: 'word_level_one',
          ),
        ),
      );

      expect(find.text('یادگیری کلمه'), findsOneWidget);
      expect(find.text('پیشرفت 1 از 3'), findsOneWidget);
      expect(find.text('پخش دوباره'), findsOneWidget);
    });
  });

  group('LetterPagerScreen', () {
    testWidgets('shows letter, word and progress', (tester) async {
      usePhoneViewport(tester);
      await tester.pumpWidget(
        MaterialApp(
          home: LetterPagerScreen(alphabets: testAlphabets, initialIndex: 0),
        ),
      );

      expect(find.text('یادگیری حرف'), findsOneWidget);
      expect(find.text('پیشرفت 1 از 3'), findsOneWidget);
      expect(find.text('پخش دوباره'), findsOneWidget);
    });
  });

  group('QuizScreen', () {
    testWidgets('shows all three quiz options', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: QuizScreen()));

      expect(find.text('امتحان حروف'), findsOneWidget);
      expect(find.text('امتحان تصاویر'), findsOneWidget);
      expect(find.text('امتحان صوتی'), findsOneWidget);
    });
  });

  group('QuizGameScreen', () {
    testWidgets('shows current question text and answer options', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: QuizGameScreen(quizType: QuizType.letterToWord)),
      );

      expect(find.text('سوال 1 از 8'), findsOneWidget);
      // Always 4 option tiles per question.
      final optionTiles = find.byType(AnimatedContainer);
      expect(optionTiles, findsWidgets);

      // Tapping any option reveals the "بعدی" button.
      await tester.tap(optionTiles.first);
      await tester.pump();
      expect(find.text('بعدی'), findsOneWidget);
    });

    testWidgets('works its way to the result screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: QuizGameScreen(quizType: QuizType.letterToWord)),
      );

      for (var i = 0; i < 8; i++) {
        await tester.tap(find.byType(AnimatedContainer).first);
        await tester.pump();

        final next = find.text('بعدی');
        final finish = find.text('مشاهده نتیجه');
        if (finish.evaluate().isNotEmpty) {
          await tester.tap(finish);
          await tester.pumpAndSettle();
        } else if (next.evaluate().isNotEmpty) {
          await tester.tap(next);
          await tester.pumpAndSettle();
        }
      }

      expect(find.text('بازگشت'), findsOneWidget);
    });
  });

  group('RTL drawer icons', () {
    testWidgets('chevron points forward (back) in RTL context', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('fa'),
          supportedLocales: const [Locale('fa')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(drawer: AppDrawer()),
        ),
      );
      final size = tester.getSize(find.byType(Scaffold));
      await tester.dragFrom(
        Offset(size.width - 1, size.height / 2),
        Offset(-size.width * 0.8, 0),
      );
      await tester.pumpAndSettle();

      // In an RTL (Persian) context, AppIcons.forward returns the left chevron.
      expect(find.byIcon(Icons.arrow_back_ios_new), findsNWidgets(4));
    });

    testWidgets('AppIcons.forward returns forward_ios in LTR context', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Icon(AppIcons.forward(context)),
          ),
        ),
      );

      // Without an fa locale the direction is LTR, so forward = right chevron.
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    });
  });
}
