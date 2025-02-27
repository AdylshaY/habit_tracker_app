import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker_app/features/habit_tracking/di/providers.dart';
import 'package:habit_tracker_app/features/habit_tracking/presentation/models/habit_view_model.dart';

final habitsProvider = FutureProvider<List<HabitViewModel>>((ref) async {
  final getHabitsUseCase = ref.watch(getHabitsUseCaseProvider);
  final habits = await getHabitsUseCase.execute();
  return habits.map((habit) => HabitViewModel.fromEntity(habit)).toList();
});

final activeHabitsProvider = FutureProvider<List<HabitViewModel>>((ref) async {
  final getHabitsUseCase = ref.watch(getHabitsUseCaseProvider);
  final habits = await getHabitsUseCase.getActiveHabits();
  return habits.map((habit) => HabitViewModel.fromEntity(habit)).toList();
});

final completedHabitsProvider = FutureProvider<List<HabitViewModel>>((ref) async {
  final getHabitsUseCase = ref.watch(getHabitsUseCaseProvider);
  final allHabits = await getHabitsUseCase.execute();
  final completedHabits = allHabits
      .where((habit) => habit.isTargetReached || (!habit.isActive && habit.targetCount > 0))
      .toList();
  return completedHabits.map((habit) => HabitViewModel.fromEntity(habit)).toList();
});

final habitByIdProvider =
    FutureProvider.family<HabitViewModel?, String>((ref, id) async {
  final getHabitsUseCase = ref.watch(getHabitsUseCaseProvider);
  final habit = await getHabitsUseCase.getHabitById(id);
  if (habit == null) {
    return null;
  }
  return HabitViewModel.fromEntity(habit);
});
