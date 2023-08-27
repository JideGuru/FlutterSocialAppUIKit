import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app_ui/util/configs/list_config.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/extensions.dart';
import 'package:social_app_ui/util/sort/map_util.dart';
import 'package:social_app_ui/util/sort/weight.dart';
import 'package:social_app_ui/util/configs/theme_config.dart';
import 'package:social_app_ui/util/user.dart';
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
        title: Text("추천 프로필", style: Theme.of(context).textTheme.bodyLarge),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: usersColRef
            .where(
              '${Constants.year}.${Constants.semester}.me.sex',
              isEqualTo: widget.me.essentials['sex'],
            )
            .where(
              '${Constants.year}.${Constants.semester}.me.dormitory',
              isEqualTo: widget.me.essentials['dormitory'],
            )
            .get(),
        builder: (context, usersSnapshot) {
          if (usersSnapshot.connectionState == ConnectionState.done) {
            var deck = getDeck(usersSnapshot, widget.me);
            var me = getUserFromCollections(usersSnapshot, widget.me.email);
            // var weights = getWeights(usersSnapshot, widget.me.tag);
            // deck = sort(me, deck, weights);
            return FutureBuilder(
              future: weightsColRef.get(),
              builder: (context, weightsSnapshot) {
                if (weightsSnapshot.connectionState == ConnectionState.done) {
                  var weights = getWeights(weightsSnapshot, me.tag);
                  deck = sort(me, deck, weights);
                  return Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: DefaultTabController(
                          initialIndex: me.tag,
                          length: tagList.length,
                          child: Column(
                            children: <Widget>[
                              ButtonsTabBar(
                                decoration: BoxDecoration(
                                    color: ThemeConfig.lightTabBackground),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                height: 48,
                                tabs: tagList
                                    .map((title) => Tab(child: Text(title)))
                                    .toList(),
                                onTap: (tag) async {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(me.email)
                                      .update({'tag': tag});
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
                        cardDeck: deck,
                        cardWidth: ThemeConfig.cardWidth * 5.5,
                        onLeftSwipe: (card) {
                          updateDomains(card.highest, card.lowest,
                              getDomains(usersSnapshot));
                        },
                        onRightSwipe: (card) {
                          updateDomains(card.highest, card.lowest,
                              getDomains(usersSnapshot));
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
      ),
    );
  }
}
