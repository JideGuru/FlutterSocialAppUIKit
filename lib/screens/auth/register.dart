import 'package:flutter/material.dart';
import 'package:social_app_ui/components/custom_button.dart';
import 'package:social_app_ui/components/custom_text_field.dart';
import 'package:social_app_ui/screens/main_screen.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/util/validations.dart';

class Register extends StatefulWidget {
  final String email;

  Register({@required this.email});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool loading = false;
  bool validate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String email, password, name = '';
  FocusNode nameFN = FocusNode();
  FocusNode emailFN = FocusNode();
  FocusNode passFN = FocusNode();

  register() async {
    FormState form = formKey.currentState;
    form.save();
    if (!form.validate()) {
      validate = true;
      setState(() {});
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      Navigate.pushPage(context, MainScreen());
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Hero(
                tag: 'appname',
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    '${Constants.appName}',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 100.0),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CustomTextField(
                      enabled: !loading,
                      hintText: "Name",
                      textInputAction: TextInputAction.next,
                      validateFunction: Validations.validateName,
                      onSaved: (String val) {
                        name = val;
                      },
                      focusNode: nameFN,
                      nextFocusNode: emailFN,
                    ),
                    SizedBox(height: 20.0),
                    CustomTextField(
                      enabled: false,
                      initialValue: widget.email,
                      hintText: "jideguru@gmail.com",
                      textInputAction: TextInputAction.next,
                      validateFunction: Validations.validateEmail,
                      onSaved: (String val) {
                        email = val;
                      },
                      focusNode: emailFN,
                      nextFocusNode: passFN,
                    ),
                    SizedBox(height: 20.0),
                    CustomTextField(
                      enabled: !loading,
                      hintText: "Password",
                      textInputAction: TextInputAction.done,
                      validateFunction: Validations.validatePassword,
                      submitAction: register,
                      obscureText: true,
                      onSaved: (String val) {
                        password = val;
                      },
                      focusNode: passFN,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.0),
              buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  buildButton() {
    return loading
        ? Center(child: CircularProgressIndicator())
        : CustomButton(
            label: "Register",
            onPressed: () => register(),
          );
  }
}
