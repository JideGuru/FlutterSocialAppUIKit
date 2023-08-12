import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:social_app_ui/util/list_config.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/widgets/profile_card.dart';

class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  Pair(this.first, this.second);
}

double getWeight(double domain) {
  return 1 / (1 + exp(-domain));
}

List<ProfileCard> sort(
    User user, List<ProfileCard> deck, Map<String, dynamic> weight) {
  List<Pair<double, ProfileCard>> weightedDeck = [];

  for (var card in deck) {
    var score = user.getScore(card.user, weight);
    var weightedCard = ProfileCard(
      user: card.user,
      highest: score['highest'],
      lowest: score['lowest'],
    );
    weightedDeck.add(Pair(score['total'], weightedCard));
  }
  weightedDeck.sort((a, b) => b.first.compareTo(a.first));

  List<ProfileCard> sortedDeck = [];
  for (var profile in weightedDeck) {
    sortedDeck.add(profile.second);
  }
  return sortedDeck;
}

Map<String, double> getInitialWeight() {
  Map<String, double> domains = {};
  for (var key in questionList) {
    if (key == 'etc') break;
    domains[key] = 0;
  }
  return domains;
}

Map<String, dynamic> getWeights(
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int tag) {
  Map<String, dynamic> domains = getDomains(snapshot), weights = {};
  for (var key in domains.keys) {
    if (tag == 0 || key != questionList[tag - 1])
      weights[key] = getWeight(domains[key]!);
    else
      weights[key] = getWeight(domains[key]! * 2);
  }
  return weights;
}

Map<String, dynamic> getDomains(
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
  Map<String, dynamic> domains = {};
  for (var doc in snapshot.data!.docs) {
    if (doc.id != 'weights') continue;
    domains = doc.data() as Map<String, dynamic>;
  }
  return domains;
}

void updateDomains(ProfileCard card, Map<String, dynamic> domains) {
  List<String> highest = card.highest, lowest = card.lowest;
  for (var h in highest)
    FirebaseFirestore.instance
        .collection('users')
        .doc('weights')
        .update({h: FieldValue.increment(-0.1)});
  for (var l in lowest)
    FirebaseFirestore.instance
        .collection('users')
        .doc('weights')
        .update({l: FieldValue.increment(0.1)});
}
