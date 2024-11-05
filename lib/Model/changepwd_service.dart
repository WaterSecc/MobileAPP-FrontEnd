import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChangePwdService {
  String urlProd = dotenv.env['URLPRODB2B'] ?? '';
  String auth = dotenv.env['AUTH'] ?? '';

  Future<bool> changePwd(String oldpwd, String newpwd, String newpwdconf,
      String? accessToken) async {
    final url = Uri.parse(urlProd + auth + 'change_password');
    final body = {
      'old_password': oldpwd,
      'password': newpwd,
      'password_confirmation': newpwdconf,
    };
    print(jsonEncode(body));

    final http.Response response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    );
    print({'code': response.statusCode});
    if (response.statusCode == 200) {
      print('success:$body');
      return true;
    } else {
      try {
        final responseBody = jsonDecode(response.body);
        final errorMessage = responseBody['error'];
        print(errorMessage);
        return false;
      } catch (e) {
        final contentType = response.headers['Content-Type'];
        if (contentType != null && contentType.startsWith('text/html')) {
          throw Exception(
              'Changing Password failed: API returned an HTML response instead of JSON');
        } else {
          throw Exception(
              'Changing Password failed: API returned an unexpected response');
        }
      }
    }
  }
}
