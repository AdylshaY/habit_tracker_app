import 'package:habit_tracker_app/core/domain/entities/time_period.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/entities/habit.dart';

class HabitViewModel {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final TimePeriod timePeriod;
  final int streakCount;
  final int totalCompletions;
  final DateTime? lastCompletedAt;
  final bool isActive;
  final bool canBeCompletedNow;
  final bool isStreakBroken;
  final int targetCount;
  final bool isTargetReached;
  final int remainingCompletions;
  final double progressPercentage;

  HabitViewModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.timePeriod,
    required this.streakCount,
    required this.totalCompletions,
    this.lastCompletedAt,
    required this.isActive,
    required this.canBeCompletedNow,
    required this.isStreakBroken,
    required this.targetCount,
    required this.isTargetReached,
    required this.remainingCompletions,
    required this.progressPercentage,
  });

  factory HabitViewModel.fromEntity(Habit habit) {
    return HabitViewModel(
      id: habit.id,
      title: habit.title,
      description: habit.description,
      createdAt: habit.createdAt,
      timePeriod: habit.timePeriod,
      streakCount: habit.streakCount,
      totalCompletions: habit.totalCompletions,
      lastCompletedAt: habit.lastCompletedAt,
      isActive: habit.isActive,
      canBeCompletedNow: habit.canBeCompletedNow,
      isStreakBroken: habit.isStreakBroken,
      targetCount: habit.targetCount,
      isTargetReached: habit.isTargetReached,
      remainingCompletions: habit.remainingCompletions,
      progressPercentage: habit.progressPercentage,
    );
  }

  String get formattedTimePeriod => timePeriod.displayName;
  
  String get formattedLastCompletedAt {
    if (lastCompletedAt == null) {
      return 'Never';
    }
    
    final now = DateTime.now();
    final difference = now.difference(lastCompletedAt!);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months months ago';
    }
  }
  
  String get formattedTargetProgress {
    if (targetCount <= 0) {
      return 'No target set';
    }
    
    return '$totalCompletions / $targetCount (${(progressPercentage * 100).toInt()}%)';
  }
  
  String get formattedRemainingCompletions {
    if (targetCount <= 0) {
      return 'No target set';
    }
    
    if (isTargetReached) {
      return 'Target reached!';
    }
    
    return '$remainingCompletions more to go';
  }
} 