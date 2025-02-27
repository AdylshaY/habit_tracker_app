import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker_app/common/widgets/app_drawer.dart';
import 'package:habit_tracker_app/common/widgets/empty_state.dart';
import 'package:habit_tracker_app/common/widgets/habit_card.dart';
import 'package:habit_tracker_app/features/habit_tracking/di/providers.dart';
import 'package:habit_tracker_app/features/habit_tracking/presentation/models/habit_view_model.dart';
import 'package:habit_tracker_app/features/habit_tracking/presentation/providers/habits_provider.dart';

class HabitListScreen extends ConsumerStatefulWidget {
  const HabitListScreen({super.key});

  @override
  ConsumerState<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends ConsumerState<HabitListScreen> {
  // Local state to handle optimistic updates
  final List<String> _deletedHabitIds = [];
  final List<String> _completedHabitIds = [];

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(activeHabitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Habits'),
      ),
      drawer: const AppDrawer(),
      body: habitsAsync.when(
        data: (habits) {
          // Filter out deleted and completed habits from the UI
          final filteredHabits = habits
              .where((habit) =>
                  !_deletedHabitIds.contains(habit.id) &&
                  !_completedHabitIds.contains(habit.id))
              .toList();

          if (filteredHabits.isEmpty) {
            return EmptyState(
              title: 'No Habits Yet',
              message: 'Start tracking your habits by adding your first one.',
              icon: Icons.track_changes_outlined,
              actionLabel: 'Add Habit',
              onActionPressed: () => context.goNamed('add-habit'),
            );
          }

          return ListView.builder(
            itemCount: filteredHabits.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final habit = filteredHabits[index];
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
                onDismissed: (direction) {
                  // Update local state immediately
                  setState(() {
                    _deletedHabitIds.add(habit.id);
                  });
                  // Then perform the actual deletion
                  _deleteHabit(context, habit.id);
                },
                child: HabitCard(
                  habit: habit,
                  onTap: () => context.goNamed('habit-detail',
                      pathParameters: {'habitId': habit.id}),
                  onComplete: () => _completeHabit(context, habit),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed('add-habit'),
        child: const Icon(Icons.add),
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

  Future<void> _deleteHabit(BuildContext context, String habitId) async {
    try {
      final manageHabitUseCase = ref.read(manageHabitUseCaseProvider);
      await manageHabitUseCase.deleteHabit(habitId);

      // Refresh global state
      ref.invalidate(habitsProvider);
      ref.invalidate(activeHabitsProvider);
      ref.invalidate(completedHabitsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Habit deleted')),
        );
      }
    } catch (e) {
      // If there's an error, remove the habit from the deleted list
      if (mounted) {
        setState(() {
          _deletedHabitIds.remove(habitId);
        });
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _completeHabit(
      BuildContext context, HabitViewModel habit) async {
    // Update local state immediately
    setState(() {
      _completedHabitIds.add(habit.id);
    });

    try {
      final manageHabitCompletionUseCase =
          ref.read(manageHabitCompletionUseCaseProvider);
      await manageHabitCompletionUseCase.completeHabit(habitId: habit.id);

      // Refresh global state
      ref.invalidate(habitsProvider);
      ref.invalidate(activeHabitsProvider);
      ref.invalidate(completedHabitsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Habit completed!')),
        );
      }
    } catch (e) {
      // If there's an error, remove the habit from the completed list
      if (mounted) {
        setState(() {
          _completedHabitIds.remove(habit.id);
        });
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}
