import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:social_app_ui/util/configs/list_config.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/sort/map_util.dart';

class User {
  String email;
  int tag;
  Map<String, dynamic> essentials, survey;

  User({
    required this.email,
    this.tag = 0,
    required this.essentials,
    required this.survey,
  });

  User.init(String email)
      : this.email = email,
        tag = 0,
        essentials = _essentialInitialize(),
        survey = _answerInitialize();

  static Map<String, dynamic> _essentialInitialize() {
    Map<String, dynamic> init = {};
    init['nickname'] = '';
    init['sex'] = 0;
    init['dormitory'] = '새빛관';
    init['major'] = '공과대학';
    init['studentNumber'] = '23';
    return init;
  }

  static Map<String, dynamic> _answerInitialize() {
    Map<String, dynamic> init = {};
    for (var key in answerList.keys) {
      if (key == 'etc') continue;
      init[key] = max((answerList[key]!.length / 2).round() - 1, 0);
    }
    init['etc'] = '';
    return init;
  }

  Map<String, dynamic> getScore(
      User user, Map<String, dynamic> weight, bool zeroValueExeption) {
    Map<String, double> costs = {}, costsOriginal = {};
    Map<String, dynamic> score = {};
    for (var question in questionList) {
      if (question == 'etc') break;
      var diff = ((survey[question] - user.survey[question])).abs();
      var cost = (1 - diff / (answerList[question]!.length - 1)); //normalize
      costsOriginal[question] = cost.toDouble();
      costs[question] = weight[question]! * cost;
    }

    if (zeroValueExeption) {
      var percentage = 0.0;
      costsOriginal.values.forEach((element) {
        percentage += element;
      });
      percentage /= costsOriginal.length;
      percentage *= 100;
      score['percentage'] = percentage.round();
      // score['highest'] = getMaxValueKeys(costsOriginal, costsOriginal.length);
      // score['lowest'] = getMinValueKeys(costs, length);
      // score['total'] = sumMapValues(costs);
    } else {
      score['highest'] = getMaxValueKeys(costs, 3);
      score['lowest'] = getMinValueKeys(costs, 3);
      score['total'] = sumMapValues(costs);
    }

    return score;
  }

  factory User.fromFirestore(DocumentSnapshot snapshot) {
    var fromFirestore =
        snapshot.get('${Constants.year}.${Constants.semester}.me')
            as Map<String, dynamic>;

    String email = snapshot.id;
    int tag = fromFirestore['tag'];
    Map<String, dynamic> essentials = {}, survey = {};
    for (var essential in essentialList) {
      if (fromFirestore.containsKey(essential)) {
        essentials[essential] = fromFirestore[essential];
      }
    }
    for (var question in questionList) {
      survey[question] = fromFirestore[question];
    }

    return User(
      email: email,
      tag: tag,
      essentials: essentials,
      survey: survey,
    );
  }

  factory User.fromFirestoreRoommates(DocumentSnapshot snapshot) {
    var fromFirestore = snapshot.data() as Map<String, dynamic>;

    String email = snapshot.id;
    Map<String, dynamic> essentials = {}, survey = {};
    int cnt = 0;
    for (var y in fromFirestore.keys) {
      var year = fromFirestore[y];
      for (var s in year.keys) {
        var sem = year[s] as Map<String, dynamic>;
        if (sem.containsKey('other')) {
          var roommate = sem['other'];
          for (var question in questionList) {
            if (question == 'etc') continue;
            if (!survey.containsKey(question)) {
              survey[question] = 0;
            }
            survey[question] += roommate[question];
          }
          cnt++;
        }
      }
    }
    if (cnt > 0) {
      for (var question in questionList) {
        if (survey.containsKey(question)) {
          survey[question] /= cnt;
          survey[question] = (survey[question] as double).round();
        }
      }
    }

    return User(
      email: email,
      tag: 0,
      essentials: essentials,
      survey: survey,
    );
  }

  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> toFirestore = {};
    toFirestore['tag'] = tag;
    toFirestore.addAll(essentials);
    toFirestore.addAll(survey);

    return toFirestore;
  }
}

User getUserFromCollections(
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot, String email) {
  User user = User.init(
    email,
  );
  if (snapshot.hasData) {
    for (var doc in snapshot.data!.docs) {
      if (doc.id != email) continue;
      if (doc.id == 'weights') continue;
      user = User.fromFirestore(doc);
    }
  }
  return user;
}
