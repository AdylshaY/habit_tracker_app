import 'package:hive/hive.dart';
import 'package:habit_tracker_app/features/habit_tracking/data/models/habit_completion_model.dart';

abstract class HabitCompletionLocalDataSource {
  Future<List<HabitCompletionModel>> getCompletionsForHabit(String habitId);
  Future<List<HabitCompletionModel>> getCompletionsForDateRange(String habitId, DateTime startDate, DateTime endDate);
  Future<void> saveCompletion(HabitCompletionModel completion);
  Future<void> deleteCompletion(String id);
}

class HabitCompletionLocalDataSourceImpl implements HabitCompletionLocalDataSource {
  static const String _boxName = 'habit_completions';
  
  Future<Box<Map>> _getBox() async {
    return await Hive.openBox<Map>(_boxName);
  }
  
  @override
  Future<List<HabitCompletionModel>> getCompletionsForHabit(String habitId) async {
    final box = await _getBox();
    return box.values
        .map((dynamic item) => HabitCompletionModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .where((completion) => completion.habitId == habitId)
        .toList();
  }
  
  @override
  Future<List<HabitCompletionModel>> getCompletionsForDateRange(String habitId, DateTime startDate, DateTime endDate) async {
    final box = await _getBox();
    return box.values
        .map((dynamic item) => HabitCompletionModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .where((completion) => 
            completion.habitId == habitId && 
            completion.completedAt.isAfter(startDate) && 
            completion.completedAt.isBefore(endDate.add(const Duration(days: 1))))
        .toList();
  }
  
  @override
  Future<void> saveCompletion(HabitCompletionModel completion) async {
    final box = await _getBox();
    await box.put(completion.id, completion.toJson());
  }
  
  @override
  Future<void> deleteCompletion(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
} 