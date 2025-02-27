class HabitCompletion {
  final String id;
  final String habitId;
  final DateTime completedAt;
  final String? note;

  const HabitCompletion({
    required this.id,
    required this.habitId,
    required this.completedAt,
    this.note,
  });

  HabitCompletion copyWith({
    String? id,
    String? habitId,
    DateTime? completedAt,
    String? note,
  }) {
    return HabitCompletion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      completedAt: completedAt ?? this.completedAt,
      note: note ?? this.note,
    );
  }
} 