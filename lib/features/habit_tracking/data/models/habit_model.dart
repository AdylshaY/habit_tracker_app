import 'package:habit_tracker_app/core/domain/entities/time_period.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/entities/habit.dart';

class HabitModel extends Habit {
  const HabitModel({
    required super.id,
    required super.title,
    required super.description,
    required super.createdAt,
    required super.timePeriod,
    super.streakCount = 0,
    super.totalCompletions = 0,
    super.lastCompletedAt,
    super.isActive = true,
    super.targetCount = 0,
  });

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      timePeriod: TimePeriod.values[json['timePeriod'] as int],
      streakCount: json['streakCount'] as int? ?? 0,
      totalCompletions: json['totalCompletions'] as int? ?? 0,
      lastCompletedAt: json['lastCompletedAt'] != null
          ? DateTime.parse(json['lastCompletedAt'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
      targetCount: json['targetCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'timePeriod': timePeriod.index,
      'streakCount': streakCount,
      'totalCompletions': totalCompletions,
      'lastCompletedAt': lastCompletedAt?.toIso8601String(),
      'isActive': isActive,
      'targetCount': targetCount,
    };
  }

  factory HabitModel.fromEntity(Habit habit) {
    return HabitModel(
      id: habit.id,
      title: habit.title,
      description: habit.description,
      createdAt: habit.createdAt,
      timePeriod: habit.timePeriod,
      streakCount: habit.streakCount,
      totalCompletions: habit.totalCompletions,
      lastCompletedAt: habit.lastCompletedAt,
      isActive: habit.isActive,
      targetCount: habit.targetCount,
    );
  }
} 