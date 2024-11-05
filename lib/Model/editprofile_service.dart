import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:watersec_mobileapp_front/classes/address.dart';

class EditProfileService {
  String urlProd = dotenv.env['URLPRODB2B'] ?? '';
  String auth = dotenv.env['AUTH'] ?? '';

  Future<bool> editProfile(
  String firstname,
  String lastname,
  String phone,
  String email,
  String addressLine,
  String country,
  String city,
  String zipCode,
  String language,
  {File? profileImage, required Map<String, String> headers}
) async {
  final url = Uri.parse(urlProd + auth + 'profile');

  // Create multipart request to handle profile image upload if provided
  final request = http.MultipartRequest('POST', url)
    ..headers.addAll(headers)
    ..fields['first_name'] = firstname
    ..fields['last_name'] = lastname
    ..fields['email'] = email
    ..fields['phone_number'] = phone
    ..fields['address_line'] = addressLine
    ..fields['country'] = country
    ..fields['city'] = city
    ..fields['zip_code'] = zipCode
    ..fields['locale'] = language;

  // Attach the profile image file if provided
  if (profileImage != null) {
    request.files.add(await http.MultipartFile.fromPath(
      'avatarUrl',
      profileImage.path,
      filename: profileImage.path.split('/').last,
    ));
  }

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 200) {
    return true;
  } else {
    print('Error: ${response.body}');
    return false;
  }
}

}
