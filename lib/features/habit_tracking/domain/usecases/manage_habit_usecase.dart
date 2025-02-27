import 'package:habit_tracker_app/core/domain/entities/time_period.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/entities/habit.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/repositories/habit_repository.dart';
import 'package:uuid/uuid.dart';

class ManageHabitUseCase {
  final HabitRepository _repository;
  final Uuid _uuid;

  ManageHabitUseCase(this._repository) : _uuid = const Uuid();

  Future<void> createHabit({
    required String title,
    required String description,
    required TimePeriod timePeriod,
    int targetCount = 0,
  }) async {
    final habit = Habit(
      id: _uuid.v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      timePeriod: timePeriod,
      targetCount: targetCount,
    );
    await _repository.saveHabit(habit);
  }

  Future<void> updateHabit({
    required String id,
    String? title,
    String? description,
    TimePeriod? timePeriod,
    bool? isActive,
    int? targetCount,
  }) async {
    final habit = await _repository.getHabitById(id);
    if (habit != null) {
      final updatedHabit = habit.copyWith(
        title: title,
        description: description,
        timePeriod: timePeriod,
        isActive: isActive,
        targetCount: targetCount,
      );
      await _repository.saveHabit(updatedHabit);
    }
  }

  Future<void> deleteHabit(String id) async {
    await _repository.deleteHabit(id);
  }

  Future<void> completeHabit(String id) async {
    await _repository.completeHabit(id);
  }
} 