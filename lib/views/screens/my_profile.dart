import 'package:flutter/material.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/extensions.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/details/detail.dart';
import 'package:social_app_ui/views/widgets/profile_card.dart';

class MyProfile extends StatelessWidget {
  final User me, meanRoommates;
  MyProfile({
    super.key,
    required this.me,
    required this.meanRoommates,
  });
  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: 60),
              ProfileCard(me: me, other: me, meanRoommates: meanRoommates),
              SizedBox(height: 10),
              Text(me.email, style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 3),
              Text(
                "아래에서 설문을 수정할 수 있습니다.",
                style: TextStyle(),
              ),
              TextButton(
                onPressed: () {
                  Navigate.pushPage(
                    context,
                    Scaffold(
                      appBar: AppBar(
                        leading: IconButton(
                          icon: Icon(
                            Icons.keyboard_backspace,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      body: Detail(
                        user: meanRoommates,
                        userMode: 'roommates',
                      ),
                    ),
                  );
                },
                child: Text('이전 룸메이트들이 설문한 나 참고하기'),
              ),
              Detail(user: me, detailMode: Owner.MINE),
            ],
          ).fadeInList(1, true),
        ),
      ),
    );
  }
}
