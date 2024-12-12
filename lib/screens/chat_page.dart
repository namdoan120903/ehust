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

  @override
  void initState() {
    super.initState();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.get_conversation(context, widget.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    List<LastMessage> messages = chatProvider.messages;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.partner.name}', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.red[700],
      ),
      body:chatProvider.isLoading?Center(child: CircularProgressIndicator()):Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      messages[index].message!,
                      style: const TextStyle(color: Colors.white),
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
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (){
                    chatProvider.sendMessage(context, widget.partner.id.toString(), _messageController.text);
                    _messageController.text = "";
                  },
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
