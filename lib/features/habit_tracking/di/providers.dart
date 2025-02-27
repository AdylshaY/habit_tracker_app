import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker_app/features/habit_tracking/data/data_sources/habit_completion_local_data_source.dart';
import 'package:habit_tracker_app/features/habit_tracking/data/data_sources/habit_local_data_source.dart';
import 'package:habit_tracker_app/features/habit_tracking/data/repositories_impl/habit_completion_repository_impl.dart';
import 'package:habit_tracker_app/features/habit_tracking/data/repositories_impl/habit_repository_impl.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/repositories/habit_completion_repository.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/repositories/habit_repository.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/usecases/get_habit_completions_usecase.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/usecases/get_habits_usecase.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/usecases/manage_habit_completion_usecase.dart';
import 'package:habit_tracker_app/features/habit_tracking/domain/usecases/manage_habit_usecase.dart';

// Data Sources
final habitLocalDataSourceProvider = Provider<HabitLocalDataSource>((ref) {
  return HabitLocalDataSourceImpl();
});

final habitCompletionLocalDataSourceProvider = Provider<HabitCompletionLocalDataSource>((ref) {
  return HabitCompletionLocalDataSourceImpl();
});

// Repositories
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final dataSource = ref.watch(habitLocalDataSourceProvider);
  return HabitRepositoryImpl(dataSource);
});

final habitCompletionRepositoryProvider = Provider<HabitCompletionRepository>((ref) {
  final dataSource = ref.watch(habitCompletionLocalDataSourceProvider);
  return HabitCompletionRepositoryImpl(dataSource);
});

// Use Cases
final getHabitsUseCaseProvider = Provider<GetHabitsUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return GetHabitsUseCase(repository);
});

final manageHabitUseCaseProvider = Provider<ManageHabitUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return ManageHabitUseCase(repository);
});

final getHabitCompletionsUseCaseProvider = Provider<GetHabitCompletionsUseCase>((ref) {
  final repository = ref.watch(habitCompletionRepositoryProvider);
  return GetHabitCompletionsUseCase(repository);
});

final manageHabitCompletionUseCaseProvider = Provider<ManageHabitCompletionUseCase>((ref) {
  final completionRepository = ref.watch(habitCompletionRepositoryProvider);
  final habitRepository = ref.watch(habitRepositoryProvider);
  return ManageHabitCompletionUseCase(completionRepository, habitRepository);
}); 