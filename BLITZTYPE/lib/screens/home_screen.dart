import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../models/test_config.dart';
import '../models/typing_stats.dart';
import '../services/word_generator.dart';
import '../services/typing_calculator.dart';
import '../widgets/test_config_panel.dart';
import '../widgets/stats_display.dart';
import '../widgets/typing_interface.dart';
import '../widgets/results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TestConfig _config = const TestConfig(
    mode: TestMode.time,
    duration: TestDuration.thirty,
  );
  
  String _originalText = '';
  String _typedText = '';
  TypingStats _currentStats = TypingStats.empty();
  bool _isTestActive = false;
  bool _isTestComplete = false;
  Timer? _timer;
  DateTime? _testStartTime;
  int _timeRemaining = 0;
  int _currentWordIndex = 0;

  @override
  void initState() {
    super.initState();
    _generateText();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _generateText() {
    setState(() {
      if (_config.mode == TestMode.time) {
        _originalText = WordGenerator.generateText(_config.type, 200); // Generate enough words for time mode
      } else {
        _originalText = WordGenerator.generateText(_config.type, _config.targetWordCount);
      }
      _typedText = '';
      _currentStats = TypingStats.empty();
      _isTestActive = false;
      _isTestComplete = false;
      _currentWordIndex = 0;
      _timeRemaining = _config.mode == TestMode.time ? _config.timeInSeconds : 0;
    });
    _timer?.cancel();
  }

  void _startTest() {
    setState(() {
      _isTestActive = true;
      _testStartTime = DateTime.now();
      _timeRemaining = _config.mode == TestMode.time ? _config.timeInSeconds : 0;
    });

    if (_config.mode == TestMode.time) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _timeRemaining--;
          if (_timeRemaining <= 0) {
            _completeTest();
          }
        });
      });
    }
  }

  void _completeTest() {
    _timer?.cancel();
    setState(() {
      _isTestActive = false;
      _isTestComplete = true;
    });
  }

  void _onTextChanged(String value) {
    if (!_isTestActive) return;

    setState(() {
      _typedText = value;
      _currentWordIndex = value.split(' ').length - 1;
      
      // Calculate current stats
      final timeElapsed = _testStartTime != null 
          ? DateTime.now().difference(_testStartTime!).inMilliseconds / 1000.0
          : 0.0;
      
      _currentStats = TypingCalculator.calculateStats(
        originalText: _originalText,
        typedText: _typedText,
        timeElapsedSeconds: timeElapsed,
      );

      // Check if test should complete (word mode)
      if (_config.mode == TestMode.words) {
        final typedWords = _typedText.split(' ');
        if (typedWords.length -1 == _config.targetWordCount) {
          _completeTest();
        }
      }
    });
  }

  void _restartTest() {
    _generateText();
  }

  void _onConfigChanged(TestConfig newConfig) {
    setState(() {
      _config = newConfig;
      // When changing type, we might want to reset the mode to time
      if (newConfig.type != _config.type) {
        _config = TestConfig(
          mode: TestMode.time,
          duration: _config.duration ?? TestDuration.thirty,
          type: newConfig.type,
        );
      }
    });
    _generateText();
  }

  void _handleKeyPress(RawKeyEvent event) {
    if (!_isTestActive || _isTestComplete) return;

    final key = event.logicalKey;
    String newChar = '';

    // Handle regular characters
    if (key == LogicalKeyboardKey.space) {
      newChar = ' ';
    } else if (key == LogicalKeyboardKey.backspace) {
      // Handle backspace
      if (_typedText.isNotEmpty) {
        setState(() {
          _typedText = _typedText.substring(0, _typedText.length - 1);
          _onTextChanged(_typedText);
        });
      }
      return;
    } else if (event.character != null && event.character!.isNotEmpty) {
      newChar = event.character!;
    }

    // Add the new character
    if (newChar.isNotEmpty) {
      setState(() {
        _typedText += newChar;
        _onTextChanged(_typedText);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent && !_isTestComplete) {
          if (!_isTestActive) {
            if (event.logicalKey != LogicalKeyboardKey.control &&
                event.logicalKey != LogicalKeyboardKey.alt &&
                event.logicalKey != LogicalKeyboardKey.shift &&
                event.logicalKey != LogicalKeyboardKey.tab &&
                event.logicalKey != LogicalKeyboardKey.escape &&
                event.logicalKey != LogicalKeyboardKey.capsLock) {
              _startTest();
            }
          } else {
            _handleKeyPress(event);
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  children: [
                    TestConfigPanel(
                      config: _config,
                      onConfigChanged: _onConfigChanged,
                    ),
                    const Spacer(),
                    if (!_isTestComplete) ...[
                      if (!_isTestActive)
                        SizedBox(
                          height: 250,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _config.mode == TestMode.time
                                    ? _config.timeInSeconds.toString()
                                    : _config.targetWordCount.toString(),
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'start typing to begin',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        )
                      else
                        SizedBox(
                          height: 250,
                          child: TypingInterface(
                            originalText: _originalText,
                            typedText: _typedText,
                            isTestActive: _isTestActive,
                            currentWordIndex: _currentWordIndex,
                          ),
                        ),
                      const SizedBox(height: 32),
                      if (_isTestActive)
                        StatsDisplay(
                          stats: _currentStats,
                          timeRemaining: _config.mode == TestMode.time ? _timeRemaining : null,
                        ),
                    ] else ...[
                      ResultsScreen(
                        stats: _currentStats,
                        onRestart: _restartTest,
                      ),
                    ],
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
