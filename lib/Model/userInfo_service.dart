import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:watersec_mobileapp_front/classes/address.dart';
import 'package:watersec_mobileapp_front/classes/userResponse.dart';

class UserInfoService {
  final _httpClient = http.Client();
  String urlProd = dotenv.env['URLPRODB2B'] ?? '';
  String auth = dotenv.env['AUTH'] ?? '';

  Future<UserResponse> getUserInfo(String accessToken) async {
    final url = Uri.parse(urlProd + auth + 'user');
    final response = await _httpClient.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final addressJson =
          responseBody['user']['address'] as Map<String, dynamic>?;
      return UserResponse(
        id: responseBody['user']['id'] ?? '',
        firstName: responseBody['user']['first_name'] ?? '',
        lastName: responseBody['user']['last_name'] ?? '',
        email: responseBody['user']['email'] ?? '',
        name: responseBody['user']['name'] ?? '',
        contactEmail: responseBody['user']['contact_email'] ?? '',
        contactPhone: responseBody['user']['contact_phone'] ?? '',
        categoryId: responseBody['user']['category_id'] ?? '',
        scope: responseBody['user']['scope'] ?? '',
        fcmToken: responseBody['user']['fcm_token'] ?? '',
        locale: responseBody['user']['locale'] ?? '',
        displayName: responseBody['user']['displayName'] ?? '',
        phoneNumber: responseBody['user']['phoneNumber'] ?? '',
        avatarUrl: responseBody['user']['avatarUrl'],
        address: addressJson != null
            ? Address.fromJson(addressJson)
            : Address(
                addressLine: '',
                zipCode: '',
                country: '',
                city: '',
              ),
      );
    } else {
      throw Exception('Failed to fetch user data');
    }
  }
}
