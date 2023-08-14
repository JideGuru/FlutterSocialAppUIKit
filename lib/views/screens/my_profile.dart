import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/extensions.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/detail.dart';
import 'package:social_app_ui/views/widgets/profile_card.dart';

class MyProfile extends StatelessWidget {
  late final String email;
  MyProfile({
    super.key,
    required this.email,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("내 프로필"),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(email).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var me = User.fromFirestore(snapshot.data!);
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 60),
                    ProfileCard(
                      profileMode: Owner.MINE,
                      email: email,
                      user: me,
                    ),
                    SizedBox(height: 10),
                    Text(email, style: Theme.of(context).textTheme.bodyLarge),
                    SizedBox(height: 3),
                    Text(
                      "아래에서 설문을 수정할 수 있습니다.",
                      style: TextStyle(),
                    ),
                    SizedBox(height: 60),
                    Detail(
                      user: me,
                      detailMode: Owner.MINE,
                    ),
                  ],
                ).fadeInList(1, true),
              ),
            );
          }
          return Center(
            child:
                LoadingAnimationWidget.waveDots(color: Colors.grey, size: 50),
          );
        },
      ),
    );
  }
}
