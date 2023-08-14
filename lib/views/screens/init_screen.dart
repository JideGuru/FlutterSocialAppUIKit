import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/main_screen.dart';

class InitScreen extends StatelessWidget {
  final String email;
  const InitScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: usersColRef.doc(email).get(),
        builder: (context, snapshot) {
          User me = User.fromFirestore(snapshot.data!);
          if (snapshot.connectionState == ConnectionState.done) {
            return MainScreen(
              user: me,
            );
          } else
            return Center(
              child: LoadingAnimationWidget.waveDots(
                color: Colors.grey,
                size: 50,
              ),
            );
        },
      ),
    );
  }
}
