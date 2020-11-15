import 'package:flutter/material.dart';
import 'package:snapam/views/components/animations/fade_page_route.dart';

class Navigate {
  static Future pushPage(BuildContext context, Widget page,
      {bool dialog}) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
        fullscreenDialog: dialog,
      ),
    );
  }

  static pushPageReplacement(BuildContext context, Widget page) async {
    return await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }

  static pushPageWithFadeAnimation(BuildContext context, Widget page) async {
    return await Navigator.pushReplacement(context, FadePageRoute(page));
  }
}
