import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:watersec_mobileapp_front/classes/consumption.dart';
import 'package:watersec_mobileapp_front/classes/consumptiondataResponse.dart';

class DayPeriodConsumptionService {
  final _httpClient = http.Client();
  String urlProd = dotenv.env['URLPRODB2B'] ?? '';
  String periodstats = dotenv.env['PERIODSTATS'] ?? '';

  Future<ConsumptionDataResponse> getDayPeriodConsumption(
      String accessToken, List<String> selectedWaterMeterIds) async {
    
    Uri url;

    // If there are selected water meters, add them as query parameters
    if (selectedWaterMeterIds.isNotEmpty) {
      String locationsQuery = selectedWaterMeterIds
          .map((id) => 'locations%5B%5D=$id') // Encode [] as %5B%5D
          .join('&');
      url = Uri.parse('$urlProd${periodstats}day?$locationsQuery');
    } else {
      // Default URL without water meter selection
      url = Uri.parse('$urlProd${periodstats}day');
    }

    final response = await _httpClient.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final consumptionData = (responseBody['consumptions'] as List<dynamic>)
          .map((item) => Consumption(
                tag: item['tag'],
                values: (item['consumptions'] as List<dynamic>)
                    .map((value) => (value as num).toDouble())
                    .toList(),
              ))
          .toList();
      return ConsumptionDataResponse(
        dates: List<String>.from(responseBody['dates']),
        consumptions: consumptionData,
        total: responseBody['total'],
      );
    } else {
      throw Exception(
          'Failed to fetch water consumption data for the period: day');
    }
  }
}
