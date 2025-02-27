import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/filled_button.dart';
import 'package:watersec_mobileapp_front/View/components/text_field.dart';
import 'package:watersec_mobileapp_front/View/forgotpwd_screen.dart';
import 'package:watersec_mobileapp_front/ViewModel/loginViewModel.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _loginViewModel = LoginViewModel();
  bool _isButtonDisabled = false;

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _isButtonDisabled = true;
      });
      final isLoggedIn = await _loginViewModel.login();
      setState(() {
        _isButtonDisabled = false;
      });
      if (isLoggedIn) {
        Navigator.popAndPushNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocale.FailedLogin.getString(context)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when the user taps anywhere on the screen
        FocusScope.of(context).unfocus();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: Scaffold(
          body: Form(
            key: _formKey,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 5, top: 20),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(top: 370, left: 65),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 260,
                          height: 52,
                          child: MyTextField(
                            hint: AppLocale.Email.getString(context),
                            onChanged: (value) {
                              _loginViewModel.setEmail(value);
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return AppLocale.EmailValidator1.getString(
                                    context);
                              } else if (EmailValidator.validate(value) ==
                                  false) {
                                return AppLocale.EmailValidator2.getString(
                                    context);
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 260,
                          height: 55,
                          child: MyTextField(
                            hint: AppLocale.Password.getString(context),
                            obscureText: true,
                            onChanged: (value) {
                              _loginViewModel.setPassword(value);
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return AppLocale.PasswordValidator1.getString(
                                    context);
                              } else if (value.length < 6) {
                                return AppLocale.PasswordValidator2.getString(
                                    context);
                              } else {
                                return null;
                              }
                            },
                            showPasswordToggle: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 260,
                          height: 55,
                          child: MyFilledButton(
                            text: AppLocale.Seconnecter.getString(context),
                            onPressed: _isButtonDisabled ? null : _handleLogin,
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 260,
                          height: 52,
                          child: TextButton(
                            onPressed: () {
                              Navigator.popAndPushNamed(context, '/forgotpwd');
                            },
                            child: Text(
                              AppLocale.Mdpoublie.getString(context),
                              style: TextStyles.subtitle2Style(blue),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
