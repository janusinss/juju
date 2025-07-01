import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFF4B860);
  static const Color secondaryColor = Color(0xFF2C2E31);
  static const Color backgroundColor = Color(0xFF191919);
  static const Color textColor = Color(0xFFE0E0E0);
  static const Color subTextColor = Color(0xFF8A8A8A);

  static final ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    hintColor: secondaryColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: primaryColor),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
      bodyLarge: TextStyle(fontSize: 22, color: textColor, letterSpacing: 1.5),
      bodyMedium: TextStyle(fontSize: 16, color: subTextColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: backgroundColor,
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
