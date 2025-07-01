import 'dart:math';
import '../models/test_config.dart';

class WordGenerator {
  static const List<String> _commonWords = [
    'the', 'be', 'to', 'of', 'and', 'a', 'in', 'that', 'have', 'it',
    'for', 'not', 'on', 'with', 'he', 'as', 'you', 'do', 'at', 'this',
    'but', 'his', 'by', 'from', 'they', 'she', 'or', 'an', 'will', 'my',
    'one', 'all', 'would', 'there', 'their', 'what', 'so', 'up', 'out', 'if',
    'about', 'who', 'get', 'which', 'go', 'me', 'when', 'make', 'can', 'like',
    'time', 'no', 'just', 'him', 'know', 'take', 'people', 'into', 'year', 'your',
    'good', 'some', 'could', 'them', 'see', 'other', 'than', 'then', 'now', 'look',
    'only', 'come', 'its', 'over', 'think', 'also', 'back', 'after', 'use', 'two',
    'how', 'our', 'work', 'first', 'well', 'way', 'even', 'new', 'want', 'because',
    'any', 'these', 'give', 'day', 'most', 'us', 'is', 'was', 'are', 'been',
    'has', 'had', 'were', 'said', 'each', 'which', 'their', 'time', 'will', 'about',
    'if', 'up', 'out', 'many', 'then', 'them', 'these', 'so', 'some', 'her',
    'would', 'make', 'like', 'into', 'him', 'has', 'two', 'more', 'very', 'what',
    'know', 'just', 'first', 'get', 'over', 'think', 'where', 'much', 'go', 'well',
    'were', 'been', 'have', 'had', 'has', 'said', 'each', 'which', 'she', 'do',
    'how', 'their', 'if', 'will', 'up', 'other', 'about', 'out', 'many', 'then'
  ];

  static const List<String> _codeSnippets = [
    'for (int i = 0; i < 10; i++) { print(i); }',
    'if (x > y) { return x; } else { return y; }',
    'class MyClass { final int value; MyClass(this.value); }',
    'Future<void> fetchData() async { final response = await http.get(uri); }',
    'List<int> numbers = [1, 2, 3, 4, 5];',
    'Map<String, int> ages = {"Alice": 30, "Bob": 25};',
    'String name = "Flutter";',
    'double pi = 3.14159;',
    'bool isTrue = true;',
    'var result = a + b;',
  ];

  static final Random _random = Random();

  static String generateText(TestType type, int wordCount) {
    switch (type) {
      case TestType.text:
        return _generateWords(wordCount).join(' ');
      case TestType.code:
        return _generateCode(wordCount);
      case TestType.numbers:
        return _generateNumbers(wordCount);
    }
  }

  static List<String> _generateWords(int count) {
    final List<String> words = [];
    for (int i = 0; i < count; i++) {
      words.add(_commonWords[_random.nextInt(_commonWords.length)]);
    }
    return words;
  }

  static String _generateCode(int wordCount) {
    final buffer = StringBuffer();
    int count = 0;
    while (count < wordCount) {
      final snippet = _codeSnippets[_random.nextInt(_codeSnippets.length)];
      buffer.write(snippet);
      count += snippet.split(' ').length;
      if (count < wordCount) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }

  static String _generateNumbers(int wordCount) {
    final buffer = StringBuffer();
    for (int i = 0; i < wordCount; i++) {
      buffer.write(_random.nextInt(1000));
      if (i < wordCount - 1) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }
}
