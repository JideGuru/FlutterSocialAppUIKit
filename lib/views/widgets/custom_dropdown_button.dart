import 'package:flutter/material.dart';
import 'package:social_app_ui/util/extensions.dart';
import 'package:social_app_ui/util/user.dart';

class CustomDropdownButton extends StatefulWidget {
  final List<String> items;
  final String surveyMode;
  final User user;
  CustomDropdownButton({
    super.key,
    required this.items,
    required this.surveyMode,
    required this.user,
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  late String value;

  @override
  void initState() {
    value = widget.user.essentials[widget.surveyMode];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      items: widget.items.map((String dorm) {
        return DropdownMenuItem<String>(
          child: Text('$dorm'),
          value: dorm,
        );
      }).toList(),
      onChanged: (dynamic value) {
        widget.user.essentials[widget.surveyMode] = value;
        this.value = value;
        setState(() {});
      },
    );
  }
}
