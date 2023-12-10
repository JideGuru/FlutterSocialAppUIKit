import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app_ui/util/configs/configs.dart';

class User {
  late String email;
  Map<String, dynamic> essentials = {}, surveys = {}, roommateSurveys = {};

  User({
    required this.email,
  });

  User.onlyEmail(String onlyEmail) {
    email = onlyEmail;
    for (var key in essentialKeys) {
      essentials[key] = 0;
    }
    for (var key in surveyKeys) {
      surveys[key] = 0;
    }
  }

  User.fromFirestore(DocumentSnapshot snapshot) {
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
    for (var year in roommateSurveys.entries) {
      for (var semester in (year as Map<String, dynamic>).values) {
        for (var element in (semester as Map<String, int>).entries) {
          if (!means.containsKey(element.key)) means[element.key] = 0;
          means[element.key] = means[element.key]! + element.value;
          if (!keyCounts.containsKey(element.key)) keyCounts[element.key] = 0;
          keyCounts[element.key] = keyCounts[element.key]! + 1;
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
