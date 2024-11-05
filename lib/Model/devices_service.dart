import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:watersec_mobileapp_front/classes/devices.dart';

class DevicesService {
  final _httpClient = http.Client();
  String urlProd = dotenv.env['URLPRODB2B'] ?? '';
  String devices = dotenv.env['DEVICES'] ?? '';

  // Fetch devices (buildings) based on selected water meters (locations)
  Future<List<Building>> getDevices(
      String accessToken, List<String> selectedWaterMeterIds) async {
    Uri url;

    if (selectedWaterMeterIds.isNotEmpty) {
      // Add selected water meters (locations) to the URL as query parameters
      String locationsQuery = selectedWaterMeterIds
          .map((id) => 'locations%5B%5D=$id') // Encode the array syntax
          .join('&');
      url = Uri.parse('$urlProd$devices?$locationsQuery');
      print(url); // To verify the URL is correct
    } else {
      // Default URL without query parameters
      url = Uri.parse('$urlProd$devices');
    }
    print(url);
    final response = await _httpClient.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print(responseBody);
      return (responseBody as List)
          .map((buildingJson) => Building.fromJson(buildingJson))
          .toList();
    } else {
      throw Exception('Failed to fetch devices');
    }
  }
}
