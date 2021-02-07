import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snapam/util/constants/strings.dart';
import 'package:snapam/util/theme_config.dart';
import 'package:snapam/views/pages/tabs_screen/base_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: themeData(ThemeConfig.lightTheme),
      // darkTheme: themeData(ThemeConfig.darkTheme),
      home: BasePage(),
    );
  }

  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSansProTextTheme(theme.textTheme),
    );
  }
}
