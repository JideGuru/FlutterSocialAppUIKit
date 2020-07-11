import 'package:flutter/material.dart';
import 'package:social_app_ui/util/theme_config.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Function onTap;
  final BorderRadius borderRadius;
  final bool elevated;

  CustomCard({
    @required this.child,
    this.onTap,
    this.borderRadius,
    this.elevated = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: elevated
          ? BoxDecoration(
              borderRadius: borderRadius,
              color: Theme.of(context).cardColor,
              boxShadow: [
                ThemeConfig.cardShadow,
              ],
            )
          : BoxDecoration(
              borderRadius: borderRadius,
              color: Theme.of(context).cardColor,
            ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
