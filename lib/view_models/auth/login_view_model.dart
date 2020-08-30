import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app_ui/services/auth_service.dart';
import 'package:social_app_ui/util/validations.dart';

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
      try {
        await auth.loginUser(
          email: email,
          password: password,
        );
      } catch (e) {
        loading = false;
        notifyListeners();
        showInSnackBar(
          '${auth.handleFirebaseAuthError(e.toString())}',
        );
      }
      loading = false;
      notifyListeners();
    }
  }

  forgotPassword() async {
    FormState form = formKey.currentState;
    form.save();
    print(email);
    print(Validations.validateEmail(email));
    if(Validations.validateEmail(email) != null){
      showInSnackBar('Please input a valid email to reset your password.');
    }else {
      try {
        await auth.forgotPassword(email);
        showInSnackBar('Please check your email for instructions '
            'to reset your password');
      } catch (e) {
        showInSnackBar('${e.toString()}');
      }
    }
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }
}
