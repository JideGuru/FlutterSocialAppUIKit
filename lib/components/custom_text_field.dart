import 'package:flutter/material.dart';
import 'package:social_app_ui/util/config.dart';

class CustomTextField extends StatelessWidget {
  final String initialValue;
  final bool enabled;
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final FocusNode focusNode, nextFocusNode;
  final VoidCallback submitAction;
  final bool obscureText;
  final FormFieldValidator<String> validateFunction;
  final void Function(String) onSaved, onChange;
  final Key key;

  CustomTextField(
      {this.initialValue,
      this.enabled,
      this.hintText,
      this.textInputType,
      this.controller,
      this.textInputAction,
      this.focusNode,
      this.nextFocusNode,
      this.submitAction,
      this.obscureText = false,
      this.validateFunction,
      this.onSaved,
      this.onChange,
      this.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Config.isSmallScreen(context) ? 332.0 : 375.0,
      child: TextFormField(
        initialValue: initialValue,
        enabled: enabled,
        onChanged: onChange,
        style: TextStyle(
          fontSize: 15.0,
        ),
        key: key,
        controller: controller,
        obscureText: obscureText,
        keyboardType: textInputType,
        validator: validateFunction,
        onSaved: onSaved,
        textInputAction: textInputAction,
        focusNode: focusNode,
        onFieldSubmitted: (String input) {
          if (nextFocusNode != null) {
            focusNode.unfocus();
            FocusScope.of(context).requestFocus(nextFocusNode);
          } else {
            submitAction();
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.headline1.color,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
          border: border(context),
          focusedBorder: focusedBorder(context),
          disabledBorder: border(context),
        ),
      ),
    );
  }

  border(BuildContext context) {
    return UnderlineInputBorder();
  }

  focusedBorder(BuildContext context) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
          color: Theme.of(context).accentColor
      ),
    );
  }
}
