import 'package:flutter/material.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/detail.dart';

class OtherProfile extends StatelessWidget {
  final User user;
  OtherProfile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("자세한 프로필"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Detail(user: user),
      ),
    );
  }
}
