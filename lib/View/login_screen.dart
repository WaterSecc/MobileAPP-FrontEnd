import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/filled_button.dart';
import 'package:watersec_mobileapp_front/View/components/text_field.dart';
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
      setState(() => _isButtonDisabled = true);
      final isLoggedIn = await _loginViewModel.login();
      setState(() => _isButtonDisabled = false);
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
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: size.height - MediaQuery.of(context).padding.top),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.08),
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: size.height * 0.2,
                      ),
                    ),
                    SizedBox(height: size.height * 0.08),
                    MyTextField(
                      hint: AppLocale.Email.getString(context),
                      onChanged: _loginViewModel.setEmail,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocale.EmailValidator1.getString(context);
                        } else if (!EmailValidator.validate(value)) {
                          return AppLocale.EmailValidator2.getString(context);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                      hint: AppLocale.Password.getString(context),
                      obscureText: true,
                      showPasswordToggle: true,
                      onChanged: _loginViewModel.setPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocale.PasswordValidator1.getString(
                              context);
                        } else if (value.length < 6) {
                          return AppLocale.PasswordValidator2.getString(
                              context);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    MyFilledButton(
                      text: AppLocale.Seconnecter.getString(context),
                      onPressed: _isButtonDisabled ? null : _handleLogin,
                    ),
                    const SizedBox(height: 30),
                    TextButton(
                      onPressed: () =>
                          Navigator.popAndPushNamed(context, '/forgotpwd'),
                      child: Text(
                        AppLocale.Mdpoublie.getString(context),
                        style: TextStyles.subtitle2Style(blue),
                      ),
                    ),
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
