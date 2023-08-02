import 'package:flutter/material.dart';

class InprofileButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function() onPressed;

  const InprofileButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
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
      ),
    );
  }
}
