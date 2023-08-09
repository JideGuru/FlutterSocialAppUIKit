import 'package:flutter/material.dart';
import 'package:social_app_ui/views/screens/survey.dart';

import '../../util/user.dart';

class OtherProfileScreen extends StatelessWidget {
  late final User user;

  OtherProfileScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
            size: 28,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      backgroundColor: Colors.orange,
      body: Survey(
        email: user.email,
        isProfile: true,
        user: user,
      ),
    );
  }
}
