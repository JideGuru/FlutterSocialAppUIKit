import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app_ui/components/custom_button.dart';
import 'package:social_app_ui/components/custom_text_field.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/validations.dart';
import 'package:social_app_ui/view_models/auth/check_email_view_model.dart';

class CheckEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CheckEmailViewModel>(
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
                    autovalidate: viewModel.validate,
                    key: viewModel.formKey,
                    child: CustomTextField(
                      enabled: !viewModel.loading,
                      hintText: "jideguru@gmail.com",
                      textInputAction: TextInputAction.done,
                      validateFunction: Validations.validateEmail,
                      submitAction: () => viewModel.checkEmail(context),
                      onSaved: (String val) {
                        viewModel.email = val;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
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

  buildButton(BuildContext context, CheckEmailViewModel viewModel) {
    return viewModel.loading
        ? Center(child: CircularProgressIndicator())
        : CustomButton(
            label: "Continue",
            onPressed: () => viewModel.checkEmail(context),
          );
  }
}
