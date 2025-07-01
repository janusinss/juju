import 'dart:math';
import '../models/typing_stats.dart';

class TypingCalculator {
  static TypingStats calculateStats({
    required String originalText,
    required String typedText,
    required double timeElapsedSeconds,
  }) {
    List<String> originalWords = originalText.trim().split(RegExp(r'\s+'));
    List<String> typedWords = typedText.trim().split(RegExp(r'\s+'));

    int correctWords = 0;
    int incorrectWords = 0;

    // Determine the number of words to compare
    int wordCount = max(originalWords.length, typedWords.length);

    for (int i = 0; i < wordCount; i++) {
      if (i < originalWords.length && i < typedWords.length) {
        if (originalWords[i] == typedWords[i]) {
          correctWords++;
        } else {
          incorrectWords++;
        }
      } else {
        incorrectWords++;
      }
    }

    // Standard WPM calculation (based on 5-character words)
    double timeInMinutes = timeElapsedSeconds / 60.0;
    double wpm = (typedText.length / 5) / timeInMinutes;
    if (wpm.isNaN || wpm.isInfinite) {
      wpm = 0;
    }

    // Accuracy based on correct words vs total words in original text
    double accuracy =
        originalWords.isNotEmpty ? (correctWords / originalWords.length) * 100 : 0;
    accuracy = accuracy.clamp(0, 100);


    int correctChars = 0;
    for (int i = 0; i < min(originalText.length, typedText.length); i++) {
      if (originalText[i] == typedText[i]) {
        correctChars++;
      }
    }
    
    int totalChars = typedText.length;
    int incorrectChars = totalChars - correctChars;
    int wordsTyped = typedWords.length;
    if (typedText.trim().isEmpty) {
      wordsTyped = 0;
    }


    return TypingStats(
      correctChars: correctChars,
      incorrectChars: incorrectChars,
      totalChars: totalChars,
      timeElapsed: timeElapsedSeconds,
      wordsTyped: wordsTyped,
      wpm: wpm,
      accuracy: accuracy,
    );
  }
}
