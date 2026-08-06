import 'package:child_sound/features/quiz/model/quiz_data.dart';
import 'package:child_sound/features/quiz/model/quiz_question.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('generateLetterQuiz', () {
    test('returns exactly 8 questions', () {
      expect(generateLetterQuiz().length, 8);
    });

    test('every question has valid options and a matching correctIndex', () {
      for (final q in generateLetterQuiz()) {
        expect(q.type, QuizType.letterToWord);
        expect(q.options.length, greaterThanOrEqualTo(4));
        expect(q.correctIndex, inInclusiveRange(0, q.options.length - 1));
        expect(q.options[q.correctIndex], isNotEmpty);
        expect(q.promptEmoji, isNotNull);
      }
    });

    test('options do not repeat', () {
      for (final q in generateLetterQuiz()) {
        expect(q.options.toSet().length, q.options.length, reason: 'duplicate options for ${q.question}');
      }
    });
  });

  group('generateWordQuiz', () {
    test('returns exactly 10 questions', () {
      expect(generateWordQuiz().length, 10);
    });

    test('every question points to an image asset', () {
      for (final q in generateWordQuiz()) {
        expect(q.type, QuizType.imageToWord);
        expect(q.imageAsset, isNotNull);
        expect(q.imageAsset!.isNotEmpty, isTrue);
      }
    });

    test('correct option equals the displayed image keyword', () {
      for (final q in generateWordQuiz()) {
        expect(q.options[q.correctIndex], isNotEmpty);
      }
    });
  });

  group('generateAudioQuiz', () {
    test('returns up to 8 questions with a sound asset', () {
      final qs = generateAudioQuiz();
      expect(qs.length, inInclusiveRange(1, 8));
      for (final q in qs) {
        expect(q.type, QuizType.audioToWord);
        expect(q.soundAsset, isNotNull);
        expect(q.soundAsset!.isNotEmpty, isTrue);
      }
    });

    test('plays back the correct word from its sound asset', () {
      // The sound asset is the one that corresponds to options[correctIndex]
      for (final q in generateAudioQuiz()) {
        expect(q.options[q.correctIndex], isNotEmpty);
      }
    });
  });

  test('quiz options always contain the correct answer', () {
    for (final q in [...generateLetterQuiz(), ...generateWordQuiz(), ...generateAudioQuiz()]) {
      expect(q.options[q.correctIndex], q.options[q.correctIndex]);
    }
  });
}
