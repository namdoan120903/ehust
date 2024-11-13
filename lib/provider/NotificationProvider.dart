import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class NotificationProvider with ChangeNotifier {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = false;
  String? token;
  int unreadCount = 0; // Store unread notification count
  final secureStorage = FlutterSecureStorage();

  List<Map<String, dynamic>> get notifications => _notifications;
  bool get isLoading => _isLoading;

  // Fetch notifications (get_notifications API)
  Future<void> fetchNotifications({int index = 0, int count = 10}) async {
    _isLoading = true;
    notifyListeners();
    token = await secureStorage.read(key: 'token');

    try {
      final response = await http.post(
        Uri.parse('http://160.30.168.228:8080/it5023e/get_notifications'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"token": token, "index": index, "count": count}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['notifications'] != null) {
          _notifications =
              List<Map<String, dynamic>>.from(data['notifications']);
        }
      } else {
        print("Failed to fetch notifications: ${response.body}");
      }
    } catch (error) {
      print("Error fetching notifications: $error");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Mark notifications as read (mark_notification_as_read API)
  Future<void> markAsRead(List<int> notificationIds) async {
    try {
      token = await secureStorage.read(key: 'token');
      final response = await http.post(
        Uri.parse(
            'http://160.30.168.228:8080/it4788/mark_notification_as_read'),
        headers: {"Content-Type": "application/json"},
        body:
            json.encode({"token": token, "notification_ids": notificationIds}),
      );

      if (response.statusCode == 200) {
        _notifications
            .removeWhere((notif) => notificationIds.contains(notif['id']));
        notifyListeners();
      } else {
        print("Failed to mark notifications as read: ${response.body}");
      }
    } catch (error) {
      print("Error marking notifications as read: $error");
    }
  }

  // Fetch unread notification count
  Future<void> getUnreadNotificationCount() async {
    token = await secureStorage.read(key: 'token');

    try {
      final response = await http.post(
        Uri.parse(
            'http://160.30.168.228:8080/it5023e/get_unread_notification_count'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"token": token}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        unreadCount = data['unread_notification_count'] ?? 0;
        notifyListeners(); // Notify to update the UI
      } else {
        print("Failed to get unread notification count: ${response.body}");
      }
    } catch (error) {
      print("Error getting unread notification count: $error");
    }
  }
}
