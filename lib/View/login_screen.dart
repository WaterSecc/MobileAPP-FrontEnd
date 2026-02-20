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
    final bg = Theme.of(context).colorScheme.background;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.height * 0.08),

                          // Logo (centered)
                          Center(
                            child: Image.asset(
                              'assets/images/BlueNewLogoVertical.png',
                              height: size.height * 0.22,
                              fit: BoxFit.contain,
                            ),
                          ),

                          SizedBox(height: size.height * 0.06),

                          // Email label
                          Text(
                            "E-mail",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Email field
                          SizedBox(
                            height: 52,
                            width: double.infinity,
                            child: MyTextField(
                              hint: "e.g. johndoe@example.com",
                              onChanged: _loginViewModel.setEmail,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocale.EmailValidator1.getString(
                                      context);
                                } else if (!EmailValidator.validate(value)) {
                                  return AppLocale.EmailValidator2.getString(
                                      context);
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Password label
                          Text(
                            "Password",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Password field
                          SizedBox(
                            height: 52,
                            width: double.infinity,
                            child: MyTextField(
                              hint: AppLocale.Password.getString(context),
                              obscureText: true,
                              showPasswordToggle: true, // keeps your same icons
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
                          ),

                          const SizedBox(height: 10),

                          // Forgot password (right aligned, under password)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.popAndPushNamed(
                                  context, '/forgotpwd'),
                              child: Text(
                                AppLocale.Mdpoublie.getString(context),
                                style:
                                    TextStyles.subtitle2Style(newBlue).copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationColor: newBlue,
                                ),
                              ),
                            ),
                          ),

                          const Spacer(),

                          // Bottom login button (full width, pinned low)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18, top: 10),
                            child: SizedBox(
                              height: 54,
                              width: double.infinity,
                              child: MyFilledButton(
                                text: AppLocale.Seconnecter.getString(context),
                                onPressed:
                                    _isButtonDisabled ? null : _handleLogin,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
