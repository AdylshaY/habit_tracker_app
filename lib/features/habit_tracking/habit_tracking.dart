// Domain
export 'domain/entities/habit.dart';
export 'domain/entities/habit_completion.dart';
export 'domain/repositories/habit_repository.dart';
export 'domain/repositories/habit_completion_repository.dart';
export 'domain/usecases/get_habits_usecase.dart';
export 'domain/usecases/manage_habit_usecase.dart';
export 'domain/usecases/get_habit_completions_usecase.dart';
export 'domain/usecases/manage_habit_completion_usecase.dart';

// Data
export 'data/models/habit_model.dart';
export 'data/models/habit_completion_model.dart';
export 'data/repositories_impl/habit_repository_impl.dart';
export 'data/repositories_impl/habit_completion_repository_impl.dart';

// Presentation
export 'presentation/models/habit_view_model.dart';
export 'presentation/providers/habits_provider.dart';
export 'presentation/providers/habit_completions_provider.dart';
export 'presentation/screens/habit_list_screen.dart';
export 'presentation/screens/habit_detail_screen.dart';
export 'presentation/screens/add_habit_screen.dart';
export 'presentation/screens/edit_habit_screen.dart';

// DI
export 'di/providers.dart'; 