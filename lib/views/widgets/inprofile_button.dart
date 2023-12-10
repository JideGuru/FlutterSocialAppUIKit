import 'package:flutter/material.dart';

class InprofileButton extends StatelessWidget {
  final IconData icon;
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
    return TextButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 5,
      ),
      onPressed: onPressed,
      icon: Icon(
        icon,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
