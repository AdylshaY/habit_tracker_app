import 'package:habit_tracker_app/features/habit_tracking/domain/entities/habit_completion.dart';

class HabitCompletionModel extends HabitCompletion {
  const HabitCompletionModel({
    required super.id,
    required super.habitId,
    required super.completedAt,
    super.note,
  });

  factory HabitCompletionModel.fromJson(Map<String, dynamic> json) {
    return HabitCompletionModel(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'completedAt': completedAt.toIso8601String(),
      'note': note,
    };
  }

  factory HabitCompletionModel.fromEntity(HabitCompletion completion) {
    return HabitCompletionModel(
      id: completion.id,
      habitId: completion.habitId,
      completedAt: completion.completedAt,
      note: completion.note,
    );
  }
} 