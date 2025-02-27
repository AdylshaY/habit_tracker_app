import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker_app/features/habit_tracking/presentation/screens/archive_screen.dart';
import 'package:habit_tracker_app/features/habit_tracking/presentation/screens/edit_habit_screen.dart';
import 'package:habit_tracker_app/features/habit_tracking/presentation/screens/habit_detail_screen.dart';
import 'package:habit_tracker_app/features/habit_tracking/presentation/screens/habit_list_screen.dart';
import 'package:habit_tracker_app/features/habit_tracking/presentation/screens/add_habit_screen.dart';
import 'package:habit_tracker_app/features/settings/presentation/screens/settings_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HabitListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            name: 'add-habit',
            builder: (context, state) => const AddHabitScreen(),
          ),
          GoRoute(
            path: 'habit/:habitId',
            name: 'habit-detail',
            builder: (context, state) {
              final habitId = state.pathParameters['habitId']!;
              return HabitDetailScreen(habitId: habitId);
            },
          ),
          GoRoute(
            path: 'edit-habit/:habitId',
            name: 'edit-habit',
            builder: (context, state) {
              final habitId = state.pathParameters['habitId']!;
              return EditHabitScreen(habitId: habitId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/archive',
        name: 'archive',
        builder: (context, state) => const ArchiveScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri}'),
      ),
    ),
  );
}); 