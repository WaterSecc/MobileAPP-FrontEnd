import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/filled_button.dart';
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
    final forgotPasswordViewModel =
        Provider.of<ForgotPasswordViewModel>(context);
    final size = MediaQuery.of(context).size;

    final bg = Theme.of(context).colorScheme.background;
    final textColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bg,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.height * 0.06),

                          // Logo (center)
                          Center(
                            child: Image.asset(
                              'assets/images/BlueNewLogoVertical.png',
                              height: size.height * 0.22,
                              fit: BoxFit.contain,
                            ),
                          ),

                          SizedBox(height: size.height * 0.05),

                          // Title (left)
                          Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat',
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Divider line (like screenshot)
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: newBlue.withOpacity(0.2),
                          ),

                          const SizedBox(height: 14),

                          // Description
                          Text(
                            "Enter your email and we’ll send you a\nlink to reset your password.",
                            style: TextStyle(
                              color: textColor.withOpacity(0.75),
                              fontSize: 14,
                              height: 1.35,
                              fontFamily: 'Montserrat',
                            ),
                          ),

                          const SizedBox(height: 26),

                          // Email label
                          Text(
                            "E-mail Address",
                            style: TextStyle(
                              color: textColor.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Email field
                          TextFormField(
                            controller: _emailController,
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
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: bg,
                              errorStyle: const TextStyle(fontSize: 9),
                              hintText: "e.g. johndoe@example.com",
                              hintStyle: TextStyle(
                                color: textColor.withOpacity(0.55),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(color: textColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(color: textColor),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Back to login (right aligned, underlined, blue)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.popAndPushNamed(context, '/login');
                              },
                              child: Text(
                                AppLocale.BackLogin.getString(context),
                                style:
                                    TextStyles.subtitle5Style(newBlue).copyWith(
                                  color: newBlue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: newBlue,
                                ),
                              ),
                            ),
                          ),

                          const Spacer(),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 18, top: 10),
                            child: SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: MyFilledButton(
                                text: AppLocale.Send.getString(context),
                                onPressed: forgotPasswordViewModel.isLoading
                                    ? null
                                    : () {
                                        final email =
                                            _emailController.text.trim();
                                        if (_formKey.currentState!.validate()) {
                                          forgotPasswordViewModel.sendResetLink(
                                              email, context);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                AppLocale.forgotpwdvalidator
                                                    .getString(context),
                                                style:
                                                    TextStyles.subtitle3Style(
                                                        black),
                                              ),
                                              backgroundColor: red,
                                            ),
                                          );
                                        }
                                      },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
