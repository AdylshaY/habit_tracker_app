import 'package:habit_tracker_app/features/habit_tracking/domain/entities/habit.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/repositories/habit_repository.dart';

class GetHabitsUseCase {
  final HabitRepository _repository;

  GetHabitsUseCase(this._repository);

  Future<List<Habit>> execute() async {
    return await _repository.getAllHabits();
  }
  
  Future<List<Habit>> getActiveHabits() async {
    return await _repository.getActiveHabits();
  }
  
  Future<Habit?> getHabitById(String id) async {
    return await _repository.getHabitById(id);
  }
} 