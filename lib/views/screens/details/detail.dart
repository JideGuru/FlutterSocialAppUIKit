import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:social_app_ui/util/configs/configs.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/widgets/custom_text_field.dart';

class Detail extends StatefulWidget {
  final User user;
  final Owner detailMode;
  const Detail({
    super.key,
    required this.detailMode,
    required this.user,
  });

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    List<String> details = List.from(essentialHintTexts.keys)
      ..addAll(surveyHintTexts.keys);
    details.add('etc');

    var meanSurveys = widget.user.calculateMeanRoommateSurveys();

    return Column(
      children: List.generate(
        details.length,
        (index) {
          var key = details[index];
          if (surveyKeys.contains(key)) {
            if (surveyMaps[key]!.length != 2) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(detailHintTexts[key]!),
                  Text(
                    "[${surveyMaps[key]?[widget.user.surveys[key]]}]",
                    style: TextStyle(fontSize: 12),
                  ),
                  Slider(
                    min: 0,
                    max: surveyMaps[key]!.length.toDouble() - 1,
                    value: (widget.user.surveys[key]).toDouble(),
                    divisions: surveyMaps[key]!.length - 1,
                    onChanged: (widget.detailMode != Owner.OTHERS &&
                            !variables['auth'])
                        ? (value) {
                            setState(() {
                              widget.user.surveys[key] = value.round();
                            });
                          }
                        : null,
                    onChangeEnd: (value) {
                      usersColRef
                          .doc(widget.user.email)
                          .update({'surveys.$key': widget.user.surveys[key]});
                      showToast(
                        consts['saved'].toString(),
                        context: context,
                        animation: StyledToastAnimation.fade,
                      );
                    },
                  ),
                  meanSurveys.length > 0
                      ? Slider(
                          min: 0,
                          max: surveyMaps[key]!.length.toDouble() - 1,
                          divisions: surveyMaps[key]!.length - 1,
                          value: meanSurveys[key]!.toDouble(),
                          onChanged: null)
                      : Container(),
                  SizedBox(
                    height: 7,
                  ),
                ],
              );
            } else if (surveyMaps[key]!.length == 2) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(detailHintTexts[key]!),
                  SizedBox(
                    height: 10,
                  ),
                  GroupButton(
                    options: GroupButtonOptions(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    controller: GroupButtonController(
                      selectedIndex: widget.user.surveys[key],
                      disabledIndexes: (widget.detailMode != Owner.OTHERS &&
                              !variables['auth'])
                          ? []
                          : [(widget.user.surveys[key] - 1) * (-1)],
                    ),
                    onSelected: (value, index, isSelected) {
                      if (widget.detailMode != Owner.OTHERS &&
                          !variables['auth']) {
                        widget.user.surveys[key] = index;
                        usersColRef
                            .doc(widget.user.email)
                            .update({'surveys.$key': widget.user.surveys[key]});
                        showToast(
                          consts['saved'].toString(),
                          context: context,
                          animation: StyledToastAnimation.fade,
                        );
                      }
                    },
                    buttons: surveyMaps[key]!,
                  ),
                  meanSurveys.length > 0
                      ? GroupButton(
                          options: GroupButtonOptions(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          buttons: surveyMaps[key]!,
                          controller: GroupButtonController(
                            selectedIndex: meanSurveys[key],
                            disabledIndexes: [0, 1],
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 50,
                  ),
                ],
              );
            } else
              return Column();
          } else if (essentialKeys.contains(key)) {
            if (key == 'dormitory') {
              return Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(detailHintTexts[key]!,
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.8),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily:
                                      GoogleFonts.catamaran().fontFamily)),
                        ),
                        // SizedBox(height: 10.0),
                        Expanded(
                          child: DropdownButton(
                            value: widget.user.essentials[key],
                            items: dormitoryList[widget.user.essentials['sex']]
                                .map(
                              (String building) {
                                return DropdownMenuItem(
                                  child: Text(building,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromRGBO(0, 0, 0, 0.8))),
                                  value: dormitoryList[
                                          widget.user.essentials['sex']]
                                      .indexOf(building),
                                );
                              },
                            ).toList(),
                            onChanged: (widget.detailMode != Owner.OTHERS &&
                                    !variables['auth'])
                                ? (value) {
                                    widget.user.essentials[key] = value;
                                    usersColRef.doc(widget.user.email).update({
                                      'dormitory': widget.user.essentials[key]
                                    });
                                    showToast(
                                      consts['saved'].toString(),
                                      context: context,
                                      animation: StyledToastAnimation.fade,
                                    );
                                    setState(() {});
                                  }
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    SizedBox(
                      height: 1.0, // 줄의 높이
                      child: Container(
                        color: Color.fromRGBO(0, 0, 0, 0.08), // 줄의 색상
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Survey",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.8),
                          fontFamily: GoogleFonts.catamaran().fontFamily,
                          fontSize: 30,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              var value = widget.user.essentials[key].toString();
              if (key != 'nickname')
                value =
                    essentialMaps[key]![widget.user.essentials[key]].toString();
              return Container(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(detailHintTexts[key]!,
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.8),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              fontFamily: GoogleFonts.catamaran().fontFamily)),
                    ),
                    Expanded(
                      child: Text(value,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(0, 0, 0, 0.8))),
                    ),
                  ],
                ),
              );
            }
          } else if (key == 'etc') {
            return Column(
              children: [
                Text(detailHintTexts['etc'].toString()),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  enabled:
                      widget.detailMode != Owner.OTHERS && !variables['auth'],
                  initialValue: widget.user.surveys[key],
                  onChange: (text) {
                    usersColRef
                        .doc(widget.user.email)
                        .update({'surveys.etc': text});
                    showToast(
                      consts['saved'].toString(),
                      context: context,
                      animation: StyledToastAnimation.fade,
                    );
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            );
          } else
            return Column();
        },
      ),
    );
  }
}
