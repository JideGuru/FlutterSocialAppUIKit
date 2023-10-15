import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:group_button/group_button.dart';
import 'package:social_app_ui/util/configs/configs.dart';
import 'package:social_app_ui/util/const.dart';
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      child: Column(
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
                    Text(surveyHintTexts[key]!),
                    SizedBox(
                      height: 10,
                    ),
                    Slider(
                      min: 0,
                      max: surveyMaps[key]!.length.toDouble(),
                      value: (widget.user.surveys[key]).toDouble(),
                      onChanged:
                          (widget.detailMode == Owner.OTHERS || Constants.auth)
                              ? null
                              : (value) {
                                  setState(() {
                                    widget.user.surveys[key] = value.round();
                                  });
                                },
                      onChangeEnd: (value) {
                        usersColRef
                            .doc(widget.user.email)
                            .update({'surveys.$key': widget.user.surveys[key]});
                        showToast(
                          '저장되었습니다.',
                          context: context,
                          animation: StyledToastAnimation.fade,
                        );
                      },
                    ),
                    meanSurveys.length > 0
                        ? Slider(
                            value: meanSurveys[key]!.toDouble(),
                            onChanged: null)
                        : Container(),
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
                      controller: GroupButtonController(
                        selectedIndex: widget.user.surveys[key],
                        disabledIndexes: (widget.detailMode == Owner.OTHERS ||
                                Constants.auth)
                            ? [0, 1]
                            : [],
                      ),
                      onSelected: (value, index, isSelected) {
                        widget.user.surveys[key] = index;
                        usersColRef
                            .doc(widget.user.email)
                            .update({'surveys.$key': widget.user.surveys[key]});
                        showToast(
                          '저장되었습니다.',
                          context: context,
                          animation: StyledToastAnimation.fade,
                        );
                      },
                      buttons: surveyMaps[key]!,
                    ),
                    meanSurveys.length > 0
                        ? GroupButton(
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
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(essentialHintTexts[key]!),
                    ),
                    SizedBox(height: 10.0),
                    DropdownButton(
                      value: widget.user.essentials[key],
                      items: dormitoryList[widget.user.essentials['sex']].map(
                        (String building) {
                          return DropdownMenuItem(
                            child: Text(building),
                            value: dormitoryList[widget.user.essentials['sex']]
                                .indexOf(building),
                          );
                        },
                      ).toList(),
                      onChanged: (widget.detailMode == Owner.OTHERS ||
                              Constants.auth)
                          ? null
                          : (value) {
                              widget.user.essentials[key] = value;
                              usersColRef.doc(widget.user.email).update(
                                  {'dormitory': widget.user.essentials[key]});
                              showToast(
                                '저장되었습니다.',
                                context: context,
                                animation: StyledToastAnimation.fade,
                              );
                              setState(() {});
                            },
                    ),
                    SizedBox(height: 20.0),
                  ],
                );
              } else {
                var value = widget.user.essentials[key].toString();
                if (key != 'nickname')
                  value = essentialMaps[key]![widget.user.essentials[key]]
                      .toString();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(essentialHintTexts[key]!),
                    SizedBox(
                      height: 10,
                    ),
                    Text(value),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                );
              }
            } else if (key == 'etc') {
              return Column(
                children: [
                  Text('etc hint text'),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    enabled:
                        widget.detailMode != Owner.OTHERS && !Constants.auth,
                    initialValue: widget.user.surveys[key],
                    onChange: (text) {
                      usersColRef
                          .doc(widget.user.email)
                          .update({'surveys.etc': text});
                      showToast(
                        '저장되었습니다.',
                        context: context,
                        animation: StyledToastAnimation.fade,
                      );
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
      ),
    );
  }
}
