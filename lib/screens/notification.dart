import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/provider/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../provider/NotificationProvider.dart';
import '../components/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<int> readNotificationIds = []; // Track IDs of read notifications

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    provider.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (readNotificationIds.isNotEmpty) {
              // Log the action
              print("Marking notifications as read: $readNotificationIds");
              // We use context here only after confirming the widget is still mounted
              Provider.of<NotificationProvider>(context, listen: false)
                  .markAsRead(readNotificationIds);
            } else {
              print(
                  "readNotificationIds is empty. No notifications to mark as read.");
            }
            Navigator.of(context).pop();
          },
        ),
        flexibleSpace: const Center(
          child: Text("Thông báo",
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        backgroundColor: Colors.red[700],
      ),
      body: SafeArea(
        child: Consumer<NotificationProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.notifications.isEmpty) {
              return const Center(child: Text("Không có thông báo nào"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: provider.notifications.length,
              itemBuilder: (context, index) {
                final notification = provider.notifications[index];
                return NotificationCard(
                  id: notification["id"] ?? 0,
                  type: notification["type"].toString() ?? "No type",
                  sent_time: notification["sent_time"] ?? "No date",
                  message: notification["message"] ?? "No message",
                  status: notification["status"].toString(),
                  onRead: () {
                    setState(() {
                      if (notification["status"] == "UNREAD") {
                        notification["status"] = "READ";
                        readNotificationIds.add(notification["id"]);
                      }
                    });
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
