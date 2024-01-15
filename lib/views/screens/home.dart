import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app_ui/util/configs/configs.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/extensions.dart';
import 'package:social_app_ui/util/configs/theme_config.dart';
import 'package:social_app_ui/util/sort/filter.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/widgets/profile_card.dart';
import 'package:swiping_card_deck/swiping_card_deck.dart';

class Home extends StatefulWidget {
  final User me;
  Home({
    super.key,
    required this.me,
  });
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(consts['recommended-profiles'].toString(),
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.24,
                color: Color.fromRGBO(0, 0, 0, 1.0))),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: usersColRef.doc(widget.me.email).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              User me = User.fromFirestore(snapshot.data!);
              return FutureBuilder(
                future: usersColRef
                    .where(
                      'sex',
                      isEqualTo: me.essentials['sex'],
                    )
                    .where(
                      'dormitory',
                      isEqualTo: me.essentials['dormitory'],
                    )
                    .get(),
                builder: (context, usersSnapshot) {
                  if (usersSnapshot.connectionState == ConnectionState.done) {
                    return FutureBuilder(
                      future: weightsColRef.doc('weights').get(),
                      builder: (context, weightsSnapshot) {
                        for (var doc in usersSnapshot.data!.docs) {
                          if (doc.id == widget.me.email)
                            me = User.fromFirestore(doc);
                        }
                        if (weightsSnapshot.connectionState ==
                            ConnectionState.done) {
                          var filter = ContentsFilter();
                          filter.filt(
                              me, weightsSnapshot.data!, usersSnapshot.data!);
                          var orderedUsers = filter.orderedUsers;
                          var orderedScores = filter.orderedScores;
                          List<ProfileCard> orderedProfiles = [];
                          for (var user in orderedUsers) {
                            var idx = orderedUsers.indexOf(user);
                            ProfileCard profile = ProfileCard(
                              profileMode: Owner.OTHERS,
                              user: user,
                              me: me,
                              highest: orderedScores[idx]['highest'],
                              lowest: orderedScores[idx]['lowest'],
                            );
                            orderedProfiles.add(profile);
                          }
                          return Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 50,
                                child: DefaultTabController(
                                  initialIndex: me.essentials['tag'],
                                  length: tagMaps.length,
                                  child: Column(
                                    children: <Widget>[
                                      ButtonsTabBar(
                                        labelStyle: TextStyle(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 1.0),
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(22, 55, 96, 1.0),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        height: 48,
                                        unselectedBackgroundColor:
                                            Color.fromRGBO(227, 227, 227, 1.0),
                                        unselectedLabelStyle: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1.0),
                                        ),
                                        tabs: tagMaps.values
                                            .map(
                                              (title) => Tab(text: title),
                                            )
                                            .toList(),
                                        onTap: (tag) async {
                                          await usersColRef
                                              .doc(me.email)
                                              .update(
                                            {'tag': tag},
                                          );
                                          mounted ? setState(() {}) : dispose();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 15,
                              ),
                              SwipingDeck(
                                cardDeck: orderedProfiles,
                                cardWidth: ThemeConfig.cardWidth * 5.5,
                                onLeftSwipe: (card) {
                                  for (var element in card.highest) {
                                    weightsColRef.doc('weights').update(
                                      {element: FieldValue.increment(-1)},
                                    );
                                  }
                                  for (var element in card.lowest) {
                                    weightsColRef.doc('weights').update(
                                      {element: FieldValue.increment(1)},
                                    );
                                  }
                                },
                                onRightSwipe: (card) {
                                  for (var element in card.highest) {
                                    weightsColRef.doc('weights').update(
                                      {element: FieldValue.increment(-1)},
                                    );
                                  }
                                  for (var element in card.lowest) {
                                    weightsColRef.doc('weights').update(
                                      {element: FieldValue.increment(1)},
                                    );
                                  }
                                },
                                onDeckEmpty: () {
                                  mounted ? setState(() {}) : dispose();
                                },
                              ).fadeInList(1, false),
                            ],
                          );
                        } else
                          return Container();
                      },
                    );
                  } else
                    return Container();
                },
              );
            } else
              return Container();
          }),
    );
  }
}
