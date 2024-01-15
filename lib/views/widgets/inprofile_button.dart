import 'package:flutter/material.dart';

class InprofileButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final Function()? onPressed;
  final Color backgroundColor;

  const InprofileButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed = null,
    this.backgroundColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 40,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 5,
        ),
        onPressed: onPressed,
        icon: icon,
        label: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
