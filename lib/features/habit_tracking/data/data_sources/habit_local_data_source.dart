import 'package:hive/hive.dart';
import 'package:habit_tracker_app/features/habit_tracking/data/models/habit_model.dart';

abstract class HabitLocalDataSource {
  Future<List<HabitModel>> getAllHabits();
  Future<HabitModel?> getHabitById(String id);
  Future<void> saveHabit(HabitModel habit);
  Future<void> deleteHabit(String id);
  Future<List<HabitModel>> getActiveHabits();
}

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  static const String _boxName = 'habits';
  
  Future<Box<Map>> _getBox() async {
    return await Hive.openBox<Map>(_boxName);
  }
  
  @override
  Future<List<HabitModel>> getAllHabits() async {
    final box = await _getBox();
    return box.values
        .map((dynamic item) => HabitModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
  
  @override
  Future<HabitModel?> getHabitById(String id) async {
    final box = await _getBox();
    final habitMap = box.get(id);
    if (habitMap == null) {
      return null;
    }
    return HabitModel.fromJson(Map<String, dynamic>.from(habitMap));
  }
  
  @override
  Future<void> saveHabit(HabitModel habit) async {
    final box = await _getBox();
    await box.put(habit.id, habit.toJson());
  }
  
  @override
  Future<void> deleteHabit(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
  
  @override
  Future<List<HabitModel>> getActiveHabits() async {
    final box = await _getBox();
    return box.values
        .map((dynamic item) => HabitModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .where((habit) => habit.isActive)
        .toList();
  }
} 