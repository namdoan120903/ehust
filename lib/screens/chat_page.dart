import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatPage extends StatefulWidget {
  final String username;
  final String avatar;
  final String conversationId;
  final String partnerId;

  const ChatPage({
    Key? key,
    required this.username,
    required this.avatar,
    required this.conversationId,
    required this.partnerId,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  late WebSocketChannel _channel;
  late String _channelUrl;

  bool _isLoadingMessages = true;

  @override
  void initState() {
    super.initState();
    _channelUrl = 'ws://localhost:8080';
    _connectWebSocket();
    _fetchConversation();
  }

  Future<void> _fetchConversation() async {
    final String apiUrl = 'http://localhost:8080/it5023e/get_conversation';
    final body = jsonEncode({
      "token": "h76N0F",
      "index": 0,
      "count": 10,
      "conversation_id": widget.conversationId,
      "partner_id": widget.partnerId,
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _messages = List<Map<String, dynamic>>.from(data['data']);
            _isLoadingMessages = false;
          });
        } else {
          throw Exception('Lỗi từ server: ${data['message']}');
        }
      } else {
        throw Exception('Lỗi API: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        _isLoadingMessages = false;
      });
      print('Lỗi khi gọi API: $e');
    }
  }

  void _connectWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse(_channelUrl),
    );

    _channel.stream.listen((message) {
      final response = jsonDecode(message);

      if (response['status'] == 'received') {
        setState(() {
          for (var msg in _messages) {
            if (msg['status'] == 'sending') {
              msg['status'] = 'sent';
            }
          }
        });
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final message = _messageController.text;

      setState(() {
        _messages.add({
          'text': message,
          'isMe': true,
          'status': 'sending',
        });
      });

      _channel.sink.add(message);
      _messageController.clear();
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print('Picked image: ${pickedFile.path}');
    }
  }

  // Hàm gọi API để xóa tin nhắn
  Future<void> _deleteMessage(String messageId) async {
    final String apiUrl = 'http://localhost:8080/it5023e/delete_message';
    final String token = 'h76N0F';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "token": token,
          "message_id": messageId,
          "conversation_id": widget.conversationId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            _messages.removeWhere((msg) => msg['id'] == messageId); // Xóa tin nhắn khỏi danh sách (Nhấn giữ sẽ xóa tn)
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Xóa tin nhắn thành công')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: ${data['error']}')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi API: ${response.reasonPhrase}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi khi gọi API: $e')));
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
            CircleAvatar(backgroundImage: CachedNetworkImageProvider(widget.avatar)),
            SizedBox(width: 10),
            Text(widget.username),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoadingMessages
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Align(
                    alignment: message['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                    child: GestureDetector(
                      onLongPress: () {
                        // Hiển thị hộp thoại xác nhận xóa tin nhắn
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Xóa tin nhắn'),
                            content: Text('Bạn có chắc chắn muốn xóa tin nhắn này không?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _deleteMessage(message['id']); // Gọi API để xóa tin nhắn
                                },
                                child: Text('Xóa'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: message['isMe'] ? Colors.blue : Colors.grey,
                        child: Row(
                          children: [
                            Text(message['text'], style: TextStyle(color: Colors.white)),
                            if (message['isMe'] && message['status'] == 'sending')
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            if (message['isMe'] && message['status'] == 'sent')
                              Icon(Icons.check, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
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
