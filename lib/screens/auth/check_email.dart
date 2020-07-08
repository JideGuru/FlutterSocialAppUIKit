import 'package:flutter/material.dart';
import 'package:social_app_ui/components/custom_button.dart';
import 'package:social_app_ui/components/custom_text_field.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/validations.dart';

class CheckEmail extends StatefulWidget {
  @override
  _CheckEmailState createState() => _CheckEmailState();
}

class _CheckEmailState extends State<CheckEmail> {
  bool loading = false;
  bool validate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String email = '';

  checkEmail() async{
    FormState form = formKey.currentState;
    form.save();
    if (!form.validate()) {
      validate = true;
      showInSnackBar('Please fix the errors in red before submitting.');
    }else{

    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(value)));
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

              SizedBox(
                height: 100.0,
              ),

              Text(
                'Please input your email address',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),

              SizedBox(
                height: 12.0,
              ),

              Form(
                autovalidate: validate,
                key: formKey,
                child: CustomTextField(
                  enabled: !loading,
                  hintText: "jideguru@gmail.com",
                  textInputAction: TextInputAction.done,
                  validateFunction: Validations.validateEmail,
                  submitAction: checkEmail,
                  onSaved: (String val) {
                    email = val;
                  },
                ),
              ),

              SizedBox(
                height: 20.0,
              ),
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
      label: "Continue",
      onPressed: () => checkEmail(),
    );
  }
}
