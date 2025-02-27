import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompletionCalendar extends StatelessWidget {
  final Map<DateTime, int> completionData;
  final DateTime startDate;
  final DateTime endDate;

  const CompletionCalendar({
    super.key,
    required this.completionData,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysInRange = endDate.difference(startDate).inDays + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Completion History',
            style: theme.textTheme.titleMedium,
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: daysInRange,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final date = endDate.add(Duration(days: index));
              final completions =
                  completionData[DateTime(date.year, date.month, date.day)] ??
                      0;
              return _buildDayCell(context, date, completions);
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildLegendItem(theme, Colors.transparent, 'None'),
              const SizedBox(width: 16),
              _buildLegendItem(theme,
                  theme.colorScheme.primary.withValues(alpha: 0.3), 'Low'),
              const SizedBox(width: 16),
              _buildLegendItem(theme,
                  theme.colorScheme.primary.withValues(alpha: 0.6), 'Medium'),
              const SizedBox(width: 16),
              _buildLegendItem(theme, theme.colorScheme.primary, 'High'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayCell(BuildContext context, DateTime date, int completions) {
    final theme = Theme.of(context);
    final isToday = DateTime.now().day == date.day &&
        DateTime.now().month == date.month &&
        DateTime.now().year == date.year;

    Color cellColor;
    if (completions == 0) {
      cellColor = Colors.transparent;
    } else if (completions == 1) {
      cellColor = theme.colorScheme.primary.withValues(alpha: 0.3);
    } else if (completions <= 3) {
      cellColor = theme.colorScheme.primary.withValues(alpha: 0.6);
    } else {
      cellColor = theme.colorScheme.primary;
    }

    return Container(
      width: 50,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: cellColor,
        border: Border.all(
          color: isToday ? theme.colorScheme.primary : Colors.grey.shade300,
          width: isToday ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('E').format(date),
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            date.day.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            completions.toString(),
            style: theme.textTheme.bodySmall?.copyWith(
              color:
                  completions > 0 ? Colors.white : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(ThemeData theme, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
