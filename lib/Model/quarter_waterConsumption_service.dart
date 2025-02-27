import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:watersec_mobileapp_front/classes/quarter_waterConsumptionResponse.dart';

class QuarterWaterConsumptionService {
  final _httpClient = http.Client();
  String urlProd = dotenv.env['URLPRODB2B'] ?? '';
  String stats = dotenv.env['STATS'] ?? '';

  Future<QuarterWaterConsumptionResponse> getQuarterWaterConsumption(
      String accessToken, List<String> selectedWaterMeterIds) async {
    Uri url;

    if (selectedWaterMeterIds.isNotEmpty) {
      String locationsQuery = selectedWaterMeterIds
          .map((id) => 'locations%5B%5D=$id') // Encode [] as %5B%5D
          .join('&');
      url = Uri.parse('$urlProd${stats}one_month?$locationsQuery');
    } else {
      url = Uri.parse('$urlProd${stats}one_month');
    }

    final response = await _httpClient.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return QuarterWaterConsumptionResponse(
        current_month_consumption: responseBody['current_month_consumption'] ?? 0.0,
        percentage: responseBody['percentage'] ?? 0.0,
      );
    } else {
      throw Exception('Failed to fetch water consumption data');
    }
  }
}
