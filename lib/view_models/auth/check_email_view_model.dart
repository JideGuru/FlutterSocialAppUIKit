import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app_ui/views/auth/login/login.dart';
import 'package:social_app_ui/views/auth/register/register.dart';
import 'package:social_app_ui/services/auth_service.dart';
import 'package:social_app_ui/util/router.dart';

class CheckEmailViewModel extends ChangeNotifier{
  AuthService auth = AuthService();
  bool loading = false;
  bool validate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String email = '';

  checkEmail(BuildContext context) async {
    FormState form = formKey.currentState;
    form.save();
    if (!form.validate()) {
      validate = true;
      notifyListeners();
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      loading = true;
      notifyListeners();
      bool isSigned = await auth.checkUser(email).catchError((e)=>print(e));
      if (isSigned) {
        Router.pushPage(context, Login(email: email));
      } else {
        Router.pushPage(context, Register(email: email));
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
