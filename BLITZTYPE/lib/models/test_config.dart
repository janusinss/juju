enum TestMode { time, words }
enum TestType { text, code, numbers }

enum TestDuration { fifteen, thirty, sixty }

enum WordCount { twentyFive, fifty, hundred }

class TestConfig {
  final TestMode mode;
  final TestType type;
  final TestDuration? duration;
  final WordCount? wordCount;

  const TestConfig({
    required this.mode,
    this.type = TestType.text,
    this.duration,
    this.wordCount,
  });

  int get timeInSeconds {
    switch (duration) {
      case TestDuration.fifteen:
        return 15;
      case TestDuration.thirty:
        return 30;
      case TestDuration.sixty:
        return 60;
      default:
        return 30;
    }
  }

  int get targetWordCount {
    switch (wordCount) {
      case WordCount.twentyFive:
        return 25;
      case WordCount.fifty:
        return 50;
      case WordCount.hundred:
        return 100;
      default:
        return 50;
    }
  }

  String get durationLabel {
    switch (duration) {
      case TestDuration.fifteen:
        return '15s';
      case TestDuration.thirty:
        return '30s';
      case TestDuration.sixty:
        return '60s';
      default:
        return '30s';
    }
  }

  String get wordCountLabel {
    switch (wordCount) {
      case WordCount.twentyFive:
        return '25';
      case WordCount.fifty:
        return '50';
      case WordCount.hundred:
        return '100';
      default:
        return '50';
    }
  }
}
