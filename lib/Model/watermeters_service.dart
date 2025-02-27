import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:watersec_mobileapp_front/classes/devices_response.dart';
import 'package:watersec_mobileapp_front/classes/watermeterResponse.dart';

class WaterMeterService {
  final _httpClient = http.Client();
  String urlProd = dotenv.env['URLPRODB2B'] ?? '';
  String locations = dotenv.env['LOCATIONS'] ?? '';

  Future<WaterMeterResponse> getWaterMeters(String accessToken) async {
    final url = Uri.parse(urlProd + locations);
    final response = await _httpClient.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return WaterMeterResponse.fromJson(responseBody);
    } else {
      throw Exception('Failed to fetch list of water meters');
    }
  }
}
