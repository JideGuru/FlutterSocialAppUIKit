import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:social_app_ui/util/configs/list_config.dart';
import 'package:social_app_ui/util/sort/weight.dart';
import 'package:social_app_ui/util/configs/theme_config.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:swiping_card_deck/swiping_card_deck.dart';

class Home extends StatefulWidget {
  late final String email;
  Home({
    super.key,
    required this.email,
  });
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("추천 프로필"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var deck = getDeck(snapshot, widget.email);
            var me = getUser(snapshot, widget.email);
            var weights = getWeights(snapshot, me.tag);
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
                            color: ThemeConfig.lightTabBackground,
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          height: 48,
                          tabs: tagList
                              .map((title) => Tab(child: Text(title)))
                              .toList(),
                          onTap: (tag) async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.email)
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
                  onLeftSwipe: (p0) {
                    updateDomains(p0, getDomains(snapshot));
                  },
                  onRightSwipe: (p0) {
                    updateDomains(p0, getDomains(snapshot));
                  },
                  onDeckEmpty: () {
                    setState(() {});
                  },
                ),
              ],
            );
          } else
            return Center(
              child:
                  LoadingAnimationWidget.waveDots(color: Colors.grey, size: 50),
            );
        },
      ),
    );
  }
}
