class QuizQuestion {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String topic;
  final int xpReward;

  const QuizQuestion({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.topic = 'Algoritma & Pemrograman',
    this.xpReward = 30,
  });

  bool isCorrect(int selectedIndex) => selectedIndex == correctIndex;
}
