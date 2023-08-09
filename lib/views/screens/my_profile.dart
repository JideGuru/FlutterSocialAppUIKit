import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/widgets/profile_card.dart';

class MyProfile extends StatefulWidget {
  late final String email;
  MyProfile({
    super.key,
    required this.email,
  });
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  static Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.email)
            .get(),
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
                      owner: Owner.MINE,
                      user: me,
                    ),
                    SizedBox(height: 10),
                    Text(
                      me.email,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "아래에서 설문을 수정할 수 있습니다.",
                      style: TextStyle(),
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildCategory("Posts"),
                          _buildCategory("Friends"),
                          _buildCategory("Groups"),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      primary: false,
                      padding: EdgeInsets.all(5),
                      itemCount: 15,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 200 / 200,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Image.asset(
                            "assets/images/cm${random.nextInt(10)}.jpeg",
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ],
                ),
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

  Widget _buildCategory(String title) {
    return Column(
      children: <Widget>[
        Text(
          random.nextInt(10000).toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(),
        ),
      ],
    );
  }
}
