import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/Model/notification_service.dart';
import 'package:watersec_mobileapp_front/ViewModel/loginViewModel.dart';
import 'package:watersec_mobileapp_front/classes/notifications.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  final _loginViewModel = LoginViewModel();

  List<Notifications> _notifications = [];
  bool isLoading = true;

  // New variable to store unread count
  int _unreadCount = 0;

  List<Notifications> get notifications => _notifications;
  int get unreadCount => _unreadCount; // Expose unread count


   void incrementUnreadCount() {
    _unreadCount++;
    notifyListeners();
  }

  Future<void> loadNotifications() async {
    try {
      isLoading = true;
      final accessToken = await _loginViewModel.getAccessToken();
      _notifications = await _notificationService.fetchNotifications(accessToken!);

      // Calculate unread notifications count
      _unreadCount = _notifications.where((n) => n.readAt == null).length;
    } catch (error) {
      print('Error loading notifications: $error');
    } finally {
      isLoading = false;
      notifyListeners(); // Notify listeners to update UI
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final accessToken = await _loginViewModel.getAccessToken();

      // Use the markAsRead method in the notification service
      await _notificationService.markAsRead(notificationId, accessToken!);

      // Update the local notification as read and decrement unread count
      final notification = _notifications.firstWhere((n) => n.id == notificationId);
      if (notification.readAt == null) {
        notification.readAt = DateTime.now().toString();
        _unreadCount = (_unreadCount > 0) ? _unreadCount - 1 : 0;
      }

      notifyListeners(); // Notify listeners to refresh UI
    } catch (error) {
      print('Error marking notification as read: $error');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      final accessToken = await _loginViewModel.getAccessToken();

      // Remove the notification locally and update unread count if needed
      final notification = _notifications.firstWhere((n) => n.id == notificationId);
      if (notification.readAt == null) {
        _unreadCount = (_unreadCount > 0) ? _unreadCount - 1 : 0;
      }
      _notifications.removeWhere((n) => n.id == notificationId);

      // Call the API to delete the notification
      await _notificationService.deleteNotification([notificationId], accessToken!);

      notifyListeners(); // Notify listeners to refresh UI
    } catch (error) {
      print('Error deleting notification: $error');
    }
  }
}
