import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        surface: Colors.white,
        onSurface: Colors.black,
        primary: Colors.deepPurple,
        onPrimary: Colors.white,
        secondary: Colors.indigoAccent,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        surface: Colors.black,
        onSurface: Colors.white,
        primary: Colors.deepPurple,
        onPrimary: Colors.white,
        secondary: Colors.indigoAccent,
      ),
    );
  }
}
