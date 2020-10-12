import 'dart:async';

import 'package:flutter/material.dart' hide Router;
import 'package:social_app_ui/components/animations/type_write.dart';
import 'package:social_app_ui/screens/auth/check_email.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/router.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  // Timer to change the screen in 1.2 seconds
  startTimeout() {
    return Timer(Duration(milliseconds: 1200), handleTimeout);
  }

  void handleTimeout() {
    changeScreen();
  }

  changeScreen() async {
    Router.pushPageWithFadeAnimation(context, CheckEmail());
  }

  @override
  void initState() {
    super.initState();
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Hero(
              tag: 'appname',
              child: Material(
                type: MaterialType.transparency,
                child: TypeWrite(
                  word: '${Constants.appName}',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                  seconds: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
