import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:social_app_ui/util/sort/map_util.dart';
import 'package:social_app_ui/views/widgets/profile_card.dart';

List<String> dormitoryList = [
  '참빛관',
  '대동관',
  '평화관',
  '새빛관',
  '한빛관',
  '창의관',
  '혜민관',
  '웅비관(특성화캠퍼스)',
  '청운관(특성화캠퍼스)',
];

List<String> studentNumberList =
    List.generate(10, (index) => (23 - index).toString());

List<String> essentialList = [
  'nickname',
  'sex',
  'dormitory',
  'studentNumber',
  'major',
];

List<String> questionList = [
  'smoking',
  'sleepingHabits',
  'relationship',
  'sleepAt',
  'roomCleaning',
  'restroomCleaning',
  'inviting',
  'sharing',
  'calling',
  'earphone',
  'eating',
  'lateStand',
  'etc',
];

List<String> tagList = [
  '전체',
  '흡연',
  '잠버릇',
  '관계',
  '취침시간',
  '방 청소',
  '화장실 청소',
  '초대',
  '공유',
  '전화',
  '이어폰',
  '취식',
  '스탠드',
];

Map<String, List<String>> answerList = {
  'smoking': [
    '비흡연',
    '흡연',
  ],
  'sleepingHabits': [
    '없음',
    '가끔 있음',
    '자주 있음',
    '항상 있음',
    '잘 모르겠음',
  ],
  'relationship': [
    '비즈니스 사이',
    '식사 하는 사이',
    '친한 친구 사이',
  ],
  'sleepAt': [
    "오후 10시 이전",
    "오후 10시 ~ 오후 11시",
    "오후 11시 ~ 오전 0시",
    "오전 0시 ~ 오전 1시",
    "오전 1시 ~ 오전 2시",
    "오전 2시 ~ 오전 3시",
    "오전 3시 이후",
    "매우 불규칙적인 시간",
  ],
  'roomCleaning': [
    "한달에 한 번 미만",
    "한달에 한 번",
    "격주일에 한 번",
    "일주일에 한 번",
    "일주일에 한 번 이상",
  ],
  'restroomCleaning': [
    "한달에 한 번 미만",
    "한달에 한 번",
    "격주일에 한 번",
    "일주일에 한 번",
    "일주일에 한 번 이상",
  ],
  'inviting': [
    '선호',
    '비선호',
  ],
  'sharing': [
    '선호',
    '비선호',
  ],
  'calling': [
    '선호',
    '비선호',
  ],
  'earphone': [
    '선호',
    '비선호',
  ],
  'eating': [
    '선호',
    '비선호',
  ],
  'lateStand': [
    '선호',
    '비선호',
  ],
};

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
        essentials = essentialInitialize(),
        survey = answerInitialize();

  static Map<String, dynamic> essentialInitialize() {
    Map<String, dynamic> init = {};
    init['nickname'] = '';
    init['sex'] = 0;
    init['dormitory'] = '새빛관';
    init['major'] = '공과대학';
    init['studentNumber'] = '2019';
    return init;
  }

  static Map<String, dynamic> answerInitialize() {
    Map<String, dynamic> init = {};
    for (var key in answerList.keys) {
      if (key == 'etc') continue;
      init[key] = max((answerList[key]!.length / 2).round() - 1, 0);
    }
    init['etc'] = '';
    return init;
  }
  // void essentialInitialize() {
  //   for (var key in essentialList) {
  //     essentials[key] = key;
  //   }
  // }

  // void answerInitialize() {
  //   for (var key in answerList.keys) {
  //     survey[key] = max((answerList[key]!.length / 2).round() - 1, 0);
  //   }
  //   survey['etc'] = '';
  // }

  Map<String, dynamic> getScore(User user, Map<String, dynamic> weight) {
    Map<String, double> costs = {};
    Map<String, dynamic> score = {};
    for (var question in questionList) {
      if (question == 'etc') break;
      var diff = ((survey[question] - user.survey[question]) as double).abs();
      diff = (1 - diff / (answerList[question]!.length - 1)); //normalize
      costs[question] = weight[question]! * diff;
    }
    score['highest'] = getMaxValueKeys(costs, 3);
    score['lowest'] = getMinValueKeys(costs, 3);
    score['total'] = sumMapValues(costs);
    return score;
  }

  factory User.fromFirestore(DocumentSnapshot snapshot) {
    var fromFirestore = snapshot.data() as Map<String, dynamic>;

    String email = snapshot.id;
    int tag = fromFirestore['tag'];

    Map<String, dynamic> essentials = {}, survey = {};
    for (var essential in essentialList) {
      essentials[essential] = fromFirestore[essential];
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

  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> toFirestore = {};
    toFirestore['tag'] = tag;
    toFirestore.addAll(essentials);
    toFirestore.addAll(survey);

    return toFirestore;
  }
}

List<ProfileCard> getDeck(
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot, String exeptionEmail) {
  List<ProfileCard> deck = [];
  for (var doc in snapshot.data!.docs) {
    if (doc.id == exeptionEmail) continue;
    if (doc.id == 'weights') continue;
    deck.add(ProfileCard(user: User.fromFirestore(doc)));
  }
  return deck;
}

User getUser(AsyncSnapshot<QuerySnapshot<Object?>> snapshot, String email) {
  User user = User(email: email, essentials: {}, survey: {});
  for (var doc in snapshot.data!.docs) {
    if (doc.id != email) continue;
    if (doc.id == 'weights') continue;
    user = User.fromFirestore(doc);
  }
  return user;
}
