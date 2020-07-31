import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:social_app_ui/components/life_cycle_event_handler.dart';
import 'package:social_app_ui/services/user_service.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/theme_config.dart';
import 'package:social_app_ui/view_models/auth/check_email_view_model.dart';
import 'package:social_app_ui/view_models/auth/login_view_model.dart';
import 'package:social_app_ui/view_models/auth/register_view_model.dart';
import 'package:social_app_ui/view_models/chats/conversation_view_model.dart';
import 'package:social_app_ui/view_models/chats/new_chat_view_model.dart';
import 'package:social_app_ui/view_models/user/user_view_model.dart';
import 'package:social_app_ui/views/auth/check_email/check_email.dart';
import 'package:social_app_ui/views/main_page/main_screen.dart';
import 'package:social_app_ui/views/splash/splash.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
      detachedCallBack: () => UserService().setUserStatus(false),
      resumeCallBack: () => UserService().setUserStatus(true),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CheckEmailViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => NewChatViewModel()),
        ChangeNotifierProvider(create: (_) => ConversationViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constants.appName,
        theme: themeData(ThemeConfig.lightTheme),
        darkTheme: themeData(ThemeConfig.darkTheme),
        home: buildHome(),
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

  buildHome() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {
          print(snapshot);
          return MainScreen();
        } else {
          return Splash();
        }
      },
    );
  }
}
