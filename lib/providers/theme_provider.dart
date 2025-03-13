import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get theme => _isDarkMode ? darkTheme : lightTheme;

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    primaryColor: const Color(0xFF7FE1F5),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF7FE1F5),
      secondary: const Color(0xFF6C63FF),
      surface: const Color(0xFF2A2A2A),
      background: const Color(0xFF1A1A1A),
      error: Colors.red.shade400,
    ),
  );

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF8F9FF),
    primaryColor: const Color(0xFF6C63FF),
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF6C63FF),
      secondary: const Color(0xFF7FE1F5),
      surface: Colors.white,
      background: const Color(0xFFF8F9FF),
      error: Colors.red.shade600,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: const Color(0xFF2A2A2A),
      onBackground: const Color(0xFF2A2A2A),
    ),
    cardColor: Colors.white,
    shadowColor: const Color(0xFF6C63FF).withOpacity(0.15),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: Color(0xFF2A2A2A)),
      headlineMedium: TextStyle(color: Color(0xFF2A2A2A)),
      titleLarge: TextStyle(color: Color(0xFF2A2A2A)),
      titleMedium: TextStyle(color: Color(0xFF2A2A2A)),
      bodyLarge: TextStyle(color: Color(0xFF2A2A2A)),
      bodyMedium: TextStyle(color: Color(0xFF2A2A2A)),
    ),
  );
}
