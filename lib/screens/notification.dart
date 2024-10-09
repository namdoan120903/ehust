import 'package:flutter/material.dart';
import 'package:project/components/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      "subject": "Triết học Mác - Lênin",
      "date": "27/08/2024",
      "description": "Đã có điểm môn cuối kỳ Triết học Mác - Lênin"
    },
    {
      "subject": "Object-oriented Programming",
      "date": "27/07/2024",
      "description": "Đã có điểm môn cuối kỳ Object-oriented Programming"
    },
    {
      "subject": "Object-oriented Programming",
      "date": "27/07/2024",
      "description": "Đã có điểm môn cuối kỳ Object-oriented Programming"
    },
    {
      "subject": "Object-oriented Programming",
      "date": "27/07/2024",
      "description": "Đã có điểm môn cuối kỳ Object-oriented Programming"
    },
    {
      "subject": "Object-oriented Programming",
      "date": "27/07/2024",
      "description": "Đã có điểm môn cuối kỳ Object-oriented Programming"
    },
    {
      "subject": "Object-oriented Programming",
      "date": "27/07/2024",
      "description": "Đã có điểm môn cuối kỳ Object-oriented Programming"
    },
    {
      "subject": "Object-oriented Programming",
      "date": "27/07/2024",
      "description": "Đã có điểm môn cuối kỳ Object-oriented Programming"
    },
    {
      "subject": "Object-oriented Programming",
      "date": "27/07/2024",
      "description": "Đã có điểm môn cuối kỳ Object-oriented Programming"
    },
    {
      "subject": "Object-oriented Programming",
      "date": "27/07/2024",
      "description": "Đã có điểm môn cuối kỳ Object-oriented Programming"
    },
    {
      "subject": "Object-oriented Programming",
      "date": "27/07/2024",
      "description": "Đã có điểm môn cuối kỳ Object-oriented Programming"
    },
    {
      "subject": "Object-oriented Programming",
      "date": "27/07/2024",
      "description": "Đã có điểm môn cuối kỳ Object-oriented Programming"
    },
    {
      "subject": "Object-oriented Programming",
      "date": "27/07/2024",
      "description": "Đã có điểm môn cuối kỳ Object-oriented Programming"
    },
    {
      "subject": "Object-oriented Programming",
      "date": "27/07/2024",
      "description": "Đã có điểm môn cuối kỳ Object-oriented Programming"
    }
    // Add more notifications as needed
  ];

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context)
                  .pop(); // Add this if you want to pop the page
            },
          ),
          flexibleSpace: const Center(
            child: Text("Thông báo",
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          backgroundColor: Colors.red[700],
        ),
        body: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationCard(
                subject: notification["subject"]!,
                date: notification["date"]!,
                description: notification["description"]!,
              );
            },
          ),
        ));
  }
}
