import 'package:flutter/material.dart';
import 'package:habit_tracker_app/features/habit_tracking/presentation/models/habit_view_model.dart';

class HabitCard extends StatelessWidget {
  final HabitViewModel habit;
  final VoidCallback onTap;
  final VoidCallback onComplete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      habit.title,
                      style: theme.textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusIndicator(theme),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                habit.description,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoChip(
                    theme,
                    Icons.timer_outlined,
                    habit.formattedTimePeriod,
                  ),
                  _buildInfoChip(
                    theme,
                    Icons.local_fire_department_outlined,
                    'Streak: ${habit.streakCount}',
                  ),
                  _buildInfoChip(
                    theme,
                    Icons.check_circle_outline,
                    'Total: ${habit.totalCompletions}',
                  ),
                  _buildInfoChip(
                    theme,
                    Icons.flag_outlined,
                    'Target: ${habit.targetCount}',
                  ),
                ],
              ),
              if (habit.targetCount > 0) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(
                            value: habit.progressPercentage,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            habit.isTargetReached
                                ? 'Target reached!'
                                : '${(habit.progressPercentage * 100).toInt()}% complete',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: habit.isTargetReached
                                  ? Colors.green
                                  : theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Last completed: ${habit.formattedLastCompletedAt}',
                    style: theme.textTheme.bodySmall,
                  ),
                  ElevatedButton(
                    onPressed: habit.canBeCompletedNow ? onComplete : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      textStyle: theme.textTheme.labelLarge,
                    ),
                    child: const Text('Complete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(ThemeData theme) {
    if (!habit.isActive) {
      if (habit.isTargetReached) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Completed',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Inactive',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      );
    } else if (habit.isStreakBroken) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Streak Broken',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      );
    } else if (habit.canBeCompletedNow) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Ready',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Waiting',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      );
    }
  }

  Widget _buildInfoChip(ThemeData theme, IconData icon, String label) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
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
