import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:social_app_ui/views/main_page/desktop/main_screen_desktop.dart';
import 'package:social_app_ui/views/main_page/mobile/main_screen_mobile.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenTypeLayout(
        desktop: MainScreenDesktop(),
        mobile: MainScreenMobile(),
      ),
    );
  }
}
