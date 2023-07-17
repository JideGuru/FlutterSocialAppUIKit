import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app_ui/util/animations.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/util/validations.dart';
import 'package:social_app_ui/views/screens/main_screen.dart';
import 'package:social_app_ui/views/widgets/custom_button.dart';
import 'package:social_app_ui/views/widgets/custom_text_field.dart';
import 'package:social_app_ui/util/extensions.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  bool validate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String email = '', password = '', name = '';
  FocusNode nameFN = FocusNode();
  FocusNode emailFN = FocusNode();
  FocusNode passFN = FocusNode();
  FormMode formMode = FormMode.LOGIN;

  login() async {
    FormState form = formKey.currentState!;
    form.save();
    Navigate.pushPageReplacement(context, MainScreen());
    // if (!form.validate()) {
    //   validate = true;
    //   setState(() {});
    //   showInSnackBar('Please fix the errors in red before submitting.');
    // } else {
    //   Navigate.pushPageReplacement(context, MainScreen());
    // }
  }

  void showInSnackBar(String value) {
    // _scaffoldKey.currentState?.removeCurrentSnackBar();
    // _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Row(
          children: [
            buildLottieContainer(),
            Expanded(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                child: Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: buildFormContainer(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildLottieContainer() {
    final screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      width: screenWidth < 700 ? 0 : screenWidth * 0.5,
      duration: Duration(milliseconds: 500),
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
      child: Center(
        child: Lottie.asset(
          AppAnimations.chatAnimation,
          height: 400,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  buildFormContainer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          '${Constants.appName}',
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ).fadeInList(0, false),
        SizedBox(height: 70.0),
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: buildForm(),
        ),
        Visibility(
          visible: formMode == FormMode.LOGIN,
          child: Column(
            children: [
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    formMode = FormMode.FORGOT_PASSWORD;
                    setState(() {});
                  },
                  child: Text('Forgot Password?'),
                ),
              ),
            ],
          ),
        ).fadeInList(3, false),
        SizedBox(height: 20.0),
        buildButton(),
        Visibility(
          visible: formMode == FormMode.LOGIN,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Don\'t have an account?'),
              TextButton(
                onPressed: () {
                  formMode = FormMode.REGISTER;
                  setState(() {});
                },
                child: Text('Register'),
              ),
            ],
          ),
        ).fadeInList(5, false),
        Visibility(
          visible: formMode != FormMode.LOGIN,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already have an account?'),
              TextButton(
                onPressed: () {
                  formMode = FormMode.LOGIN;
                  setState(() {});
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Visibility(
          visible: formMode == FormMode.REGISTER,
          child: Column(
            children: [
              CustomTextField(
                enabled: !loading,
                hintText: "Name",
                textInputAction: TextInputAction.next,
                validateFunction: Validations.validateName,
                onSaved: (String? val) {
                  name = val ?? '';
                },
                focusNode: nameFN,
                nextFocusNode: emailFN,
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
        CustomTextField(
          enabled: !loading,
          hintText: "Email",
          textInputAction: TextInputAction.next,
          validateFunction: Validations.validateEmail,
          onSaved: (String? val) {
            email = val ?? '';
          },
          focusNode: emailFN,
          nextFocusNode: passFN,
        ).fadeInList(1, false),
        Visibility(
          visible: formMode != FormMode.FORGOT_PASSWORD,
          child: Column(
            children: [
              SizedBox(height: 20.0),
              CustomTextField(
                enabled: !loading,
                hintText: "Password",
                textInputAction: TextInputAction.done,
                validateFunction: Validations.validatePassword,
                submitAction: login,
                obscureText: true,
                onSaved: (String? val) {
                  password = val ?? '';
                },
                focusNode: passFN,
              ),
            ],
          ),
        ).fadeInList(2, false),
      ],
    );
  }

  buildButton() {
    return loading
        ? Center(child: CircularProgressIndicator())
        : CustomButton(
            label: "Submit",
            onPressed: () => login(),
          ).fadeInList(4, false);
  }
}
