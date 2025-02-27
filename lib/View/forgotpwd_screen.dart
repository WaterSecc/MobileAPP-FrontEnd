import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/ViewModel/forgotpwdViewModel.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class ForgotPwd extends StatefulWidget {
  const ForgotPwd({super.key});

  @override
  State<ForgotPwd> createState() => _ForgotPwdState();
}

class _ForgotPwdState extends State<ForgotPwd> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forgotPasswordViewModel =
        Provider.of<ForgotPasswordViewModel>(context);

    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Row(
            children: [
              SizedBox(width: 15),
            ],
          ),
        ),
        body: Form(
          child: Stack(
            children: [
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.only(left: 5, top: 20),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 360, left: 55),
                  child: Column(
                    children: [
                      Container(
                        width: 285,
                        child: Text(
                          AppLocale.forgotpwd.getString(context),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      SizedBox(
                        width: 260,
                        height: 48,
                        child: TextFormField(
                          controller: _emailController,
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
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.background,
                            errorStyle: const TextStyle(fontSize: 9),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            hintText: AppLocale.Email.getString(context),
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 260,
                        height: 48,
                        child: FilledButton(
                          onPressed: forgotPasswordViewModel.isLoading
                              ? null
                              : () {
                                  // Trigger the ViewModel to send the reset link
                                  final email = _emailController.text.trim();
                                  if (email.isNotEmpty) {
                                    forgotPasswordViewModel.sendResetLink(
                                        email, context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          AppLocale.forgotpwdvalidator
                                              .getString(context),
                                          style:
                                              TextStyles.subtitle3Style(black),
                                        ),
                                        backgroundColor: red,
                                      ),
                                    );
                                  }
                                },
                          child: Text(
                            AppLocale.Send.getString(context),
                            style: TextStyles.txtBtnNOStyle(white),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                              Theme.of(context).cardColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        width: 260,
                        height: 52,
                        child: TextButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, '/login');
                          },
                          child: Text(
                            AppLocale.BackLogin.getString(context),
                            style: TextStyles.subtitle5Style(blue),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
