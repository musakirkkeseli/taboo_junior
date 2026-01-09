import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  static final ThemeData themeData = ThemeData(
    useMaterial3: true,
    fontFamily: 'Rubik',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 51.85,
      ),
      displayMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 48,
      ),
      headlineLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 37.48,
      ),
      titleLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 28,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 27.11,
      ),
      titleSmall: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 24,
      ),
      bodyLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      bodyMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      bodySmall: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      labelMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      labelSmall: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      displaySmall: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.blue,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: Colors.amber,
      thumbColor: Colors.yellow,
    ),
    scaffoldBackgroundColor: Colors.transparent,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Colors.white)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Colors.white, width: 2)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Colors.yellow, width: 2)),
      filled: true,
      fillColor: Colors.transparent,
    ),
  );
}
