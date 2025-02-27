import 'package:habit_tracker_app/features/habit_tracking/domain/entities/habit_completion.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/repositories/habit_completion_repository.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/repositories/habit_repository.dart';
import 'package:uuid/uuid.dart';

class ManageHabitCompletionUseCase {
  final HabitCompletionRepository _completionRepository;
  final HabitRepository _habitRepository;
  final Uuid _uuid;

  ManageHabitCompletionUseCase(this._completionRepository, this._habitRepository)
      : _uuid = const Uuid();

  Future<void> completeHabit({
    required String habitId,
    String? note,
  }) async {
    // Create a new completion record
    final completion = HabitCompletion(
      id: _uuid.v4(),
      habitId: habitId,
      completedAt: DateTime.now(),
      note: note,
    );
    
    // Save the completion
    await _completionRepository.saveCompletion(completion);
    
    // Update the habit's streak and completion count
    await _habitRepository.completeHabit(habitId);
  }

  Future<void> deleteCompletion(String completionId) async {
    await _completionRepository.deleteCompletion(completionId);
  }
} 