import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatefulWidget {
  final String username;
  final String avatar;

  const ChatPage({Key? key, required this.username, required this.avatar}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  late WebSocketChannel _channel;
  late String _channelUrl;

  // Danh sách hội thoại
  List<dynamic> _conversations = [];
  bool _isLoadingConversations = true;

  @override
  void initState() {
    super.initState();
    _channelUrl = 'wss://your-websocket-server-url';
    _connectWebSocket();
    _fetchConversations(); // Gọi API lấy danh sách hội thoại
  }

  // Hàm gọi API lấy danh sách hội thoại
  Future<void> _fetchConversations() async {
    final String apiUrl = 'https://your-backend-url.com/it5023e/get_list_conversation';
    final body = jsonEncode({
      "token": "h76N0F", // Thay bằng token thực tế
      "index": 0,
      "count": 10
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _conversations = data['data'];
          _isLoadingConversations = false;
        });
      } else {
        throw Exception('Lỗi API: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        _isLoadingConversations = false;
      });
      print('Lỗi khi gọi API: $e');
    }
  }

  // Kết nối WebSocket
  void _connectWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse(_channelUrl),
    );

    _channel.stream.listen((message) {
      setState(() {
        _messages.add({
          'text': message,
          'isMe': false,
        });
      });
    });
  }

  // Gửi tin nhắn qua WebSocket
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      _channel.sink.add(_messageController.text);
      setState(() {
        _messages.add({
          'text': _messageController.text,
          'isMe': true,
        });
      });
      _messageController.clear();
    }
  }

  // Chọn ảnh từ thiết bị
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print('Picked image: ${pickedFile.path}');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.avatar)),
            SizedBox(width: 10),
            Text(widget.username),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoadingConversations
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                final conversation = _conversations[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(conversation['partner']['avatar']),
                  ),
                  title: Text(conversation['partner']['name']),
                  subtitle: Text(
                    conversation['lastMessage'],
                    style: TextStyle(
                      fontWeight: conversation['numNewMessage'] > 0 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: conversation['numNewMessage'] > 0
                      ? CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Text(
                      '${conversation['numNewMessage']}',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                      : null,
                  onTap: () {
                    print('Chọn hội thoại: ${conversation['id']}');
                  },
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(icon: Icon(Icons.add_circle_sharp), onPressed: _pickImage),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
