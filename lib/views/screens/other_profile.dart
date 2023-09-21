import 'package:flutter/material.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/details/detail.dart';

class OtherProfile extends StatelessWidget {
  final User user, meanRoommates;
  OtherProfile({
    super.key,
    required this.user,
    required this.meanRoommates,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "자세한 프로필",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Detail(user: user, meanRoommate: meanRoommates),
      ),
    );
  }
}
