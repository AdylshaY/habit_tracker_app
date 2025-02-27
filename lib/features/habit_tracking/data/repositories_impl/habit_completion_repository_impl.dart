import 'package:habit_tracker_app/features/habit_tracking/data/data_sources/habit_completion_local_data_source.dart';
import 'package:habit_tracker_app/features/habit_tracking/data/models/habit_completion_model.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/entities/habit_completion.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/repositories/habit_completion_repository.dart';

class HabitCompletionRepositoryImpl implements HabitCompletionRepository {
  final HabitCompletionLocalDataSource _localDataSource;

  HabitCompletionRepositoryImpl(this._localDataSource);

  @override
  Future<List<HabitCompletion>> getCompletionsForHabit(String habitId) async {
    return await _localDataSource.getCompletionsForHabit(habitId);
  }

  @override
  Future<List<HabitCompletion>> getCompletionsForDateRange(
      String habitId, DateTime startDate, DateTime endDate) async {
    return await _localDataSource.getCompletionsForDateRange(
        habitId, startDate, endDate);
  }

  @override
  Future<void> saveCompletion(HabitCompletion completion) async {
    final completionModel = completion is HabitCompletionModel
        ? completion
        : HabitCompletionModel.fromEntity(completion);
    await _localDataSource.saveCompletion(completionModel);
  }

  @override
  Future<void> deleteCompletion(String id) async {
    await _localDataSource.deleteCompletion(id);
  }
}
