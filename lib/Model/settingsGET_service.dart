import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:watersec_mobileapp_front/classes/settings.dart';

class GetSettingsService {
  final _httpClient = http.Client();
  String urlProd = dotenv.env['URLPRODB2B'] ?? '';
  String settings = dotenv.env['SETTINGS'] ?? '';

  // Fetch settings with optional selected device IDs
  Future<SensorData> getSettings(String accessToken,
      [List<String>? selectedDeviceIds]) async {
    Uri url;

    if (selectedDeviceIds != null && selectedDeviceIds.isNotEmpty) {
      // If there are selected devices, append them as query parameters
      String devicesQuery = selectedDeviceIds
          .map((id) => 'locations%5B%5D=$id') // Encode the array syntax
          .join('&');
      url = Uri.parse('$urlProd$settings?$devicesQuery');
    } else {
      // Default URL without query parameters
      url = Uri.parse('$urlProd$settings');
    }

    final response = await _httpClient.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return SensorData.fromJson(responseBody);
    } else {
      throw Exception('Failed to fetch settings');
    }
  }
}
