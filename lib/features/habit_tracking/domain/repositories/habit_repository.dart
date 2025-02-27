import 'package:habit_tracker_app/features/habit_tracking/domain/entities/habit.dart';

abstract class HabitRepository {
  Future<List<Habit>> getAllHabits();
  Future<Habit?> getHabitById(String id);
  Future<void> saveHabit(Habit habit);
  Future<void> deleteHabit(String id);
  Future<void> completeHabit(String id);
  Future<List<Habit>> getActiveHabits();
} 