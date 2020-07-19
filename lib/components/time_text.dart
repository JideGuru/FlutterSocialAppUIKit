import 'dart:async';

import 'package:flutter/material.dart';

/// This widget is made to make the time update every seconds
class TimeText extends StatefulWidget {
  final Widget child;

  TimeText({this.child});

  @override
  _TimeTextState createState() => _TimeTextState();
}

class _TimeTextState extends State<TimeText> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if(mounted){
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
