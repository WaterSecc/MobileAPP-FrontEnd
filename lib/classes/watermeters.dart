class WaterMeters {
  final String identifier;
  final String name;

  WaterMeters({required this.identifier, required this.name});

  factory WaterMeters.fromJson(Map<String, dynamic> json) {
    return WaterMeters(
      identifier: json['identifier'],
      name: json['name'],
    );
  }
}