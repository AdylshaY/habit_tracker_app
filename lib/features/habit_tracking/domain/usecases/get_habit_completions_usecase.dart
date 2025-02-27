import 'package:habit_tracker_app/features/habit_tracking/domain/entities/habit_completion.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/repositories/habit_completion_repository.dart';

class GetHabitCompletionsUseCase {
  final HabitCompletionRepository _repository;

  GetHabitCompletionsUseCase(this._repository);

  Future<List<HabitCompletion>> getCompletionsForHabit(String habitId) async {
    return await _repository.getCompletionsForHabit(habitId);
  }

  Future<List<HabitCompletion>> getCompletionsForDateRange(String habitId, DateTime startDate, DateTime endDate) async {
    return await _repository.getCompletionsForDateRange(habitId, startDate, endDate);
  }
  
  Future<Map<DateTime, int>> getCompletionCalendarData(String habitId, DateTime startDate, DateTime endDate) async {
    final completions = await _repository.getCompletionsForDateRange(habitId, startDate, endDate);
    
    final Map<DateTime, int> calendarData = {};
    
    for (final completion in completions) {
      final date = DateTime(
        completion.completedAt.year,
        completion.completedAt.month,
        completion.completedAt.day,
      );
      
      calendarData[date] = (calendarData[date] ?? 0) + 1;
    }
    
    return calendarData;
  }
} 