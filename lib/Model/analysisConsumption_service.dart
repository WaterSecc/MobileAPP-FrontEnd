import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:watersec_mobileapp_front/classes/analyses_request.dart';
import 'package:watersec_mobileapp_front/classes/consumption.dart';
import 'package:watersec_mobileapp_front/classes/consumption_statsResponse.dart';
import 'package:watersec_mobileapp_front/classes/consumptiondata_analysesResponse.dart';

class AnalyticsService {
  final _httpClient = http.Client();
  String urlProd = dotenv.env['URLPRODB2B'] ?? '';
  String analytics = dotenv.env['ANALYTICSDATA'] ?? '';

  Future<ConsumptionDataAnalyses> getAnalytics(AnalyticsRequest request,
      String accessToken, List<String> selectedLocations) async {
    try {
      // Convert request parameters to query parameters
      Map<String, dynamic> queryParams = request.toQueryParameters();

      // Add selected sensors (tags) if available
      if (request.sensors != null && request.sensors!.isNotEmpty) {
        queryParams['sensors[]'] =
            request.sensors; // Let Dart handle array encoding
      }

      // Add selected locations (water meters) if available
      if (selectedLocations.isNotEmpty) {
        queryParams['locations[]'] =
            selectedLocations; // Let Dart handle array encoding
      }

      // Build the URL with query parameters
      final url =
          Uri.parse(urlProd + analytics).replace(queryParameters: queryParams);

      // Make the HTTP GET request
      final response = await _httpClient.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );
      print(url); // Print the final URL to verify

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        // Parse the response and create consumption data
        final consumptionData =
            (responseBody['data']['consumptions'] as List<dynamic>)
                .map((item) => Consumption(
                      tag: item['tag'],
                      values: (item['consumptions'] as List<dynamic>)
                          .map((value) => (value as num).toDouble())
                          .toList(),
                    ))
                .toList();

        final statsData =
            (responseBody['data']['stats'] as List<dynamic>).map((item) {
          final statsMap = (item['stats'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, (value as num).toDouble()),
          );
          return ConsumptionStats(
            tag: item['tag'],
            total: statsMap['total'] ?? 0.0,
            averagePerDay: statsMap['average_per_day'] ?? 0.0,
            averagePerUse: statsMap['average_per_use'] ?? 0.0,
          );
        }).toList();

        // Return the parsed analytics data
        return ConsumptionDataAnalyses(
          dates: List<String>.from(responseBody['data']['dates']),
          consumptions: consumptionData,
          stats: statsData,
          allTotal:
              (responseBody['data']['allTotal'] as num?)?.toDouble() ?? 0.0,
          allAveragePerUse:
              (responseBody['data']['allAveragePerUse'] as num?)?.toDouble() ??
                  0.0,
          allAveragePerDay:
              (responseBody['data']['allAveragePerDay'] as num?)?.toDouble() ??
                  0.0,
        );
      } else {
        print('API response status code: ${response.statusCode}');
        print('API response body: ${response.body}');
        throw Exception('Failed to fetch analytics data');
      }
    } catch (e) {
      print('Error fetching analytics data service: $e');
      rethrow;
    }
  }
}
