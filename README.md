# Habit Tracker App

A Flutter application that helps users track and maintain their habits.

## Features

- Add, edit, and delete habits
- Track habits with different time intervals (hourly, daily, weekly, monthly)
- Mark habits as completed
- View habit completion history in a calendar view
- Track streaks and total completions
- Visual feedback to motivate users

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
│   │   ├── habit_tracking.dart
├── core/
│   ├── domain/
│   │   ├── entities/
│   │   ├── failures/
│   ├── utils/
│   │   ├── formatters/
│   │   ├── validators/
│   │   ├── extensions/
│   ├── theme/
│   ├── navigation/
│   ├── network/
├── common/
│   ├── providers/
│   ├── widgets/
│   ├── constants/
```
