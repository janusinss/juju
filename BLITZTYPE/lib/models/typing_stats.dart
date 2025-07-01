class TypingStats {
  final int correctChars;
  final int incorrectChars;
  final int totalChars;
  final double timeElapsed;
  final int wordsTyped;
  final double wpm;
  final double accuracy;

  const TypingStats({
    required this.correctChars,
    required this.incorrectChars,
    required this.totalChars,
    required this.timeElapsed,
    required this.wordsTyped,
    required this.wpm,
    required this.accuracy,
  });

  factory TypingStats.empty() {
    return const TypingStats(
      correctChars: 0,
      incorrectChars: 0,
      totalChars: 0,
      timeElapsed: 0,
      wordsTyped: 0,
      wpm: 0,
      accuracy: 100,
    );
  }
}