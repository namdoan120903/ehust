import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final int id;
  final String type;
  final String sent_time;
  final String message;
  final String status;
  final VoidCallback onRead; // Add a callback for marking as read

  const NotificationCard({
    super.key,
    required this.type,
    required this.sent_time,
    required this.message,
    required this.id,
    required this.status,
    required this.onRead, // Add required parameter
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: status == 'UNREAD' ? Colors.yellow[100] : Colors.white,
      child: ListTile(
        title: Text(type, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 8),
            Text(sent_time,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        trailing: TextButton(
          onPressed: () {
            if (status == 'UNREAD') onRead(); // Trigger callback when UNREAD
          },
          child: Text('Chi tiết', style: TextStyle(color: Colors.red[700])),
        ),
      ),
    );
  }
}
