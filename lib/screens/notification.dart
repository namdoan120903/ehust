import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/provider/AuthProvider.dart';
import 'package:project/screens/myAppBar.dart';
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
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  final int _count = 9;
  bool _isFetchingMore = false;

  late NotificationProvider _notificationProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationProvider =
          Provider.of<NotificationProvider>(context, listen: false);
      notificationProvider.fetchNotifications();
    });

    // Attach scroll listener
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Store the reference to NotificationProvider
    _notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
  }

  @override
  void dispose() {
    if (readNotificationIds.isNotEmpty) {
      _notificationProvider.markAsRead(readNotificationIds);
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetchingMore) {
      _fetchMoreNotifications();
    }
  }

  void _fetchMoreNotifications() async {
    _isFetchingMore = true;
    _currentIndex += _count;
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    await provider.fetchNotifications(index: _currentIndex, count: _count);
    _isFetchingMore = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        check: true,
        title: "EHUST-STUDENT",
      ),
      body: SafeArea(
        child: Consumer<NotificationProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && _currentIndex == 0) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.notifications.isEmpty && _currentIndex == 0) {
              return const Center(child: Text("Không có thông báo nào"));
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: provider.notifications.length + 1,
              itemBuilder: (context, index) {
                if (index == provider.notifications.length) {
                  // Show loading indicator at the bottom
                  return provider.isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink();
                }

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
