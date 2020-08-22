import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app_ui/services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  AuthService auth = AuthService();
  bool loading = false;
  bool validate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String email, password, name;
  FocusNode nameFN = FocusNode();
  FocusNode emailFN = FocusNode();
  FocusNode passFN = FocusNode();

  register(BuildContext context) async {
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
        await auth.registerUser(
          email: email,
          password: password,
          name: name,
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

  void showInSnackBar(String value) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }
}
