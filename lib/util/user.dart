import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app_ui/util/configs/configs.dart';

class MyUser {
  late String email;
  Map<String, dynamic> essentials = {}, surveys = {}, roommateSurveys = {};

  MyUser({
    required this.email,
  });

  MyUser.onlyEmail(String onlyEmail) {
    email = onlyEmail;
    for (var key in essentialKeys) {
      essentials[key] = 0;
    }
    for (var key in surveyKeys) {
      surveys[key] = 0;
    }
  }

  MyUser.fromFirestore(DocumentSnapshot snapshot) {
    var fromFirestore = snapshot.data() as Map<String, dynamic>;
    var surveysFromFirestore = fromFirestore['surveys'] as Map<String, dynamic>;
    var roommateSurveysFromFirestore =
        fromFirestore['roommateSurveys'] as Map<String, dynamic>;
    email = snapshot.id;
    for (var key in essentialKeys) {
      essentials[key] = fromFirestore[key];
    }
    for (var key in surveysFromFirestore.keys) {
      surveys[key] = surveysFromFirestore[key];
    }
    for (var key in roommateSurveysFromFirestore.keys) {
      roommateSurveys[key] = roommateSurveysFromFirestore[key];
    }
  }

  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> toFirestore = {};

    toFirestore.addAll(essentials);
    toFirestore['surveys'] = surveys;
    toFirestore['roommateSurveys'] = roommateSurveys;

    return toFirestore;
  }

  Map<String, int> calculateMeanRoommateSurveys() {
    Map<String, int> means = {}, keyCounts = {};
    for (var year in roommateSurveys.keys) {
      for (var semester in roommateSurveys[year].keys) {
        for (var element in roommateSurveys[year][semester].keys) {
          var key = element;
          int value = roommateSurveys[year][semester][key];
          if (!means.containsKey(key)) means[key] = 0;
          means[key] = means[key]! + value;
          if (!keyCounts.containsKey(key)) keyCounts[key] = 0;
          keyCounts[key] = keyCounts[key]! + 1;
        }
      }
    }
    for (var element in means.entries) {
      var key = element.key;
      var value = element.value;
      var mean = (value.toDouble() / keyCounts[key]!.toDouble()).round();
      means[key] = mean;
    }
    return means;
  }
}
