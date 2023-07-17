import 'package:flutter/material.dart';

class ThemeConfig {
  //Colors for theme
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Color(0xff1f1f1f);
  static Color lightAccent = Colors.blue;
  static Color darkAccent = Colors.lightBlue;
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Color(0xff121212);
  static Color badgeColor = Colors.red;

  static ThemeData lightTheme = ThemeData(
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      backgroundColor: lightBG,
      elevation: 0,
      toolbarTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ).bodyMedium,
      titleTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ).titleLarge,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: lightAccent,
      background: lightBG,
      brightness: Brightness.light,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBG,
    appBarTheme: AppBarTheme(
      backgroundColor: darkBG,
      elevation: 0,
      toolbarTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ).bodyMedium,
      titleTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ).titleLarge,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: darkAccent,
      background: darkBG,
      brightness: Brightness.dark,
    ),
  );
}
