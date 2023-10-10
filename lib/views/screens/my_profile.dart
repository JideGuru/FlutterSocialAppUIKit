import 'package:flutter/material.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/extensions.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/details/detail.dart';
import 'package:social_app_ui/views/widgets/profile_card.dart';

class MyProfile extends StatelessWidget {
  final User me;
  MyProfile({
    super.key,
    required this.me,
  });
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "내 프로필",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              ProfileCard(profileMode: Owner.MINE, user: me),
              SizedBox(height: 50),
              Text(me.email, style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 50),
              Text(
                "아래에서 설문을 수정할 수 있습니다.",
                style: TextStyle(),
              ),
              SizedBox(height: screenHeight * 0.1),
              Detail(user: me, detailMode: Owner.MINE),
            ],
          ).fadeInList(1, true),
        ),
      ),
    );
  }
}
