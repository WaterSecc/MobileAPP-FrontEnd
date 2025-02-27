import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/Model/forgotpwd_service.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final ForgotPwdService _forgotPasswordService = ForgotPwdService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> sendResetLink(String email, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final isSuccess = await _forgotPasswordService.sendResetPasswordLink(email);

    _isLoading = false;
    notifyListeners();

    if (isSuccess) {
      _showSuccessDialog(context);
    } else {
      _showFailureSnackBar(context);
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocale.lienenvoyer.getString(context),
                textAlign: TextAlign.center,
                style: TextStyles.subtitle3Style(black),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  AppLocale.OK.getString(context),
                  style: TextStyles.DatenavBtn(
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  AppLocale.nolink.getString(context),
                  style: TextStyles.DatenavBtn(black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFailureSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocale.tryagain.getString(context),
          style: TextStyles.DatenavBtn(black),
        ),
        backgroundColor: red,
      ),
    );
  }
}
