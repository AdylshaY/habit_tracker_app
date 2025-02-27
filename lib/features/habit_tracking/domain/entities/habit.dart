import 'package:habit_tracker_app/core/domain/entities/time_period.dart';

class Habit {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final TimePeriod timePeriod;
  final int streakCount;
  final int totalCompletions;
  final DateTime? lastCompletedAt;
  final bool isActive;
  final int targetCount;

  const Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.timePeriod,
    this.streakCount = 0,
    this.totalCompletions = 0,
    this.lastCompletedAt,
    this.isActive = true,
    this.targetCount = 0,
  });

  Habit copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    TimePeriod? timePeriod,
    int? streakCount,
    int? totalCompletions,
    DateTime? lastCompletedAt,
    bool? isActive,
    int? targetCount,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      timePeriod: timePeriod ?? this.timePeriod,
      streakCount: streakCount ?? this.streakCount,
      totalCompletions: totalCompletions ?? this.totalCompletions,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      isActive: isActive ?? this.isActive,
      targetCount: targetCount ?? this.targetCount,
    );
  }

  bool get canBeCompletedNow {
    if (lastCompletedAt == null) {
      return true;
    }
    
    final now = DateTime.now();
    final timeSinceLastCompletion = now.difference(lastCompletedAt!);
    return timeSinceLastCompletion >= timePeriod.duration;
  }

  bool get isStreakBroken {
    if (lastCompletedAt == null) {
      return false;
    }
    
    final now = DateTime.now();
    final timeSinceLastCompletion = now.difference(lastCompletedAt!);
    
    // For daily, weekly, and monthly habits, we give a grace period
    switch (timePeriod) {
      case TimePeriod.daily:
        return timeSinceLastCompletion > const Duration(days: 2);
      case TimePeriod.weekly:
        return timeSinceLastCompletion > const Duration(days: 10);
      case TimePeriod.monthly:
        return timeSinceLastCompletion > const Duration(days: 35);
      default:
        // For hourly habits, the streak is broken if more than 2x the period has passed
        return timeSinceLastCompletion > (timePeriod.duration * 2);
    }
  }
  
  bool get isTargetReached {
    // If targetCount is 0 or negative, target is not applicable
    if (targetCount <= 0) {
      return false;
    }
    
    return totalCompletions >= targetCount;
  }
  
  int get remainingCompletions {
    if (targetCount <= 0) {
      return 0;
    }
    
    final remaining = targetCount - totalCompletions;
    return remaining > 0 ? remaining : 0;
  }
  
  double get progressPercentage {
    if (targetCount <= 0) {
      return 0.0;
    }
    
    return (totalCompletions / targetCount).clamp(0.0, 1.0);
  }
} 