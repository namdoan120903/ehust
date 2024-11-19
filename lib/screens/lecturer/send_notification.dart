import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/provider/NotificationProvider.dart'; // Update with your actual path to NotificationProvider

class SendNotificationScreen extends StatefulWidget {
  final String userName;

  const SendNotificationScreen({super.key, required this.userName});

  @override
  _SendNotificationScreenState createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedType;
  String message = "";

  // Available notification types
  final List<String> notificationTypes = [
    'ABSENCE',
    'ACCEPT_ABSENCE_REQUEST',
    'REJECT_ABSENCE_REQUEST',
    'ASSIGNMENT_GRADE',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        flexibleSpace: const Center(
          child: Text("Thông báo",
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        backgroundColor: Colors.red[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TO field (userName)
              TextFormField(
                initialValue: widget.userName,
                decoration: const InputDecoration(
                  labelText: 'TO',
                  hintText: 'Username',
                ),
                readOnly: true,
                enabled: false,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Type dropdown
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  hintText: 'Select Notification Type',
                ),
                items: notificationTypes
                    .map((type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a notification type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Message text field
              TextFormField(
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  hintText: 'Enter your message here',
                ),
                onChanged: (value) {
                  setState(() {
                    message = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Send Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Send notification API call
                    context.read<NotificationProvider>().sendNotification(
                          message: message,
                          userName: widget.userName,
                          type: selectedType!,
                        );

                    // Show success message and pop the screen
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notification sent!')));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Send',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.red[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
