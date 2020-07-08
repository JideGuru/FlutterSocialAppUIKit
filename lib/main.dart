import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:social_app_ui/screens/splash/splash.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/theme_config.dart';
import 'package:social_app_ui/view_models/auth/check_email_view_model.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CheckEmailViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constants.appName,
        theme: themeData(ThemeConfig.lightTheme),
        darkTheme: themeData(ThemeConfig.darkTheme),
        home: Splash(),
      ),
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
