enum QuizType { letterToWord, imageToWord, audioToWord }

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final QuizType type;
  final String? imageAsset;
  final String? promptEmoji;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.type,
    this.imageAsset,
    this.promptEmoji,
  });
}
