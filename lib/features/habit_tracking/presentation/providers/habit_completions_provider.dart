import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker_app/features/habit_tracking/di/providers.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/entities/habit_completion.dart';

final habitCompletionsProvider = FutureProvider.family<List<HabitCompletion>, String>((ref, habitId) async {
  final getHabitCompletionsUseCase = ref.watch(getHabitCompletionsUseCaseProvider);
  return await getHabitCompletionsUseCase.getCompletionsForHabit(habitId);
});

final habitCompletionsForDateRangeProvider = FutureProvider.family<List<HabitCompletion>, ({String habitId, DateTime startDate, DateTime endDate})>((ref, params) async {
  final getHabitCompletionsUseCase = ref.watch(getHabitCompletionsUseCaseProvider);
  return await getHabitCompletionsUseCase.getCompletionsForDateRange(
    params.habitId,
    params.startDate,
    params.endDate,
  );
});

final habitCalendarDataProvider = FutureProvider.family<Map<DateTime, int>, ({String habitId, DateTime startDate, DateTime endDate})>((ref, params) async {
  final getHabitCompletionsUseCase = ref.watch(getHabitCompletionsUseCaseProvider);
  return await getHabitCompletionsUseCase.getCompletionCalendarData(
    params.habitId,
    params.startDate,
    params.endDate,
  );
}); 