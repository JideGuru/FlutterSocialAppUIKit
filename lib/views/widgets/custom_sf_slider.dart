import 'package:flutter/material.dart';
import 'package:social_app_ui/util/extensions.dart';
import 'package:social_app_ui/util/list_config.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class CustomSfSlider extends StatefulWidget {
  late final String hintText, surveyMode;
  late final User user;
  final disabled;
  CustomSfSlider({
    super.key,
    required this.hintText,
    required this.surveyMode,
    required this.user,
    this.disabled = false,
  });

  @override
  State<CustomSfSlider> createState() => _CustomSfSliderState();
}

class _CustomSfSliderState extends State<CustomSfSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text('${widget.hintText} ${[
            answerList[widget.surveyMode]
                ?[widget.user.survey[widget.surveyMode]]
          ]}'),
        ),
        SizedBox(height: 20.0),
        SfSlider(
          value: widget.user.survey[widget.surveyMode],
          min: 0,
          max: answerList[widget.surveyMode]!.length - 1,
          interval: 1,
          showTicks: true,
          onChanged: widget.disabled
              ? null
              : (value) {
                  widget.user.survey[widget.surveyMode] = value.round();
                  setState(() {});
                },
        ),
        SizedBox(height: 40.0),
      ],
    ).fadeInList(3, false);
  }
}
