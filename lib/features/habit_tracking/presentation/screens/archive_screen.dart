import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker_app/common/widgets/empty_state.dart';
import 'package:habit_tracker_app/common/widgets/habit_card.dart';
import 'package:habit_tracker_app/features/habit_tracking/di/providers.dart';
import 'package:habit_tracker_app/features/habit_tracking/presentation/providers/habits_provider.dart';

class ArchiveScreen extends ConsumerWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedHabitsAsync = ref.watch(completedHabitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'),
      ),
      body: completedHabitsAsync.when(
        data: (habits) {
          if (habits.isEmpty) {
            return EmptyState(
              title: 'No Completed Habits',
              message: 'Habits that reach their target will appear here.',
              icon: Icons.emoji_events_outlined,
              actionLabel: 'Go to My Habits',
              onActionPressed: () => context.goNamed('home'),
            );
          }

          return ListView.builder(
            itemCount: habits.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final habit = habits[index];
              return Dismissible(
                key: Key(habit.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await _showDeleteConfirmation(context);
                },
                onDismissed: (direction) async {
                  await _deleteHabit(context, ref, habit.id);
                },
                child: HabitCard(
                  habit: habit,
                  onTap: () => context.goNamed('habit-detail',
                      pathParameters: {'habitId': habit.id}),
                  onComplete: () {}, // Empty callback for archived habits
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Habit'),
            content: const Text(
                'Are you sure you want to delete this habit? This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deleteHabit(
      BuildContext context, WidgetRef ref, String habitId) async {
    try {
      final manageHabitUseCase = ref.read(manageHabitUseCaseProvider);
      await manageHabitUseCase.deleteHabit(habitId);

      // Refresh data
      ref.invalidate(habitsProvider);
      ref.invalidate(activeHabitsProvider);
      ref.invalidate(completedHabitsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Habit deleted')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}
