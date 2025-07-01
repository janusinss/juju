import 'package:flutter/material.dart';
import '../models/typing_stats.dart';
import '../theme.dart';

class StatsDisplay extends StatelessWidget {
  final TypingStats stats;
  final int? timeRemaining;

  const StatsDisplay({
    super.key,
    required this.stats,
    this.timeRemaining,
  });

  @override
  Widget build(BuildContext context) {
    if (stats.wpm == 0 && stats.accuracy == 100 && timeRemaining == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(context, 'WPM', stats.wpm.toStringAsFixed(0)),
        _buildStatItem(context, 'Accuracy', '${stats.accuracy.toStringAsFixed(1)}%'),
        _buildStatItem(context, 'Characters', '${stats.correctChars}/${stats.totalChars}'),
        if (timeRemaining != null)
          _buildStatItem(context, 'Time', '${timeRemaining}s'),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(value, style: textTheme.headlineMedium?.copyWith(color: AppTheme.primaryColor)),
        const SizedBox(height: 4),
        Text(label, style: textTheme.bodyMedium),
      ],
    );
  }
}
