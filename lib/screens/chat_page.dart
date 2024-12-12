import 'package:flutter/material.dart';
import 'package:project/model/Conversation.dart';
import 'package:provider/provider.dart';

import '../provider/ChatProvider.dart';

class ChatPage extends StatefulWidget {
  final Partner partner;
  final int id;
  const ChatPage({super.key, required this.partner, required this.id});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.get_conversation(context, widget.id.toString());
  }
  @override
  void dispose() {
    _scrollController.dispose(); // Dispose ScrollController when widget is disposed
    super.dispose();
  }

  void _showDeleteConfirmationDialog(String messageId, String conId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa tin nhắn?'),
          content: Text('Bạn có chắc chắn muốn xóa tin nhắn này?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                final chatProvider = Provider.of<ChatProvider>(context, listen: false);
                chatProvider.delete_message(context, messageId, conId);
                Navigator.of(context).pop(); // Đóng dialog
                FocusScope.of(context).unfocus(); // Bỏ focus khỏi TextField (ẩn bàn phím)
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    List<LastMessage> messages = chatProvider.messages;

    if (messages.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.partner.name}', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.red[700],
      ),
      body:GestureDetector(
        onTap: () {
          // Ẩn bàn phím khi người dùng chạm vào màn hình ngoài TextField
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(// Đảo ngược thứ tự tin nhắn
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[messages.length - index - 1];
                  bool isSender = message.sender!.id == widget.partner.id;

                  return GestureDetector(
                    onLongPress: () {
                      _showDeleteConfirmationDialog(message.messageId!, widget.id.toString() );
                    },
                    child: Align(
                      alignment: isSender ? Alignment.centerLeft : Alignment.centerRight, // Tin nhắn của bạn ở trái, của đối tác ở phải
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: message.message != null
                              ? (isSender ? Colors.blueAccent : Colors.greenAccent) // Color based on sender
                              : Colors.grey, // If message is null, use gray color
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message.message != null ? message.message! : 'Tin nhắn đã bị xóa',
                          style: TextStyle(
                            color: message.message != null ? Colors.white : Colors.black, // Change text color for deleted message
                          ),
                        ),
                      ),
                    ),

                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode, // Gắn FocusNode vào TextField
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (text) {
                        // Mỗi khi có thay đổi trong TextField, cuộn xuống cuối
                        if (_scrollController.hasClients) {
                          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                        }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      chatProvider.sendMessage(context, widget.partner.id.toString(), _messageController.text, widget.id.toString());
                      _messageController.text = "";
                      FocusScope.of(context).unfocus();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      });
                    },
                    icon: const Icon(Icons.send, color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
