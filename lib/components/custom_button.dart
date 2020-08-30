import 'package:flutter/material.dart';
import 'package:social_app_ui/util/config.dart';
import 'package:social_app_ui/util/theme_config.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final Color color;

  CustomButton({
    this.label = 'Continue',
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: Config.isSmallScreen(context) ? 283.0 : 318.0,
      child: Column(
        children: [
          InkWell(
            onTap: onPressed,
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                color: color ?? Theme.of(context).accentColor,
                boxShadow: [
                  ThemeConfig.cardShadow,
                ],
              ),
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "$label",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
