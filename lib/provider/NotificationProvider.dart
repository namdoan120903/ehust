import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project/Constant.dart';
import 'package:project/provider/AuthProvider.dart';

class NotificationProvider with ChangeNotifier {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = false;
  String? token;
  int unreadCount = 0; // Store unread notification count
  final secureStorage = FlutterSecureStorage();
  final authProvider = AuthProvider();

  List<Map<String, dynamic>> get notifications => _notifications;
  bool get isLoading => _isLoading;

  NotificationProvider() {
    getUnreadNotificationCount();
  }

  // Fetch notifications (get_notifications API)
  Future<void> fetchNotifications({int index = 0, int count = 9}) async {
    _isLoading = true;
    if (index == 0) _notifications = [];
    notifyListeners();
    token = await secureStorage.read(key: 'token');
    print("Start get notifications");
    print("Body: " +
        json.encode(
            {"token": token, "index": index, "count": count}).toString());
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/get_notifications'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"token": token, "index": index, "count": count}),
      );
      print("response.statusCode: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        print("data: " + data.toString());
        if (data['data'] != null) {
          _notifications.addAll(List<Map<String, dynamic>>.from(data['data']));
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
      print("Start markAsRead: " +
          json.encode({
            "token": token,
            "notification_ids": notificationIds
          }).toString());
      for (int id in notificationIds) {
        final response = await http.post(
          Uri.parse('${Constant.baseUrl}/it5023e/mark_notification_as_read'),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"token": token, "notification_id": id}),
        );

        print(id.toString() +
            " response.statusCode " +
            response.statusCode.toString());
      }
      await getUnreadNotificationCount();
      notifyListeners();
    } catch (error) {
      print("Error marking notifications as read: $error");
    }
  }

  // Fetch unread notification count
  Future<void> getUnreadNotificationCount() async {
    token = await secureStorage.read(key: 'token');
    //unreadCount = 0;
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/get_unread_notification_count'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"token": token}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("UnreadCountData: " + data.toString());
        unreadCount = data['data'] ?? 0;
        notifyListeners(); // Notify to update the UI
      } else {
        print("Failed to get unread notification count: ${response.body}");
      }
    } catch (error) {
      print("Error getting unread notification count: $error");
    }
  }

  // Send notification (send_notification API)
  Future<void> sendNotification({
    required String message,
    required String toUser,
    required String type,
    File? image, // Optional image file
  }) async {
    String? token = await secureStorage.read(key: 'token');
    print("Start sending notification...");
    print("Token: $token");
    print("Message: $message");
    print("To User: $toUser");
    print("Type: $type");

    try {
      // Prepare the multipart request
      final uri = Uri.parse('${Constant.baseUrl}/it5023e/send_notification');
      final request = http.MultipartRequest('POST', uri);

      // Add fields
      request.fields['token'] = token ?? '';
      request.fields['message'] = message;
      request.fields['toUser'] = toUser;
      request.fields['type'] = type;

      // Add optional image if provided
      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          image.path,
        ));
      }

      // Send the request
      final response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        print("Notification sent successfully!");
      } else {
        print("Failed to send notification: ${response.statusCode}");
        print(await response.stream.bytesToString());
      }
    } catch (error) {
      print("Error sending notification: $error");
    }
  }
}
