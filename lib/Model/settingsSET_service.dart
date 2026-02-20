import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:watersec_mobileapp_front/classes/settings.dart';

class SetSettingsService {
  final _httpClient = http.Client();
  String urlProd = dotenv.env['URLPRODB2B'] ?? '';
  String settingsEndpoint = dotenv.env['SETTINGS'] ?? '';

  // Update settings on the backend
  Future<void> setSettings(String accessToken, SensorData sensorData) async {
    Uri url = Uri.parse('$urlProd$settingsEndpoint');

    final response = await _httpClient.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(sensorData.toJson()), // Convert the sensor data to JSON
    );

    if (response.statusCode == 200) {
      print('Settings updated successfully');
    } else {
      print('Error updating settings: ${response.body}');
      throw Exception('Failed to update settings');
    }
  }
}
