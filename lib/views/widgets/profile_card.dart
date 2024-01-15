import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app_ui/util/configs/configs.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/configs/theme_config.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/chat/conversation.dart';
import 'package:social_app_ui/views/screens/other_profile.dart';
import 'package:social_app_ui/views/widgets/inprofile_button.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../screens/details/detail.dart';

class ProfileCard extends StatelessWidget {
  final Owner profileMode;
  final User user;
  User me;
  final List<String> highest, lowest;
  ProfileCard({
    super.key,
    required this.profileMode,
    required this.user,
    required this.me,
    this.highest = const [],
    this.lowest = const [],
  });

  @override
  Widget build(BuildContext context) {
    var highestVisualize = visualize(highest);
    var lowestVisualize = visualize(lowest);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: user.essentials['designLevel'] == 0
              ? Color.fromRGBO(245, 245, 245, 1.0)
              : (user.essentials['designLevel'] == 1
                  ? Color.fromRGBO(249, 249, 249, 1.0)
                  : Color.fromRGBO(255, 255, 255, 1.0)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 5.0,
              spreadRadius: 0.0,
              offset: const Offset(0, 7),
            )
          ]),
      width: ThemeConfig.cardWidth * 5.5,
      height: ThemeConfig.cardHeight * 5.5,
      margin: EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      user.essentials['designLevel'] == 0
                          ? Text(
                              user.essentials['nickname'].toString(),
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              ),
                            )
                          : (user.essentials['designLevel'] == 1
                              ? GradientText(
                                  user.essentials['nickname'].toString(),
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  gradientType: GradientType.linear,
                                  colors: [
                                    Color.fromRGBO(180, 186, 236, 1.0),
                                    Color.fromRGBO(249, 227, 176, 1.0),
                                    Color.fromRGBO(255, 186, 171, 1.0),
                                  ],
                                )
                              : GradientText(
                                  user.essentials['nickname'].toString(),
                                  gradientType: GradientType.linear,
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  colors: [
                                      Color.fromRGBO(227, 85, 187, 1.0),
                                      Color.fromRGBO(14, 1, 43, 1.0),
                                      Color.fromRGBO(227, 204, 85, 1.0)
                                    ])),
                      Row(
                        children: [
                          Text(
                            "${majorList[user.essentials['major']]} / ${studentNumberList[user.essentials['studentNumber']]}   ",
                            style: TextStyle(
                              color: Color.fromRGBO(144, 144, 144, 1.0),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          user.essentials['designLevel'] == 0
                              ? SizedBox()
                              : (user.essentials['designLevel'] == 1
                                  ? Image.asset(
                                      'assets/images/sliver.png',
                                      height: 35,
                                      width: 25,
                                    )
                                  : Image.asset(
                                      'assets/images/gold.png',
                                      height: 35,
                                      width: 25,
                                    ))
                        ],
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity, // 가로로 전체 화면을 차지하도록 설정
                        height: 1.0, // 줄의 높이
                        child: Container(
                          color: Color.fromRGBO(0, 0, 0, 0.08), // 줄의 색상
                        ),
                      ),
                      SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/talk2.png',
                                width: 20,
                                height: 20,
                              ),
                              Text(
                                " ${user.surveys['etc']}",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromRGBO(0, 0, 0, 0.65),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: profileMode == Owner.MINE,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Detail",
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.8),
                                    fontFamily:
                                        GoogleFonts.catamaran().fontFamily,
                                    fontSize: 30,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "이메일",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.8),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily:
                                                        GoogleFonts.catamaran()
                                                            .fontFamily),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(me.email,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 0.8))),
                                            ),
                                          ],
                                        ),
                                        Detail(user: me, detailMode: Owner.MINE)
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 11),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                ),
                child: Visibility(
                  visible: profileMode == Owner.OTHERS,
                  child: Container(
                    height: 103,
                    width: 338,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 255, 0, 0.05),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              consts['commonality'].toString(),
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(0, 0, 0, 0.65),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 50,
                            child: DefaultTabController(
                              length: highestVisualize.length,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  ButtonsTabBar(
                                    controller: null,
                                    labelStyle: TextStyle(
                                        color: Color.fromRGBO(80, 80, 80, 1.0),
                                        fontSize: 15),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 0, 0, 0.05),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    height: 48,
                                    unselectedBackgroundColor:
                                        Color.fromRGBO(0, 0, 0, 0.05),
                                    unselectedLabelStyle: TextStyle(
                                      color: Color.fromRGBO(80, 80, 80, 1.0),
                                      fontSize: 15,
                                    ),
                                    tabs: highestVisualize
                                        .map(
                                          (title) => Tab(text: tagMaps[title]),
                                        )
                                        .toList(),
                                    onTap: (index) {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 11),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Visibility(
                  visible: profileMode == Owner.OTHERS,
                  child: Container(
                    height: 103,
                    width: 338,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 0, 0, 0.05),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              consts['difference'].toString(),
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(0, 0, 0, 0.65),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 50,
                            child: DefaultTabController(
                              length: highestVisualize.length,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  ButtonsTabBar(
                                    controller: null,
                                    labelStyle: TextStyle(
                                        color: Color.fromRGBO(80, 80, 80, 1.0),
                                        fontSize: 15),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 0, 0, 0.05),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    height: 48,
                                    unselectedBackgroundColor:
                                        Color.fromRGBO(0, 0, 0, 0.05),
                                    unselectedLabelStyle: TextStyle(
                                      color: Color.fromRGBO(80, 80, 80, 1.0),
                                      fontSize: 15,
                                    ),
                                    tabs: lowestVisualize
                                        .map(
                                          (title) => Tab(text: tagMaps[title]),
                                        )
                                        .toList(),
                                    onTap: (index) {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: profileMode == Owner.OTHERS,
                    child: Row(
                      children: [
                        InprofileButton(
                          icon: Icon(
                            Icons.contacts,
                            color: Colors.white,
                          ),
                          label: consts['profile'].toString(),
                          backgroundColor: Color.fromRGBO(22, 55, 96, 1.0),
                          onPressed: () {
                            Navigate.pushPage(
                              context,
                              OtherProfile(other: user),
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                        ),
                        InprofileButton(
                          icon: Icon(
                            Icons.chat_bubble,
                            color: Colors.white,
                          ),
                          label: consts['chat'].toString(),
                          backgroundColor: Color.fromRGBO(22, 55, 96, 1.0),
                          onPressed: () {
                            Navigate.pushPage(
                              context,
                              Conversation(
                                me: me,
                                other: user,
                                chats: [],
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<String> visualize(List<String> est) {
    List<String> list = [];
    for (var item in est) {
      var tagIndex = surveyMaps.keys.toList().indexOf(item) + 1;
      list.add(tagMaps.keys.toList()[tagIndex]);
    }
    return list;
  }
}
