import 'package:flutter/material.dart';

class FadePageRoute<T> extends PageRoute<T> {
  FadePageRoute(this.child);

  @override
  Color get barrierColor => Colors.white10;

  @override
  String get barrierLabel => '';

  final Widget child;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);
}
