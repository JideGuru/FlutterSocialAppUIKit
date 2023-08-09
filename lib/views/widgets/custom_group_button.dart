import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:social_app_ui/util/user.dart';

class CustomGroupButton extends StatefulWidget {
  late final String hintText, surveyMode;
  late final User? user;
  late final bool isOhterProfile;
  CustomGroupButton({
    super.key,
    required this.hintText,
    required this.surveyMode,
    this.user,
    required this.isOhterProfile,
  });

  @override
  State<CustomGroupButton> createState() => _CustomGroupButtonState();
}

class _CustomGroupButtonState extends State<CustomGroupButton> {
  late GroupButtonController _buttonController;
  @override
  void initState() {
    if (widget.isOhterProfile) {
      _buttonController = GroupButtonController(
        selectedIndex: widget.user?.survey[widget.surveyMode],
      );
    } else {
      _buttonController = GroupButtonController(
        selectedIndex: null,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text('${widget.hintText}'),
        ),
        SizedBox(height: 20.0),
        GroupButton(
          isRadio: true,
          buttons: answerList[widget.surveyMode]!,
          controller: _buttonController,
          onSelected: (value, index, isSelected) {
            widget.user?.survey[widget.surveyMode] = index;
            setState(() {});
          },
        ),
        SizedBox(height: 40.0),
      ],
    );
  }
}
