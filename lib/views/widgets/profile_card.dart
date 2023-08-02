import 'package:flutter/material.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/widgets/inprofile_button.dart';

class ProfileCard extends StatelessWidget {
  late final User user;
  late final ProfileMode profileMode;
  ProfileCard({
    super.key,
    required this.user,
    this.profileMode = ProfileMode.OTHERS,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.red,
      ),
      width: 300,
      height: 450,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user.essentials['major'],
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                Text(
                  user.essentials['studentNumber'],
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  user.essentials['nickname'],
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  ": ${user.survey['etc']}",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              // child: Commonalities(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              // child: Difference(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Visibility(
                visible: profileMode == ProfileMode.OTHERS,
                child: Row(
                  children: [
                    InprofileButton(
                      icon: Icons.description,
                      label: '프로필',
                      onPressed: () {
                        print('프로필 클릭됨');
                      },
                    ),
                    InprofileButton(
                      icon: Icons.chat_bubble,
                      label: '새 채팅',
                      onPressed: () {
                        print('새 채팅 클릭됨');
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
