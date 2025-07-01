import 'package:flutter/material.dart';
import '../models/typing_stats.dart';
import '../theme.dart';

class ResultsScreen extends StatelessWidget {
  final TypingStats stats;
  final VoidCallback onRestart;

  const ResultsScreen({
    super.key,
    required this.stats,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppTheme.secondaryColor,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Test Complete!', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 32),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.5,
              children: [
                _buildResultItem(context, 'WPM', stats.wpm.toStringAsFixed(0)),
                _buildResultItem(context, 'Accuracy', '${stats.accuracy.toStringAsFixed(1)}%'),
                _buildResultItem(context, 'Characters', stats.totalChars.toString()),
                _buildResultItem(context, 'Errors', stats.incorrectChars.toString(), isError: true),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onRestart,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(BuildContext context, String label, String value, {bool isError = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: isError ? Colors.red.shade400 : AppTheme.primaryColor,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
