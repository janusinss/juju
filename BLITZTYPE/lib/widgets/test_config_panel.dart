import 'package:flutter/material.dart';
import '../models/test_config.dart';
import '../theme.dart';

class TestConfigPanel extends StatelessWidget {
  final TestConfig config;
  final Function(TestConfig) onConfigChanged;

  const TestConfigPanel({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeConfig(context),
        const SizedBox(width: 24),
        _buildTypeConfig(context),
      ],
    );
  }

  Widget _buildTimeConfig(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildConfigButton(
            context,
            '15s',
            config.mode == TestMode.time && config.duration == TestDuration.fifteen,
            () => onConfigChanged(const TestConfig(mode: TestMode.time, duration: TestDuration.fifteen)),
          ),
          _buildConfigButton(
            context,
            '30s',
            config.mode == TestMode.time && config.duration == TestDuration.thirty,
            () => onConfigChanged(const TestConfig(mode: TestMode.time, duration: TestDuration.thirty)),
          ),
          _buildConfigButton(
            context,
            '60s',
            config.mode == TestMode.time && config.duration == TestDuration.sixty,
            () => onConfigChanged(const TestConfig(mode: TestMode.time, duration: TestDuration.sixty)),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeConfig(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildConfigButton(
            context,
            'Text',
            config.type == TestType.text,
            () => onConfigChanged(TestConfig(mode: config.mode, type: TestType.text, duration: config.duration, wordCount: config.wordCount)),
          ),
          _buildConfigButton(
            context,
            'Code',
            config.type == TestType.code,
            () => onConfigChanged(TestConfig(mode: config.mode, type: TestType.code, duration: config.duration, wordCount: config.wordCount)),
          ),
          _buildConfigButton(
            context,
            'Numbers',
            config.type == TestType.numbers,
            () => onConfigChanged(TestConfig(mode: config.mode, type: TestType.numbers, duration: config.duration, wordCount: config.wordCount)),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigButton(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onPressed, {
    bool disabled = false,
  }) {
    return TextButton(
      onPressed: disabled ? null : onPressed,
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? AppTheme.primaryColor : Colors.transparent,
        foregroundColor: isSelected ? AppTheme.backgroundColor : AppTheme.subTextColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
