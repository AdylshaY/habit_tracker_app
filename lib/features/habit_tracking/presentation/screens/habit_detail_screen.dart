import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker_app/common/widgets/completion_calendar.dart';
import 'package:habit_tracker_app/features/habit_tracking/di/providers.dart';
import 'package:habit_tracker_app/features/habit_tracking/presentation/providers/habit_completions_provider.dart';
import 'package:habit_tracker_app/features/habit_tracking/presentation/providers/habits_provider.dart';
import 'package:intl/intl.dart';

class HabitDetailScreen extends ConsumerStatefulWidget {
  final String habitId;

  const HabitDetailScreen({
    super.key,
    required this.habitId,
  });

  @override
  ConsumerState<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends ConsumerState<HabitDetailScreen> {
  bool _isCompletingHabit = false;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();

    // Takvim için tarih aralığını hesapla (son 30 gün)
    final now = DateTime.now();
    _startDate = now.subtract(const Duration(days: 29));
    _endDate = now;

    // Sayfa açıldığında verileri yenile
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(habitByIdProvider(widget.habitId));
      ref.invalidate(habitCalendarDataProvider((
        habitId: widget.habitId,
        startDate: _startDate,
        endDate: _endDate,
      )));
    });
  }

  @override
  Widget build(BuildContext context) {
    final habitAsync = ref.watch(habitByIdProvider(widget.habitId));

    // Takvim verilerini önceden hesaplanmış tarih aralığı ile al
    final calendarDataAsync = ref.watch(
      habitCalendarDataProvider((
        habitId: widget.habitId,
        startDate: _startDate,
        endDate: _endDate,
      )),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.pushNamed(
              'edit-habit',
              pathParameters: {'habitId': widget.habitId},
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context, ref),
          ),
        ],
      ),
      body: habitAsync.when(
        data: (habit) {
          if (habit == null) {
            return const Center(
              child: Text('Habit not found'),
            );
          }

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      habit.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                        context, 'Frequency', habit.formattedTimePeriod),
                    _buildInfoRow(context, 'Created',
                        DateFormat.yMMMd().format(habit.createdAt)),
                    _buildInfoRow(context, 'Current Streak',
                        '${habit.streakCount} ${habit.streakCount == 1 ? 'time' : 'times'}'),
                    _buildInfoRow(context, 'Total Completions',
                        habit.totalCompletions.toString()),
                    _buildInfoRow(context, 'Last Completed',
                        habit.formattedLastCompletedAt),
                    _buildInfoRow(context, 'Status', _getStatusText(habit)),

                    // Add target information
                    if (habit.targetCount > 0) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Target Progress',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: habit.progressPercentage,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(context, 'Target',
                          '${habit.targetCount} ${habit.timePeriod.displayName.toLowerCase()}'),
                      _buildInfoRow(
                          context, 'Progress', habit.formattedTargetProgress),
                      _buildInfoRow(context, 'Remaining',
                          habit.formattedRemainingCompletions),
                      if (habit.isTargetReached)
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Congratulations! You have reached your target for this habit.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.green[800],
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            (habit.canBeCompletedNow && !_isCompletingHabit)
                                ? () => _completeHabit(context, ref)
                                : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isCompletingHabit
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Complete Now'),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              calendarDataAsync.when(
                data: (calendarData) => CompletionCalendar(
                  completionData: calendarData,
                  startDate: _startDate,
                  endDate: _endDate,
                ),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error loading calendar data: $error'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(habit) {
    if (!habit.isActive) {
      if (habit.isTargetReached) {
        return 'Completed (Target Reached)';
      }
      return 'Inactive';
    } else if (habit.isStreakBroken) {
      return 'Streak Broken';
    } else if (habit.canBeCompletedNow) {
      return 'Ready to Complete';
    } else {
      return 'Waiting for Next Time';
    }
  }

  Future<void> _completeHabit(BuildContext context, WidgetRef ref) async {
    if (_isCompletingHabit) return;

    setState(() {
      _isCompletingHabit = true;
    });

    try {
      final manageHabitCompletionUseCase =
          ref.read(manageHabitCompletionUseCaseProvider);
      await manageHabitCompletionUseCase.completeHabit(habitId: widget.habitId);

      // Refresh data
      ref.invalidate(habitByIdProvider(widget.habitId));
      ref.invalidate(habitsProvider);
      ref.invalidate(activeHabitsProvider);
      ref.invalidate(completedHabitsProvider);
      ref.invalidate(habitCompletionsProvider(widget.habitId));

      // Takvim verilerini de yenile
      ref.invalidate(habitCalendarDataProvider((
        habitId: widget.habitId,
        startDate: _startDate,
        endDate: _endDate,
      )));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Habit completed!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCompletingHabit = false;
        });
      }
    }
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, WidgetRef ref) async {
    final result = await showDialog<bool>(
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
    );

    if (result == true && context.mounted) {
      try {
        final manageHabitUseCase = ref.read(manageHabitUseCaseProvider);
        await manageHabitUseCase.deleteHabit(widget.habitId);

        // Refresh data
        ref.invalidate(habitsProvider);
        ref.invalidate(activeHabitsProvider);
        ref.invalidate(completedHabitsProvider);

        if (context.mounted) {
          context.pop();
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
}
