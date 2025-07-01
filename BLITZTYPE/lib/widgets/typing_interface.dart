import 'package:flutter/material.dart';
import '../theme.dart';

class TypingInterface extends StatefulWidget {
  final String originalText;
  final String typedText;
  final bool isTestActive;
  final int currentWordIndex;

  const TypingInterface({
    super.key,
    required this.originalText,
    required this.typedText,
    required this.isTestActive,
    required this.currentWordIndex,
  });

  @override
  State<TypingInterface> createState() => _TypingInterfaceState();
}

class _TypingInterfaceState extends State<TypingInterface> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _wordKeys = [];

  @override
  void initState() {
    super.initState();
    _wordKeys.addAll(List.generate(widget.originalText.split(' ').length, (_) => GlobalKey()));
  }

  @override
  void didUpdateWidget(TypingInterface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentWordIndex != oldWidget.currentWordIndex) {
      _scrollToCurrentWord();
    }
  }

  void _scrollToCurrentWord() {
    if (widget.currentWordIndex < _wordKeys.length) {
      final key = _wordKeys[widget.currentWordIndex];
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          alignment: 0.5,
          duration: const Duration(milliseconds: 300),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isTestActive) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: _buildTextDisplay(context),
    );
  }

  Widget _buildTextDisplay(BuildContext context) {
    final words = widget.originalText.split(' ');
    final typedWords = widget.typedText.split(' ');

    return SingleChildScrollView(
      controller: _scrollController,
      child: Center(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: words.asMap().entries.map((entry) {
            final wordIndex = entry.key;
            final word = entry.value;
            final isCurrentWord = wordIndex == widget.currentWordIndex;
            final isTyped = wordIndex < typedWords.length;

            String typedWord = '';
            if (isTyped) {
              typedWord = typedWords[wordIndex];
            }

            return Container(
              key: _wordKeys[wordIndex],
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: _buildWord(context, word, typedWord, isCurrentWord),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildWord(BuildContext context, String originalWord, String typedWord, bool isCurrentWord) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;
    final errorColor = Colors.red.shade700;

    final List<InlineSpan> chars = [];

    for (int i = 0; i < originalWord.length; i++) {
      Color charColor = AppTheme.subTextColor;
      
      if (i < typedWord.length) {
        if (typedWord[i] == originalWord[i]) {
          charColor = AppTheme.textColor;
        } else {
          charColor = errorColor;
        }
      }
      
      chars.add(TextSpan(
        text: originalWord[i],
        style: textTheme.bodyLarge?.copyWith(color: charColor),
      ));
    }

    if (isCurrentWord && typedWord.length > originalWord.length) {
      for (int i = originalWord.length; i < typedWord.length; i++) {
        chars.add(TextSpan(
          text: typedWord[i],
          style: textTheme.bodyLarge?.copyWith(
            color: errorColor,
          ),
        ));
      }
    }

    return Container(
      decoration: isCurrentWord && typedWord.length == 0
          ? BoxDecoration(
              border: Border(
                left: BorderSide(color: primaryColor, width: 2),
              ),
            )
          : null,
      child: RichText(
        text: TextSpan(children: chars),
      ),
    );
  }
}
