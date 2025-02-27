import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:watersec_mobileapp_front/classes/invoiceResponse.dart';

class InvoiceService {
  final _httpClient = http.Client();
  String urlProd = dotenv.env['URLPRODB2B'] ?? '';
  String stats = dotenv.env['STATS'] ?? '';

  Future<InvoiceResponse> getInvoice(
      String accessToken, List<String> selectedWaterMeterIds) async {
    Uri url;

    // If there are selected water meters, add them as query parameters
    if (selectedWaterMeterIds.isNotEmpty) {
      String locationsQuery = selectedWaterMeterIds
          .map((id) => 'locations%5B%5D=$id') // Encode [] as %5B%5D
          .join('&');
      url = Uri.parse(
          '$urlProd${stats}invoice?start_date=06-09-2023&end_date=06-09-2023&action=validate&$locationsQuery');
    } else {
      // Default URL without water meter selection
      url = Uri.parse(
          '$urlProd${stats}invoice?start_date=06-09-2023&end_date=06-09-2023&action=validate');
    }

    final response = await _httpClient.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return InvoiceResponse(
        sonedeAmount: responseBody['sonede_amount'] ?? 0.0,
        onasAmount: responseBody['onas_amount'] ?? 0.0,
        totalAmount: responseBody['total_amount'] ?? 0.0,
        consumptionPercentLevel:
            responseBody['consumption_percent_level'] ?? 0.0,
        consumptionLevel: responseBody['consumption_level'] ?? 0.0,
      );
    } else {
      throw Exception('Failed to fetch invoice data');
    }
  }
}
