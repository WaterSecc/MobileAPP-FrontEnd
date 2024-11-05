import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:watersec_mobileapp_front/classes/notifications.dart';

class NotificationService {
  String urlProd = dotenv.env['URLPRODB2B'] ?? '';
  String notif = dotenv.env['NOTIFICATIONS'] ?? '';

  Future<List<Notifications>> fetchNotifications(String accessToken,) async {
    final url = Uri.parse(urlProd + notif);
    final response = await http.get(url,
    headers: {
        'Authorization': 'Bearer $accessToken',
      },);
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => Notifications.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<void> markAsRead(String notificationId, String accessToken) async {
  // Construct URL with the notification ID
  final url = Uri.parse('$urlProd$notif/$notificationId');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print('Notification marked as read');
  } else {
    print('Failed to mark notification as read: ${response.body}');
    throw Exception('Failed to mark notification as read');
  }
}



  Future<void> deleteNotification(List<String> notificationIds, String accessToken) async {
  final url = Uri.parse(urlProd + notif);
  
  final response = await http.delete(
    url,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'notifications': notificationIds
    }),
  );

  if (response.statusCode == 204) {
    print('Notification(s) deleted successfully');
  } else {
    print('Failed to delete notification(s): ${response.body}');
    throw Exception('Failed to delete notification(s)');
  }
}

}
