import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watersec_mobileapp_front/Model/login_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginViewModel extends ChangeNotifier {
  final _loginService = LoginService();
  final _sharedPreferences = SharedPreferences.getInstance();

  String _email = '';
  String _password = '';
  String? _accessToken;
  String? _fcmToken;

  String get email => _email;
  String get password => _password;
  String? get accessToken => _accessToken;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  // Attempt to fetch FCM token; set as empty string if unavailable
  Future<void> fetchFcmToken() async {
    try {
      _fcmToken = await FirebaseMessaging.instance.getToken();
      print("FCM Token: $_fcmToken");
    } catch (e) {
      _fcmToken = ''; // Use empty string if FCM token is unavailable
      print("Error fetching FCM Token: $e");
    }
  }

  // Check if user session is active
  Future<void> checkUserSession() async {
    _accessToken = await _getAccessTokenFromPreferences();
    if (_accessToken != null) {
      notifyListeners(); // Trigger UI updates if token is present
    }
  }

  Future<bool> login() async {
    try {
      // Fetch FCM token before logging in
      await fetchFcmToken();

      // Pass either the FCM token or empty string to login service
      final loginResponse = await _loginService.login(_email, _password, _fcmToken);
      if (loginResponse.isSuccess) {
        _accessToken = loginResponse.accessToken;
        await _saveAccessToken(_accessToken);
        print("Access Token: $_accessToken");
        print("FCM Token: $_fcmToken");
        notifyListeners();
        return true;
      } else {
        print("Login error: ${loginResponse.errorMessage}");
        return false;
      }
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await _loginService.logout();
    await _clearAccessToken();
    _accessToken = null;
    notifyListeners();
  }

  Future<String?> getAccessToken() async {
    if (_accessToken == null) {
      _accessToken = await _getAccessTokenFromPreferences();
    }
    return _accessToken;
  }

  Future<void> _saveAccessToken(String? accessToken) async {
    final prefs = await _sharedPreferences;
    await prefs.setString('access_token', accessToken ?? '');
  }

  Future<String?> _getAccessTokenFromPreferences() async {
    final prefs = await _sharedPreferences;
    return prefs.getString('access_token');
  }

  Future<void> _clearAccessToken() async {
    final prefs = await _sharedPreferences;
    await prefs.remove('access_token');
  }
}
