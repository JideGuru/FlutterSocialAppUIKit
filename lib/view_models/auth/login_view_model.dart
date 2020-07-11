import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app_ui/screens/main_page/main_screen.dart';
import 'package:social_app_ui/services/auth_service.dart';
import 'package:social_app_ui/util/router.dart';

class LoginViewModel extends ChangeNotifier {
  AuthService auth = AuthService();
  bool loading = false;
  bool validate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String email, password;
  FocusNode emailFN = FocusNode();
  FocusNode passFN = FocusNode();

  login(BuildContext context) async {
    FormState form = formKey.currentState;
    form.save();
    if (!form.validate()) {
      validate = true;
      notifyListeners();
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      loading = true;
      notifyListeners();
      bool loggedIn = await auth
          .loginUser(
        email: email,
        password: password,
      )
          .catchError((e) {
        loading = false;
        notifyListeners();
        showInSnackBar(
          '${auth.handleFirebaseAuthError(e.toString())}',
        );
      });
      if (loggedIn == true) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Router.pushPage(context, MainScreen());
      }
      loading = false;
      notifyListeners();
    }
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }
}
