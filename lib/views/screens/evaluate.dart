import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:social_app_ui/util/configs/configs.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/extensions.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/main_screen.dart';
import 'package:social_app_ui/views/widgets/custom_button.dart';
import 'package:social_app_ui/views/widgets/custom_text_field.dart';

class Evaluate extends StatefulWidget {
  final User me;
  const Evaluate({
    super.key,
    required this.me,
  });

  @override
  State<Evaluate> createState() => _EvaluateState();
}

class _EvaluateState extends State<Evaluate> {
  Map<String, int> evaluate = {};
  int index = -1, roomNumber = -1;
  @override
  Widget build(BuildContext context) {
    print(evaluate);
    final screenWidth = MediaQuery.of(context).size.width;
    var key = 'evaluation';
    if (index >= 0 && index < surveyKeys.length)
      key = surveyKeys[index];
    else if (index >= surveyKeys.length) key = 'roomNumber';
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            form(key).fadeInList(3, false),
            CustomButton(
              onPressed: () {
                setState(
                  () {
                    if (index < surveyKeys.length) {
                      index++;
                    } else {
                      evalsColRef.doc(roomNumber.toString()).get().then(
                        (value) {
                          if (!value.exists)
                            evalsColRef.doc(roomNumber.toString()).set({});
                          evalsColRef.doc(roomNumber.toString()).update(
                            {
                              FieldPath([widget.me.email]): evaluate,
                            },
                          );
                        },
                      );
                      usersColRef.doc(widget.me.email).update({'status': 0});
                      var me = widget.me;
                      me.essentials['status'] = 0;
                      Navigate.pushPageReplacement(
                        context,
                        MainScreen(me: me),
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
      evaluate[key] = 0;
      if (surveyMaps[key]!.length != 2) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(surveyHintTexts[key]!),
            SizedBox(
              height: 10,
            ),
            Slider(
              min: 0,
              max: surveyMaps[key]!.length.toDouble(),
              value: evaluate[key]!.toDouble(),
              onChanged: (value) {
                setState(() {
                  evaluate[key] = value.round();
                });
              },
            ),
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
                evaluate[key] = index;
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
    } else {
      if (key == 'evaluation') {
        return Column(
          children: [
            Text('evaluation hint text'),
            SizedBox(
              height: 60,
            ),
          ],
        );
      } else if (key == 'roomNumber') {
        return Column(
          children: [
            Text('roomNumber hint text'),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              onChange: (text) {
                roomNumber = int.parse(text!);
              },
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
