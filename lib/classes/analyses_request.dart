import 'package:intl/intl.dart';

class AnalyticsRequest {
  final DateTime startDate;
  final DateTime endDate;
  final String? action;
  final List<String>? sensors;

  AnalyticsRequest({
    required this.startDate,
    required this.endDate,
    this.action,
    this.sensors,
  });

  Map<String, dynamic> toQueryParameters() {
    final queryParams = <String, dynamic>{
      'start_date': DateFormat('dd-MM-yyyy').format(startDate),
      'end_date': DateFormat('dd-MM-yyyy').format(endDate),
      //'action': action,
    };

    if (sensors != null) {
      queryParams['sensors[]'] = sensors;
    }

    return queryParams;
  }
}
