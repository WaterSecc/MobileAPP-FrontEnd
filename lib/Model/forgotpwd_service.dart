import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ForgotPwdService {
  String urlProd = dotenv.env['URLPRODB2B'] ?? '';
  String auth = dotenv.env['AUTH'] ?? '';

  Future<bool> sendResetPasswordLink(String email) async {
    // Construct the URL with the email as a query parameter
    final url = Uri.parse('$urlProd$auth/forgot-password?email=$email');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true; // Email sent successfully
      } else {
        return false; // Failed to send email
      }
    } catch (e) {
      return false; // Error occurred
    }
  }
}
