import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/widgets/profile_card.dart';
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
                          labelStyle: TextStyle(
                            fontSize: 18,
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          height: 48,
                          tabs: tagList
                              .map((title) => Tab(child: Text(title)))
                              .toList(),
                          onTap: (tag) {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.email)
                                .update({'tag': tag});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SwipingDeck(
                  cardDeck: deck,
                  cardWidth: 300,
                  onLeftSwipe: (p0) {},
                  onRightSwipe: (p0) {},
                  onDeckEmpty: () {
                    print('deck is empty');
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

List<ProfileCard> getDeck(
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot, String exeptionEmail) {
  List<ProfileCard> deck = [];
  for (var doc in snapshot.data!.docs) {
    if (doc.id == exeptionEmail) continue;
    deck.add(ProfileCard(user: User.fromFirestore(doc)));
  }
  return deck;
}

User getUser(AsyncSnapshot<QuerySnapshot<Object?>> snapshot, String email) {
  User user = User(email: email, essentials: {}, survey: {});
  for (var doc in snapshot.data!.docs) {
    if (doc.id == email) user = User.fromFirestore(doc);
  }
  return user;
}
