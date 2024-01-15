import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app_ui/util/configs/configs.dart';

class Constants {
  static initConstants(QuerySnapshot snapshot, int language) {
    var strLanguage = language == 0 ? 'korean' : 'english';
    Map<String, dynamic> constsFromFirestore = {};
    for (var doc in snapshot.docs) {
      constsFromFirestore[doc.id] = doc.data();
    }

    for (var entry in constsFromFirestore['constants'].entries) {
      if (entry.key == 'app-name') {
        appName = entry.value;
      } else {
        consts[entry.key] = entry.value[language];
      }
    }
    for (var key in variables.keys) {
      variables[key] = constsFromFirestore['variables'][key];
    }
    for (var key in essentialHintTexts.keys) {
      essentialHintTexts[key] = constsFromFirestore['essentials']
          ['essentialHintTexts'][key][language];
    }
    for (var key in essentialMaps.keys) {
      if (key == 'studentNumber') continue;
      essentialMaps[key] =
          constsFromFirestore['essentials']['essentialMaps'][key][strLanguage];
    }
    for (var key in surveyHintTexts.keys) {
      surveyHintTexts[key] =
          constsFromFirestore['surveys']['surveyHintTexts'][key][language];
    }
    for (var key in surveyMaps.keys) {
      surveyMaps[key] =
          constsFromFirestore['surveys']['surveyMaps'][key][strLanguage];
    }
    for (var key in detailHintTexts.keys) {
      detailHintTexts[key] = constsFromFirestore['details'][key][language];
    }

    var dormList =
        constsFromFirestore['essentials']['dormitoryList'][strLanguage];
    List<String> maleDorm = [], femaleDorm = [];
    for (var element in dormList['male']) {
      maleDorm.add(element.toString());
    }
    for (var element in dormList['female']) {
      femaleDorm.add(element.toString());
    }
    dormitoryList[0] = maleDorm;
    dormitoryList[1] = femaleDorm;
    List<String> maj = [];
    for (var element in constsFromFirestore['essentials']['essentialMaps']
        ['major'][strLanguage]) {
      maj.add(element.toString());
    }
    majorList = maj;
    studentNumberList = List.generate(
        10,
        (index) =>
            ((int.parse(variables['current-year']) - 2000) - index).toString());
    essentialMaps['studentNumber'] = studentNumberList;
  }

  // static late String appName = 'Roomie';
  // static late String year = '2023';
  // static late String semester = '2';
  // static late bool auth = false;
  // static Map<String, dynamic> consts = {
  //   'consts': {},
  //   'variables': {},
  //   'surveys': {},
  //   'essentials': {},
  // };
}
