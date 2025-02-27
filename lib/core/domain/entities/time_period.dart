enum TimePeriod {
  hourly,
  sixHours,
  twelveHours,
  daily,
  weekly,
  monthly;

  String get displayName {
    switch (this) {
      case TimePeriod.hourly:
        return 'Every Hour';
      case TimePeriod.sixHours:
        return 'Every 6 Hours';
      case TimePeriod.twelveHours:
        return 'Every 12 Hours';
      case TimePeriod.daily:
        return 'Daily';
      case TimePeriod.weekly:
        return 'Weekly';
      case TimePeriod.monthly:
        return 'Monthly';
    }
  }

  Duration get duration {
    switch (this) {
      case TimePeriod.hourly:
        return const Duration(hours: 1);
      case TimePeriod.sixHours:
        return const Duration(hours: 6);
      case TimePeriod.twelveHours:
        return const Duration(hours: 12);
      case TimePeriod.daily:
        return const Duration(days: 1);
      case TimePeriod.weekly:
        return const Duration(days: 7);
      case TimePeriod.monthly:
        return const Duration(days: 30); // Approximation
    }
  }
} 