import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:social_app_ui/util/configs/configs.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/extensions.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/init_screen.dart';
import 'package:social_app_ui/views/widgets/custom_button.dart';
import 'package:social_app_ui/views/widgets/custom_text_field.dart';

class Survey extends StatefulWidget {
  final String email;
  Survey({
    super.key,
    required this.email,
  });

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  late User me = User.onlyEmail(widget.email);
  int index = -1;
  final int survey_Max_num = 17;
  List<String> keys = List.from(essentialHintTexts.keys)..addAll(surveyKeys);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    var key = 'introduction';
    if (index >= 0 && index < keys.length)
      key = keys[index];
    else if (index >= keys.length) key = 'etc';
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              consts['survey'].toString(),
              style: GoogleFonts.atkinsonHyperlegible(
                fontSize: 40.0,
              ),
            ),
            SizedBox(height: 25.0),
            Visibility(
              visible: key != 'introduction',
              child: Text(
                "(${index}/17)",
                style: GoogleFonts.inknutAntiqua(
                  textStyle: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 25.0),
            form(key).fadeInList(3, false),
            CustomButton(
              onPressed: () {
                setState(
                  () {
                    if (index < keys.length) {
                      index++;
                    } else {
                      usersColRef.doc(me.email).set(me.toFirestore());
                      chatsColRef.doc(me.email).set({});
                      Navigate.pushPageReplacement(
                        context,
                        InitScreen(email: me.email),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Column form(String key) {
    if (surveyKeys.contains(key)) {
      if (surveyMaps[key]!.length != 2) {
        String val = "";
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(surveyHintTexts[key]!),
            SizedBox(
              height: 10,
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              child: Slider(
                min: 0,
                max: surveyMaps[key]!.length.toDouble() - 1,
                value: (me.surveys[key]).toDouble(),
                divisions: surveyMaps[key]!.length - 1,
                onChanged: (value) {
                  setState(() {
                    me.surveys[key] = value.round();
                    print(value);
                    val = surveyMaps[key]?[me.surveys[key]];
                    print(val);
                  });
                },
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(surveyMaps[key]?[me.surveys[key]]),
            SizedBox(
              height: 50,
            ),
          ],
        );
      } else if (surveyMaps[key]!.length == 2) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(surveyHintTexts[key]!),
            SizedBox(
              height: 10,
            ),
            GroupButton(
              controller: GroupButtonController(selectedIndex: 0),
              onSelected: (value, index, isSelected) {
                me.surveys[key] = index;
              },
              buttons: surveyMaps[key]!,
            ),
            SizedBox(
              height: 50,
            ),
          ],
        );
      } else
        return Column();
      //   Text(consts['survey'].toString(),
      // style:GoogleFonts.atkinsonHyperlegible(
      //   fontSize: 40.0,
      // ),)
    } else {
      if (key == 'introduction') {
        return Column(
          children: [
            Text(consts['introduction'].toString()),
            SizedBox(
              height: 60,
            ),
          ],
        );
      } else if (key == 'etc') {
        me.surveys[key] = '';
        return Column(
          children: [
            Text(consts['etc'].toString()),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              onChange: (text) {
                me.surveys[key] = text;
              },
            ),
            SizedBox(
              height: 50,
            ),
          ],
        );
      } else if (key == 'nickname') {
        return Column(
          children: [
            Text(essentialHintTexts['nickname'].toString()),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              onChange: (text) {
                me.essentials[key] = text;
              },
            ),
            SizedBox(
              height: 50,
            ),
          ],
        );
      } else if (key == 'major') {
        return Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(essentialHintTexts[key]!),
            ),
            SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // 그림자 색상
                    blurRadius: 7, // 그림자 흐림 정도
                    offset: Offset(0, 9), // 그림자 위치 (x, y)
                  ),
                ],
              ),
              child: DropdownButton(
                value: me.essentials[key],
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                underline: const SizedBox(),
                items: majorList.map(
                  (String major) {
                    return DropdownMenuItem(
                      child: Text(major),
                      value: majorList.indexOf(major),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  me.essentials[key] = value;
                  setState(() {});
                },
              ),
            ),
            SizedBox(height: 20.0),
          ],
        );
      } else if (key == 'studentNumber') {
        return Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(essentialHintTexts[key]!),
            ),
            SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // 그림자 색상
                    blurRadius: 7, // 그림자 흐림 정도
                    offset: Offset(0, 9), // 그림자 위치 (x, y)
                  ),
                ],
              ),
              child: DropdownButton(
                padding: EdgeInsets.symmetric(horizontal: 11.0),
                value: me.essentials[key],
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                underline: const SizedBox(),
                items: studentNumberList.map(
                  (String num) {
                    return DropdownMenuItem(
                      child: Text(num),
                      value: studentNumberList.indexOf(num),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  me.essentials[key] = value;
                  setState(() {});
                },
              ),
            ),
            SizedBox(height: 20.0),
          ],
        );
      } else if (key == 'dormitory') {
        return Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(essentialHintTexts[key]!),
            ),
            SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // 그림자 색상
                    blurRadius: 7, // 그림자 흐림 정도
                    offset: Offset(0, 9), // 그림자 위치 (x, y)
                  ),
                ],
              ),
              child: DropdownButton(
                padding: EdgeInsets.symmetric(horizontal: 11.0),
                value: me.essentials[key],
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                underline: const SizedBox(),
                items: dormitoryList[me.essentials['sex']].map(
                  (String building) {
                    return DropdownMenuItem(
                      child: Text(building),
                      value:
                          dormitoryList[me.essentials['sex']].indexOf(building),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  me.essentials[key] = value;
                  setState(() {});
                },
              ),
            ),
            SizedBox(height: 20.0),
          ],
        );
      } else if (key == 'sex') {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(essentialHintTexts[key]!),
            SizedBox(
              height: 10,
            ),
            GroupButton(
              controller: GroupButtonController(selectedIndex: 0),
              onSelected: (value, index, isSelected) {
                me.essentials[key] = index;
              },
              buttons: essentialMaps[key]!,
            ),
            SizedBox(
              height: 50,
            ),
          ],
        );
      } else
        return Column();
    }
  }
}
