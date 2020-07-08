import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app_ui/components/custom_button.dart';
import 'package:social_app_ui/components/custom_text_field.dart';
import 'package:social_app_ui/screens/auth/register.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/util/validations.dart';
import 'package:social_app_ui/view_models/auth/login_view_model.dart';

class Login extends StatelessWidget {
  final String email;

  Login({@required this.email});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (BuildContext context, viewModel, Widget child) {
        return Scaffold(
          key: viewModel.scaffoldKey,
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
                  Form(
                    autovalidate: viewModel.validate,
                    key: viewModel.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CustomTextField(
                          enabled: false,
                          hintText: "jideguru@gmail.com",
                          textInputAction: TextInputAction.next,
                          validateFunction: Validations.validateEmail,
                          onSaved: (String val) {
                            viewModel.email = val;
                          },
                          initialValue: email,
                          focusNode: viewModel.emailFN,
                          nextFocusNode: viewModel.passFN,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        CustomTextField(
                          enabled: !viewModel.loading,
                          hintText: "Password",
                          textInputAction: TextInputAction.done,
                          validateFunction: Validations.validatePassword,
                          submitAction: ()=>viewModel.login(context),
                          obscureText: true,
                          onSaved: (String val) {
                            viewModel.password = val;
                          },
                          focusNode: viewModel.passFN,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  buildButton(context, viewModel),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  buildButton(BuildContext context, LoginViewModel viewModel) {
    return viewModel.loading
        ? Center(child: CircularProgressIndicator())
        : CustomButton(
            label: "Login",
            onPressed: () => viewModel.login(context),
          );
  }
}
