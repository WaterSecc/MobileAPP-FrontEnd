import 'package:watersec_mobileapp_front/classes/consumption.dart';

class ConsumptionDataResponse {
  final List<String> dates;
  final List<Consumption> consumptions;
  final num total;

  ConsumptionDataResponse({
    required this.dates,
    required this.consumptions,
    required this.total,
  });
}