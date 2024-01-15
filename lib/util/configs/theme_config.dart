import 'package:flutter/material.dart';

class ThemeConfig {
  static Color lightPrimary = Color(0xff0f4c81);
  static Color lightOnPrimary = Color(0xff0f4c81);
  static Color lightSecondary = Color(0xff0f4c81);
  static Color lightOnSecondary = Color(0xfffcfcff);
  static Color lightError = Color(0xffbf1932);
  static Color lightOnError = Color(0xfffcfcff);
  static Color lightBackground = Color(0xfffcfcff);
  static Color lightOnBackground = Color(0xff86a2bc);
  static Color lightSurface = Color(0xff86a2bc);
  static Color lightOnSurface = Color(0xff121212);
  static Color lightText = Color(0xff121212);
  static Color lightTabBackground = Color(0xff86a2bc);
  static Color meanRoommates = Color(0xffffc107);

  // static Color darkPrimary = Color(0xff1f1f1f);
  // static Color darkSecondary = Color(0xfffcfcff);
  // static Color darkError = Color(0xffbf1932);
  // static Color darkBackground = Color(0xff121212);
  // static Color darkSurface = Color(0xfffcfcff);
  static Color darkText = Color(0xfffcfcff);

  static double cardWidth = 53.98;
  static double cardHeight = 85.60;

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: lightPrimary,
      onPrimary: lightOnPrimary,
      secondary: lightSecondary,
      onSecondary: lightOnSecondary,
      error: lightError,
      onError: lightOnError,
      background: lightBackground,
      onBackground: lightOnBackground,
      surface: lightSurface,
      onSurface: lightOnSurface,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightBackground,
      elevation: 0,
      toolbarTextStyle: TextTheme(
        titleLarge: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ).bodyMedium,
      titleTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: lightSurface,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ).titleLarge,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(),
      selectedLabelStyle: TextStyle(),
      unselectedIconTheme: IconThemeData(),
      unselectedLabelStyle: TextStyle(),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: lightText,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: lightText,
        fontSize: 30,
      ),
      headlineSmall: TextStyle(
        color: lightText,
        fontSize: 24,
      ),
      bodyLarge: TextStyle(
        color: lightText,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: lightText,
        fontSize: 18,
      ),
      bodySmall: TextStyle(
        color: lightText,
        fontSize: 14,
      ),
      labelMedium: TextStyle(
        color: lightText,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
