import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

// Theme mode notifier to manage theme state
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  static const String _themeBoxName = 'app_settings';
  static const String _themeModeKey = 'theme_mode';

  // Load theme mode from local storage
  Future<void> _loadThemeMode() async {
    try {
      final box = await Hive.openBox(_themeBoxName);
      final savedThemeMode = box.get(_themeModeKey);

      if (savedThemeMode != null) {
        state = ThemeMode.values[savedThemeMode];
      }
    } catch (e) {
      // If there's an error, use system theme as default
      state = ThemeMode.system;
    }
  }

  // Save theme mode to local storage
  Future<void> _saveThemeMode(ThemeMode mode) async {
    try {
      final box = await Hive.openBox(_themeBoxName);
      await box.put(_themeModeKey, mode.index);
    } catch (e) {
      // Ignore errors when saving
    }
  }

  // Change theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _saveThemeMode(mode);
  }
}

// Provider for theme mode
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});
