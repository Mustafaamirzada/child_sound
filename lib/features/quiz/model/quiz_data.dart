import 'package:child_sound/features/alphabets/data/alphabets_list.dart';
import 'package:child_sound/features/words/data/words_list.dart';
import 'quiz_question.dart';

List<QuizQuestion> _allWordQuestions() {
  final all = [...oneSyllableWords, ...twoSyllableWords, ...threeSyllableWords];
  final selected = (all..shuffle()).take(20).toList();
  return selected.map((w) {
    final wrongs = (all..shuffle()).where((x) => x.word != w.word).take(3).map((x) => x.word).toList();
    final options = [w.word, ...wrongs]..shuffle();
    return QuizQuestion(
      question: "این تصویر چیست؟",
      options: options,
      correctIndex: options.indexOf(w.word),
      type: QuizType.imageToWord,
      imageAsset: w.emoji,
    );
  }).toList();
}

List<QuizQuestion> _allLetterQuestions() {
  final selected = (alphabets..shuffle()).take(10).toList();
  return selected.map((a) {
    final wrongs = (alphabets..shuffle()).where((x) => x.letter != a.letter).take(3).map((x) => x.letter).toList();
    final options = [a.letter, ...wrongs]..shuffle();
    return QuizQuestion(
      question: "این تصویر با کدام حرف شروع می‌شود؟",
      options: options,
      correctIndex: options.indexOf(a.letter),
      type: QuizType.letterToWord,
      promptEmoji: a.emoji.isNotEmpty ? a.emoji : null,
    );
  }).toList();
}

List<QuizQuestion> generateLetterQuiz() {
  final qs = _allLetterQuestions();
  return _pickRandom(qs, 8);
}

List<QuizQuestion> generateWordQuiz() {
  final qs = _allWordQuestions();
  return _pickRandom(qs, 10);
}

List<QuizQuestion> _pickRandom(List<QuizQuestion> items, int count) {
  if (items.length <= count) return items;
  return (items..shuffle()).take(count).toList();
}
