import 'package:watersec_mobileapp_front/classes/consumption.dart';
import 'package:watersec_mobileapp_front/classes/consumption_statsResponse.dart';

class ConsumptionDataAnalyses {
  final List<String> dates;
  final List<Consumption> consumptions;
  final List<ConsumptionStats> stats;
  final double allTotal;
  final double allAveragePerUse;
  final double allAveragePerDay;

  ConsumptionDataAnalyses({
    required this.dates,
    required this.consumptions,
    required this.stats,
    required this.allTotal,
    required this.allAveragePerUse,
    required this.allAveragePerDay,
  });

}