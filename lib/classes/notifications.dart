class NotificationData {
  final String type;
  final String device;
  final String identifier;
  final String description;
  final String message;

  NotificationData({
    required this.type,
    required this.device,
    required this.identifier,
    required this.description,
    required this.message,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      type: json['type'],
      device: json['device'],
      identifier: json['identifier'],
      description: json['description'],
      message: json['message'],
    );
  }

  // Convert NotificationData object to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'device': device,
      'identifier': identifier,
      'description': description,
      'message': message,
    };
  }
}

class Notifications {
  final String id;
  final NotificationData data;
  String? readAt;
  final String createdAt;
  final String? deletedAt;

  Notifications({
    required this.id,
    required this.data,
    this.readAt,
    required this.createdAt,
    required this.deletedAt,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['id'],
      data: NotificationData.fromJson(json['data']),
      readAt: json['read_at'],
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'],
    );
  }

  // Convert Notifications object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data.toJson(),
      'read_at': readAt,
      'created_at': createdAt,
      'deleted_at': deletedAt,
    };
  }
}
