import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String subject;
  final String date;
  final String description;

  const NotificationCard({
    super.key,
    required this.subject,
    required this.date,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        title:
            Text(subject, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 8),
            Text(date,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        trailing: TextButton(
          onPressed: () {},
          child: Text('Chi tiết', style: TextStyle(color: Colors.red[700])),
        ),
      ),
    );
  }
}
