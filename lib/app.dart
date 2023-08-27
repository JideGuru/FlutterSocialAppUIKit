import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/configs/theme_config.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/views/screens/auth/login.dart';

class RoomieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: constsDocRef.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var consts = snapshot.data!;
          Constants.appName = consts.get('appName');
          Constants.year = consts.get('currentYear');
          Constants.semester = consts.get('currentSemester');
          Constants.auth = consts.get('auth');
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Constants.appName,
            theme: themeData(ThemeConfig.lightTheme),
            // darkTheme: themeData(ThemeConfig.darkTheme),
            home: Login(),
          );
        } else
          return Container();
      },
    );
  }

  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSansProTextTheme(
        theme.textTheme,
      ),
    );
  }
}
