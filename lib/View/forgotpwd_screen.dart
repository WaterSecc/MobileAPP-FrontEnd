import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forgotPasswordViewModel = Provider.of<ForgotPasswordViewModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height - MediaQuery.of(context).padding.top,
                ),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.05),
                    Image.asset(
                      'assets/images/logo.png',
                      height: size.height * 0.2,
                    ),
                    SizedBox(height: size.height * 0.06),
                    Text(
                      AppLocale.forgotpwd.getString(context),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocale.EmailValidator1.getString(context);
                        } else if (!EmailValidator.validate(value)) {
                          return AppLocale.EmailValidator2.getString(context);
                        }
                        return null;
                      },
                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.background,
                        errorStyle: const TextStyle(fontSize: 9),
                        hintText: AppLocale.Email.getString(context),
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: forgotPasswordViewModel.isLoading
                            ? null
                            : () {
                                final email = _emailController.text.trim();
                                if (_formKey.currentState!.validate()) {
                                  forgotPasswordViewModel.sendResetLink(email, context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        AppLocale.forgotpwdvalidator.getString(context),
                                        style: TextStyles.subtitle3Style(black),
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
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/login');
                      },
                      child: Text(
                        AppLocale.BackLogin.getString(context),
                        style: TextStyles.subtitle5Style(blue),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
