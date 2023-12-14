import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app_ui/util/animations.dart';
import 'package:social_app_ui/util/auth.dart';
import 'package:social_app_ui/util/configs/configs.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/notify.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/util/validations.dart';
import 'package:social_app_ui/views/screens/init_screen.dart';
import 'package:social_app_ui/views/screens/survey.dart';
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
  String email = '', password = '', emailVal = '';
  FocusNode emailFN = FocusNode();
  FocusNode passFN = FocusNode();
  FormMode formMode = FormMode.LOGIN;
  int emailValNum = 12345;

  final auth = Auth();

  login() async {
    FormState form = formKey.currentState!;
    form.save();
    if (!form.validate()) {
      validate = true;
      setState(() {});
    } else {
      var authMessage = '';
      switch (formMode) {
        case FormMode.REGISTER:
          authMessage = await auth.createUser(email, password);
          break;
        case FormMode.LOGIN:
          authMessage = await auth.signIn(email, password);
          break;
        case FormMode.FORGOT_PASSWORD:
          authMessage = await auth.sendPasswordResetEmail(email);
          break;
      }
      if (authMessage != 'verified')
        auth.showAuthDialog(context, authMessage);
      else
        switch (formMode) {
          case FormMode.REGISTER:
            FirebaseAuth.instance.currentUser!.sendEmailVerification();
            auth.showAuthDialog(context, consts['auth-link'].toString());
            formMode = FormMode.LOGIN;
            setState(() {});
            break;
          case FormMode.LOGIN:
            // if (!FirebaseAuth.instance.currentUser!.emailVerified) {
            //   FirebaseAuth.instance.currentUser!.sendEmailVerification();
            //   auth.showAuthDialog(
            //       context, consts['auth-link-again'].toString());
            // } else {
            //   usersColRef.doc(email).get().then((value) {
            //     if (value.exists) {
            //       Navigate.pushPageReplacement(
            //           context, InitScreen(email: email));
            //     } else
            //       Navigate.pushPageReplacement(context, Survey(email: email));
            //   });
            // }
            usersColRef.doc(email).get().then((value) {
              if (value.exists) {
                Notify.updateToken(email: email);
                Navigate.pushPageReplacement(context, InitScreen(email: email));
              } else
                Navigate.pushPageReplacement(context, Survey(email: email));
            });
            break;
          case FormMode.FORGOT_PASSWORD:
            // Navigate.pushPageReplacement(context, InitScreen(email: email));
            break;
        }
    }
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
        child: Lottie.asset(AppAnimations.chatAnimation,
            height: 400, fit: BoxFit.cover),
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
          '${appName}',
          style: GoogleFonts.inknutAntiqua(
              textStyle: TextStyle(
            color: Colors.black,
            fontSize: 40,
          )),
        ).fadeInList(0, false),
        Visibility(
          visible: formMode == FormMode.REGISTER,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.0),
              Text(
                consts['register'].toString(),
                style: GoogleFonts.inknutAntiqua(
                  textStyle: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 50.0),
            ],
          ),
        ).fadeInList(0, false),
        Visibility(
          visible: formMode == FormMode.FORGOT_PASSWORD,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.0),
              Text(
                consts['forget-password'].toString(),
                style: GoogleFonts.inknutAntiqua(
                  textStyle: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 50.0),
            ],
          ),
        ).fadeInList(0, false),
        Visibility(
          visible: formMode == FormMode.LOGIN,
          child: SizedBox(height: 70.0),
        ),
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
                  child: Text(consts['forget-password'].toString()),
                ),
              ),
            ],
          ),
        ).fadeInList(3, false),
        SizedBox(height: 20.0),
        buildButton(),
        Visibility(
          visible: formMode != FormMode.LOGIN,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(consts['registered-already'].toString(),
                  style: Theme.of(context).textTheme.bodySmall),
              TextButton(
                onPressed: () {
                  formMode = FormMode.LOGIN;
                  setState(() {});
                },
                child: Text(consts['login'].toString()),
              ),
            ],
          ),
        ),
        Visibility(
          visible: formMode != FormMode.REGISTER,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                consts['register'].toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextButton(
                onPressed: () {
                  formMode = FormMode.REGISTER;
                  setState(() {});
                },
                child: Text(consts['register'].toString()),
              ),
            ],
          ),
        ).fadeInList(5, false),
      ],
    );
  }

  buildForm() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: [
            Container(
              width: formMode == FormMode.REGISTER
                  ? screenWidth * 0.8
                  : screenWidth * 0.8,
              child: CustomTextField(
                enabled: !loading,
                hintText: consts['university-email'].toString(),
                textInputAction: TextInputAction.next,
                validateFunction: Validations.validateEmail,
                onChange: (String? val) {
                  email = val ?? '';
                },
                focusNode: emailFN,
              ),
            ),
          ],
        ).fadeInList(1, false),
        Visibility(
          visible: formMode != FormMode.FORGOT_PASSWORD,
          child: Column(
            children: [
              SizedBox(height: 20.0),
              CustomTextField(
                enabled: !loading,
                hintText: consts['password'].toString(),
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
            label: formMode == FormMode.LOGIN
                ? consts['login'].toString()
                : consts['submit'].toString(),
            onPressed: () => login()).fadeInList(4, false);
  }
}
