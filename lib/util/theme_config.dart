import 'package:flutter/material.dart';

class ThemeConfig {
  //Colors for theme
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Color(0xff1f1f1f);
  static Color lightAccent = Color(0xff2663ff);
  static Color darkAccent = Colors.blue;
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Color(0xff121212);
  static Color badgeColor = Colors.red;

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: appBarTheme(darkBG),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    appBarTheme: appBarTheme(lightBG),
  );

  static AppBarTheme appBarTheme(Color titleColor) {
    return AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: titleColor,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  static BoxShadow cardShadow = BoxShadow(
    color: lightAccent.withOpacity(0.1),
    blurRadius: 8.0,
    spreadRadius: 0.0,
    offset: Offset(
      0.0,
      2.0,
    ),
  );
}
