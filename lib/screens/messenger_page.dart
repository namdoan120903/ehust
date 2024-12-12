import 'package:flutter/material.dart';
import 'package:project/model/Conversation.dart';
import 'package:project/provider/ChatProvider.dart';
import 'package:project/screens/myAppBar.dart';
import 'package:provider/provider.dart';

import '../provider/AuthProvider.dart';
import 'chat_page.dart';

class MessengerPage extends StatefulWidget {
  MessengerPage({super.key});

  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {

  List<Conversation> conversations = [];

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.connect(authProvider.user.id!);
    chatProvider.get_conversation_list(context);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    conversations = chatProvider.conversations;
    return Scaffold(
      appBar: MyAppBar(check: true, title: "EHUST-CHAT"),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          final lastMessage = conversation.lastMessage;
          final partner = conversation.partner;

          return ListTile(
            leading: CircleAvatar(
              child: Text(
                partner!.name![0], // Hiển thị chữ cái đầu của tên người gửi
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              partner.name!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(lastMessage!.message!),
            trailing: Text(
              lastMessage.createdAt!.substring(11, 16), // Hiển thị giờ và phút
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onTap: () {
              // Điều hướng tới màn hình chat
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(partner: partner, id: conversation.id!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
