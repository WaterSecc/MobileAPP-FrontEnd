import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:watersec_mobileapp_front/classes/loginResponse.dart';

class LoginService { 
  String urlProd = dotenv.env['URLPRODB2B'] ?? '';
  String auth = dotenv.env['AUTH'] ?? '';

  Future<LoginResponse> login(String email, String password, String? fcmToken) async {
    final url = Uri.parse(urlProd + auth + 'login');
    final body = {
      'email': email,
      'password': password,
      'fcm_token': fcmToken ?? '', // Send FCM token or empty string
    };
    print("Request body: $body");

    final http.Response response = await http.post(
      url,
      body: body,
    );

    if (response.statusCode == 200) {
      try {
        final responseBody = jsonDecode(response.body);

        // Retrieve accessToken from response
        final accessToken = responseBody['accessToken'] as String?;
        if (accessToken == null) {
          throw Exception('Login failed: Missing accessToken');
        }

        // Store accessToken securely
        await _storeTokens(accessToken);

        return LoginResponse(isSuccess: true, accessToken: accessToken);
      } catch (e) {
        throw Exception('Login failed: ${e.toString()}');
      }
    } else {
      try {
        final responseBody = jsonDecode(response.body);
        final errorMessage = responseBody['error'];
        return LoginResponse(isSuccess: false, errorMessage: errorMessage);
      } catch (e) {
        throw Exception('Login failed: ${e.toString()}');
      }
    }
  }

  Future<void> _storeTokens(String accessToken) async {
    await FlutterSecureStorage().write(key: 'accessToken', value: accessToken);
  }

  Future<void> logout() async {
    await FlutterSecureStorage().delete(key: 'accessToken');
  }
}
