import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app_ui/util/configs/configs.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/configs/theme_config.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/views/screens/auth/login.dart';

class RoomieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // constsColRef.doc('constants').set(firebaseConsts);
    // constsColRef.doc('essentials').set(firebaseEssentialConsts);
    // constsColRef.doc('surveys').set(firebaseSurveyConsts);
    // constsColRef.doc('variables').set(firebaseVariables);
    return FutureBuilder(
      future: constsColRef.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Constants.initConstants(snapshot.data!, 1);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: appName,
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
