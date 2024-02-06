import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app_ui/util/configs/configs.dart';
import 'package:social_app_ui/util/user.dart';

class ContentsFilter {
  List<MyUser> orderedUsers = [];
  List<Map<String, dynamic>> orderedScores = [];

  void filt(
      MyUser me, DocumentSnapshot domainSnapshot, QuerySnapshot usersSnapshot) {
    var domains = getWeightDomains(domainSnapshot);
    var weights = getWeights(domains);
    var ordered = getOrderedUsers(me, usersSnapshot, weights);
    orderedUsers = ordered[0];
    orderedScores = ordered[1];
  }

  Map<String, double> getWeightDomains(DocumentSnapshot documentSnapshot) {
    Map<String, double> domains = {};
    var domainsFromFirestore = documentSnapshot.data() as Map<String, dynamic>;
    for (var domain in domainsFromFirestore.entries) {
      var type = domain.value.runtimeType;
      if (type == int)
        domains[domain.key] = (domain.value as int).toDouble();
      else
        domains[domain.key] = domain.value as double;
    }
    return domains;
  }

  double getSigmoid(double x) {
    var y = 1 / (1 + exp(-x));
    return y;
  }

  Map<String, double> getWeights(Map<String, double> domains) {
    Map<String, double> weights = {};

    for (var entry in domains.entries) {
      var key = entry.key;
      var domain = entry.value;
      weights[key] = getSigmoid(domain);
    }

    return weights;
  }

  double normalize(double value, int length) {
    return value / length;
  }

  List<String> getMaxValKeys(Map<String, double> map, int length) {
    List<String> keys = [];
    if (map.isEmpty || map.length < length) return keys;
    var sortedEntries = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    keys = sortedEntries.sublist(0, length).map((entry) => entry.key).toList();
    return keys;
  }

  List<String> getMinValKeys(Map<String, double> map, int length) {
    List<String> keys = [];
    if (map.isEmpty || map.length < length) return keys;
    var sortedEntries = map.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    keys = sortedEntries.sublist(0, length).map((entry) => entry.key).toList();
    return keys;
  }

  Map<String, dynamic> getScore(
      MyUser u1, MyUser u2, Map<String, double> weights, int tag) {
    var s1 = u1.surveys;
    var s2 = u2.surveys;
    tag -= 1;

    Map<String, double> scores = {};
    for (var entry in surveyMaps.entries) {
      var key = entry.key;
      var val = entry.value;
      var normDist =
          normalize(((s1[key] - s2[key]).abs()).toDouble(), val.length);
      var score = weights[key]! * normDist;
      if (tag == surveyKeys.indexOf(key)) score *= 2;
      scores[key] = score;
    }

    Map<String, dynamic> score = {};
    score['total'] = 0.0;
    score['highest'] = getMaxValKeys(scores, 3);
    score['lowest'] = getMinValKeys(scores, 3);
    for (var val in scores.values) {
      score['total'] += val;
    }

    return score;
  }

  List<dynamic> getOrderedUsers(
      MyUser me, QuerySnapshot snapshot, Map<String, double> weights) {
    Map<String, double> usersOnlyTotalScore = {};
    Map<String, dynamic> usersWithScore = {};
    for (var doc in snapshot.docs) {
      if (doc.id == me.email) continue;
      var other = MyUser.fromFirestore(doc);
      var score = getScore(me, other, weights, me.essentials['tag']);
      usersOnlyTotalScore[other.email] = score['total'];
      usersWithScore[other.email] = [other, score];
    }
    var orderedEmails =
        getMaxValKeys(usersOnlyTotalScore, usersOnlyTotalScore.length);
    List<MyUser> orderedUsers = [];
    List<Map<String, dynamic>> orderedScores = [];
    for (var email in orderedEmails) {
      var other = usersWithScore[email];
      orderedUsers.add(other[0]);
      orderedScores.add(other[1]);
    }

    return [orderedUsers, orderedScores];
  }
}
