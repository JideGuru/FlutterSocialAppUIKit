import 'package:flutter/material.dart';

class Config {
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 400;
  }
}
