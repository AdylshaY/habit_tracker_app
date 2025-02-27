import 'package:habit_tracker_app/features/habit_tracking/data/data_sources/habit_local_data_source.dart';
import 'package:habit_tracker_app/features/habit_tracking/data/models/habit_model.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/entities/habit.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitLocalDataSource _localDataSource;

  HabitRepositoryImpl(this._localDataSource);

  @override
  Future<List<Habit>> getAllHabits() async {
    return await _localDataSource.getAllHabits();
  }

  @override
  Future<Habit?> getHabitById(String id) async {
    return await _localDataSource.getHabitById(id);
  }

  @override
  Future<void> saveHabit(Habit habit) async {
    final habitModel =
        habit is HabitModel ? habit : HabitModel.fromEntity(habit);
    await _localDataSource.saveHabit(habitModel);
  }

  @override
  Future<void> deleteHabit(String id) async {
    await _localDataSource.deleteHabit(id);
  }

  @override
  Future<void> completeHabit(String id) async {
    final habit = await _localDataSource.getHabitById(id);
    if (habit != null) {
      final now = DateTime.now();
      final newTotalCompletions = habit.totalCompletions + 1;
      final newStreakCount = habit.isStreakBroken ? 1 : habit.streakCount + 1;
      
      // Check if target is reached with this completion
      final isTargetReached = habit.targetCount > 0 && newTotalCompletions >= habit.targetCount;
      
      // If target is reached, archive the habit (set isActive to false)
      final updatedHabit = HabitModel(
        id: habit.id,
        title: habit.title,
        description: habit.description,
        createdAt: habit.createdAt,
        timePeriod: habit.timePeriod,
        lastCompletedAt: now,
        totalCompletions: newTotalCompletions,
        streakCount: newStreakCount,
        isActive: isTargetReached ? false : habit.isActive,
        targetCount: habit.targetCount,
      );
      
      await _localDataSource.saveHabit(updatedHabit);
    }
  }

  @override
  Future<List<Habit>> getActiveHabits() async {
    return await _localDataSource.getActiveHabits();
  }
}
