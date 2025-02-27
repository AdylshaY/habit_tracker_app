# Habit Tracker App

A Flutter application that helps users track and maintain their habits with a clean, modern UI and powerful features.

## Features

- **Habit Management**: Add, edit, and delete habits
- **Flexible Tracking**: Track habits with different time intervals (hourly, daily, weekly, monthly)
- **Target Goals**: Set target completion goals for habits
- **Progress Tracking**: Visual progress indicators for habit targets
- **Habit Completion**: Mark habits as completed with a single tap
- **Archive System**: Automatically archive habits when targets are reached
- **History View**: View habit completion history in a calendar view
- **Statistics**: Track streaks and total completions
- **Theme Customization**: Choose between light, dark, or system theme
- **Visual Feedback**: Motivational UI elements to encourage habit formation

## Architecture

This project follows Clean Architecture principles with a feature-first approach:

- **Domain Layer**: Contains business logic, entities, and use cases
- **Data Layer**: Implements repositories and data sources
- **Presentation Layer**: Contains UI components and state management

## Technologies Used

- **State Management**: Flutter Riverpod
- **Navigation**: Go Router
- **Local Storage**: Hive
- **HTTP Client**: Dio (for future extensions)
- **Dependency Injection**: Riverpod

## Screens

- **Habit List**: View and manage all active habits
- **Habit Details**: View detailed information about a specific habit
- **Add/Edit Habit**: Create new habits or modify existing ones
- **Archive**: View completed habits that have reached their targets
- **Settings**: Customize app appearance and preferences

## Getting Started

### Prerequisites

- Flutter SDK (3.6.2 or higher)
- Dart SDK (3.6.2 or higher)

### Installation

1. Clone the repository
2. Install dependencies:
   ```
   flutter pub get
   ```
3. Run the app:
   ```
   flutter run
   ```

## Project Structure

```
lib/
├── features/
│   ├── habit_tracking/
│   │   ├── di/
│   │   │   ├── providers.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   ├── usecases/
│   │   ├── data/
│   │   │   ├── repositories_impl/
│   │   │   ├── data_sources/
│   │   │   ├── models/
│   │   ├── presentation/
│   │   │   ├── models/
│   │   │   ├── providers/
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   ├── settings/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── settings_screen.dart
├── core/
│   ├── domain/
│   │   ├── entities/
│   │   ├── failures/
│   ├── utils/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── theme_provider.dart
│   ├── navigation/
│   │   ├── app_router.dart
├── common/
│   ├── widgets/
│   │   ├── app_drawer.dart
│   │   ├── habit_card.dart
│   │   ├── empty_state.dart
│   │   ├── completion_calendar.dart
├── main.dart
```

## Key Features Implementation

### Theme Management

The app supports three theme modes:

- System theme (follows device settings)
- Light theme
- Dark theme

Theme preferences are stored using Hive and persist across app restarts.

### Habit Targets

Users can set completion targets for habits:

- When a target is reached, the habit is automatically archived
- Progress is visually displayed with progress bars
- Target information is shown on both list and detail views

### Archive System

Completed habits are moved to the archive:

- Habits can be viewed in the archive screen
- Archived habits can be deleted but not modified
- The archive provides a history of accomplished goals
