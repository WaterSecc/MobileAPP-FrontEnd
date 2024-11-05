class SensorData {
  final int globalConsumptionThreshold;
  final List<SensorConsumptionThreshold> sensorsConsumptionsThresholds;

  SensorData({
    required this.globalConsumptionThreshold,
    required this.sensorsConsumptionsThresholds,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      globalConsumptionThreshold: json['globalConsumptionThreshold'],
      sensorsConsumptionsThresholds:
          (json['sensorsConsumptionsThresholds'] as List)
              .map((sensor) => SensorConsumptionThreshold.fromJson(sensor))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'globalConsumptionThreshold': globalConsumptionThreshold,
      'sensorsConsumptionsThresholds': sensorsConsumptionsThresholds
          .map((sensor) => sensor.toJson())
          .toList(),
    };
  }

  // Add copyWith method to allow partial updates of the object
  SensorData copyWith({
    int? globalConsumptionThreshold,
    List<SensorConsumptionThreshold>? sensorsConsumptionsThresholds,
  }) {
    return SensorData(
      globalConsumptionThreshold:
          globalConsumptionThreshold ?? this.globalConsumptionThreshold,
      sensorsConsumptionsThresholds:
          sensorsConsumptionsThresholds ?? this.sensorsConsumptionsThresholds,
    );
  }
}

class SensorConsumptionThreshold {
  final String identifier;
  final String name;
  final int threshold;
  final int duration;
  final int consumption;
  final int mainCategoryId;
  final int subCategoryId;
  final String tag;

  SensorConsumptionThreshold({
    required this.identifier,
    required this.name,
    required this.threshold,
    required this.duration,
    required this.consumption,
    required this.mainCategoryId,
    required this.subCategoryId,
    required this.tag,
  });

  factory SensorConsumptionThreshold.fromJson(Map<String, dynamic> json) {
    return SensorConsumptionThreshold(
      identifier: json['identifier'],
      name: json['name'],
      threshold: json['threshold'],
      duration: json['duration'],
      consumption: json['consumption'],
      mainCategoryId: json['mainCategoryId'] != null
          ? json['mainCategoryId'] as int
          : 0, // Handling null case,
      subCategoryId: json['subCategoryId'] != null
          ? json['subCategoryId'] as int
          : 0, // Handling null case,,
      tag: json['tag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'name': name,
      'threshold': threshold,
      'duration': duration,
      'consumption': consumption,
      'mainCategoryId': mainCategoryId,
      'subCategoryId': subCategoryId,
      'tag': tag,
    };
  }

  // Add copyWith method to allow partial updates of the object
  SensorConsumptionThreshold copyWith({
    String? identifier,
    String? name,
    int? threshold,
    int? duration,
    int? consumption,
    int? mainCategoryId,
    int? subCategoryId,
    String? tag,
  }) {
    return SensorConsumptionThreshold(
      identifier: identifier ?? this.identifier,
      name: name ?? this.name,
      threshold: threshold ?? this.threshold,
      duration: duration ?? this.duration,
      consumption: consumption ?? this.consumption,
      mainCategoryId: mainCategoryId ?? this.mainCategoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      tag: tag ?? this.tag,
    );
  }
}
