import 'package:watersec_mobileapp_front/classes/watermeters.dart';

class WaterMeterResponse {
  final List<WaterMeters> watermeterlist;

  WaterMeterResponse({required this.watermeterlist});

  factory WaterMeterResponse.fromJson(List<dynamic> json) {
    return WaterMeterResponse(
      watermeterlist: json.map((e) => WaterMeters.fromJson(e)).toList(),
    );
  }
}