import 'package:flutter/material.dart';

class ThemeConfig {
  //Colors for theme
  static Color lightAccent = Colors.blue;
  static Color darkAccent = Colors.lightBlue;
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Color(0xff121212);
  static Color badgeColor = Colors.red;

  static Color lightPrimary = Color(0xff0f4c81);
  static Color lightSecondary = Color(0xff0f4c81);
  static Color lightError = Color(0xffbf1932);
  static Color lightBackground = Color(0xfffcfcff);
  static Color lightSurface = Color(0xff121212);

  static Color darkPrimary = Color(0xff1f1f1f);
  static Color darkSecondary = Color(0xfffcfcff);
  static Color darkError = Color(0xfffcfcff);
  static Color darkBackground = Color(0xfffcfcff);
  static Color darkSurface = Color(0xfffcfcff);

  static double cardWidth = 53.98;
  static double cardHeight = 85.60;

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: lightPrimary,
      onPrimary: lightPrimary,
      secondary: lightSecondary,
      onSecondary: lightSecondary,
      error: lightError,
      onError: lightError,
      background: lightBackground,
      onBackground: lightBackground,
      surface: lightSurface,
      onSurface: lightSurface,
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
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontSize: 30,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
      ),
      bodyLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
      ),
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
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(150.0, 60.0),
        ),
        side: MaterialStateProperty.resolveWith(
          (Set<MaterialState> state) {
            if (state.contains(MaterialState.disabled)) {
              return BorderSide(
                color: Colors.grey,
              );
            }
            return BorderSide(
              color: Colors.cyan,
            );
          },
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        textStyle: MaterialStateProperty.resolveWith(
          (Set<MaterialState> state) {
            if (state.contains(MaterialState.disabled)) {
              return TextStyle(
                color: Colors.grey,
              );
            }
            return TextStyle(
              color: Colors.cyan,
            );
          },
        ),
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: darkAccent,
      background: darkBG,
      brightness: Brightness.dark,
    ),
  );
}
