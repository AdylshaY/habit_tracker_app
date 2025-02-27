import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker_app/core/domain/entities/time_period.dart';
import 'package:habit_tracker_app/features/habit_tracking/di/providers.dart';
import 'package:habit_tracker_app/features/habit_tracking/presentation/providers/habits_provider.dart';

class EditHabitScreen extends ConsumerStatefulWidget {
  final String habitId;

  const EditHabitScreen({
    super.key,
    required this.habitId,
  });

  @override
  ConsumerState<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends ConsumerState<EditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetCountController = TextEditingController();
  TimePeriod _selectedTimePeriod = TimePeriod.daily;
  bool _isLoading = false;
  bool _hasTarget = false;
  bool _isInitialized = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habitAsync = ref.watch(habitByIdProvider(widget.habitId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Habit'),
      ),
      body: habitAsync.when(
        data: (habit) {
          if (habit == null) {
            return const Center(
              child: Text('Habit not found'),
            );
          }

          // Initialize form fields with habit data
          if (!_isInitialized) {
            _titleController.text = habit.title;
            _descriptionController.text = habit.description;
            _selectedTimePeriod = habit.timePeriod;
            _hasTarget = habit.targetCount > 0;
            if (_hasTarget) {
              _targetCountController.text = habit.targetCount.toString();
            }
            _isInitialized = true;
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Habit Title',
                    hintText: 'Enter a title for your habit',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter a description for your habit',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  maxLines: 3,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 24),
                Text(
                  'How often do you want to track this habit?',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                _buildTimePeriodSelector(),
                const SizedBox(height: 24),

                // Target count section
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Set a target goal for this habit?',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Switch(
                      value: _hasTarget,
                      onChanged: (value) {
                        setState(() {
                          _hasTarget = value;
                          if (!value) {
                            _targetCountController.clear();
                          }
                        });
                      },
                    ),
                  ],
                ),

                if (_hasTarget) ...[
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _targetCountController,
                          decoration: InputDecoration(
                            labelText: 'Target Count',
                            hintText: 'How many times?',
                            border: const OutlineInputBorder(),
                            suffixText:
                                _selectedTimePeriod.displayName.toLowerCase(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (_hasTarget) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a target count';
                              }
                              final count = int.tryParse(value);
                              if (count == null || count <= 0) {
                                return 'Please enter a valid number greater than 0';
                              }

                              // Check if the new target is less than current completions
                              if (count < habit.totalCompletions) {
                                return 'Target must be greater than current completions (${habit.totalCompletions})';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'When you reach this target, the habit will be automatically archived.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],

                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : () => _updateHabit(habit),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Save Changes'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildTimePeriodSelector() {
    return Column(
      children: TimePeriod.values.map((period) {
        return RadioListTile<TimePeriod>(
          title: Text(period.displayName),
          value: period,
          groupValue: _selectedTimePeriod,
          onChanged: (TimePeriod? value) {
            if (value != null) {
              setState(() {
                _selectedTimePeriod = value;
              });
            }
          },
        );
      }).toList(),
    );
  }

  Future<void> _updateHabit(habit) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final manageHabitUseCase = ref.read(manageHabitUseCaseProvider);

      // Parse target count if enabled
      int targetCount = 0;
      if (_hasTarget && _targetCountController.text.isNotEmpty) {
        targetCount = int.tryParse(_targetCountController.text) ?? 0;
      }

      // Check if the target is reached with the new target count
      final isTargetReached =
          targetCount > 0 && habit.totalCompletions >= targetCount;

      await manageHabitUseCase.updateHabit(
        id: widget.habitId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        timePeriod: _selectedTimePeriod,
        targetCount: targetCount,
        isActive: isTargetReached ? false : habit.isActive,
      );

      // Invalidate providers to refresh the habit list
      ref.invalidate(habitByIdProvider(widget.habitId));
      ref.invalidate(habitsProvider);
      ref.invalidate(activeHabitsProvider);
      ref.invalidate(completedHabitsProvider);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Habit updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
