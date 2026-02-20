import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/filled_button.dart';
import 'package:watersec_mobileapp_front/View/components/text_field.dart';
import 'package:watersec_mobileapp_front/ViewModel/changepwdViewModel.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class ChangePwd extends StatefulWidget {
  const ChangePwd({super.key});

  @override
  State<ChangePwd> createState() => _ChangePwdState();
}

class _ChangePwdState extends State<ChangePwd> {
  final _changepwdViewModel = ChangePasswordViewModel();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.background;
    final textColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bg,
        automaticallyImplyLeading: false, // prevent default behavior
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
          ),
          onPressed: () {
            Navigator.pop(context); // go back to previous screen
          },
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // Title
                        Text(
                          AppLocale.ChangePwd.getString(context),
                          style:
                              TextStyles.appBarHeaderStyle(textColor).copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle (as in the screenshot)
                        Text(
                          "Re-enter your current password then set your new one and confirm it",
                          style: TextStyle(
                            color: textColor.withOpacity(0.75),
                            fontSize: 14,
                            height: 1.3,
                          ),
                        ),

                        const SizedBox(height: 36),

                        // Current password label + field
                        Text(
                          "Current Password",
                          style: TextStyle(
                            color: textColor.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: MyTextField(
                            obscureText: true,
                            hint: AppLocale.OldPwd.getString(context),
                            onChanged: (value) {
                              _changepwdViewModel.setOldpwd(value);
                            },
                            showPasswordToggle: true, // keep your icon behavior
                          ),
                        ),

                        const SizedBox(height: 22),

                        // New password label + field
                        Text(
                          "New Password",
                          style: TextStyle(
                            color: textColor.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: MyTextField(
                            obscureText: true,
                            hint: AppLocale.NewPwd.getString(context),
                            onChanged: (value) {
                              _changepwdViewModel.setNewpassword(value);
                            },
                            showPasswordToggle: true, // keep your icon behavior
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Confirm password label + field
                        Text(
                          "Confirmed Password",
                          style: TextStyle(
                            color: textColor.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: MyTextField(
                            obscureText: true,
                            hint: AppLocale.ConfirmPwd.getString(context),
                            onChanged: (value) {
                              _changepwdViewModel.setNewpasswordConf(value);
                            },
                            showPasswordToggle: true, // keep your icon behavior
                          ),
                        ),

                        const Spacer(),

                        // Bottom button (full width like the screenshot)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18, top: 30),
                          child: SizedBox(
                            height: 52,
                            width: double.infinity,
                            child: MyFilledButton(
                              text: AppLocale.Save.getString(context),
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  _formKey.currentState?.save();

                                  final ispwdChanged = await _changepwdViewModel
                                      .changePassword();

                                  if (ispwdChanged) {
                                    Navigator.popAndPushNamed(
                                        context, '/profile');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Password Change Failed'),
                                      ),
                                    );
                                  }
                                }
                              },
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
    );
  }
}
