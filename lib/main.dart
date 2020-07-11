import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:social_app_ui/view_models/chats/new_chat_view_model.dart';
import 'package:social_app_ui/views/splash/splash.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/theme_config.dart';
import 'package:social_app_ui/view_models/auth/check_email_view_model.dart';
import 'package:social_app_ui/view_models/auth/login_view_model.dart';
import 'package:social_app_ui/view_models/auth/register_view_model.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CheckEmailViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => NewChatViewModel()),
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
