
import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/Model/changepwd_service.dart';
import 'package:watersec_mobileapp_front/ViewModel/loginViewModel.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final _changepwdService = ChangePwdService();
  final _loginViewModel = LoginViewModel();

  String _oldpwd = '';
  String _newpwd = '';
  String _newpwdconf = '';

  String get oldPwd => _oldpwd;
  String get newPwd => _newpwd;
  String get newPwdConf => _newpwdconf;

  void setOldpwd(String oldPwd) {
    _oldpwd = oldPwd;
    notifyListeners();
  }

  void setNewpassword(String newPwd) {
    _newpwd = newPwd;
    notifyListeners();
  }

  void setNewpasswordConf(String newPwdConf) {
    _newpwdconf = newPwdConf;
    notifyListeners();
  }

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<bool> changePassword() async {
    try {
      final accessToken = await _loginViewModel.getAccessToken();
      if (_newpwd != _newpwdconf) {
        _errorMessage = 'New password and confirmation password do not match.';
        notifyListeners();
        return false;
      }
      final isSuccess = await _changepwdService.changePwd(
        _oldpwd,
        _newpwd,
        _newpwdconf,
        accessToken,
      );
      if (isSuccess) {
        _errorMessage = 'Password Changed!';
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Password change failed.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error changing password: $e';
      notifyListeners();
      return false;
    }
  }
}