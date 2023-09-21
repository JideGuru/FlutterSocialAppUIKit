import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/extensions.dart';
import 'package:social_app_ui/util/configs/list_config.dart';
import 'package:social_app_ui/util/user.dart';

class CustomGroupButton extends StatefulWidget {
  late final String hintText, surveyMode;
  late final User user;
  final bool disabled;
  CustomGroupButton({
    super.key,
    this.hintText = '',
    required this.surveyMode,
    required this.user,
    this.disabled = false,
  });

  @override
  State<CustomGroupButton> createState() => _CustomGroupButtonState();
}

class _CustomGroupButtonState extends State<CustomGroupButton> {
  @override
  Widget build(BuildContext context) {
    var surveyCheck = widget.user.survey.containsKey(widget.surveyMode);
    return Column(
      children: [
        Visibility(
          visible: widget.hintText != '',
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Text(
                  '${widget.hintText}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
        surveyCheck
            ? GroupButton(
                options: GroupButtonOptions(
                  selectedColor: widget.hintText == '' ? Colors.amber : null,
                ),
                controller: GroupButtonController(
                    disabledIndexes: widget.disabled
                        ? [toggle(widget.user.survey[widget.surveyMode])]
                        : [],
                    selectedIndex: widget.user.survey[widget.surveyMode]),
                isRadio: true,
                buttons: answerList[widget.surveyMode]!,
                onSelected: (value, index, isSelected) {
                  widget.user.survey[widget.surveyMode] = index;
                  mounted ? setState(() {}) : dispose();
                },
              )
            : SizedBox(),
      ],
    ).fadeInList(3, false);
  }
}
