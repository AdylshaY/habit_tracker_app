import 'package:habit_tracker_app/features/habit_tracking/domain/entities/habit_completion.dart';

abstract class HabitCompletionRepository {
  Future<List<HabitCompletion>> getCompletionsForHabit(String habitId);
  Future<List<HabitCompletion>> getCompletionsForDateRange(String habitId, DateTime startDate, DateTime endDate);
  Future<void> saveCompletion(HabitCompletion completion);
  Future<void> deleteCompletion(String id);
} 