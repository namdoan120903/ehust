import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  final String username;
  final String avatar;

  ChatPage({required this.username, required this.avatar});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = []; // Danh sách các tin nhắn
  late ImagePicker _imagePicker;  // Khởi tạo ImagePicker
  File? _image;  // Biến để lưu ảnh chọn

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();  // Khởi tạo đối tượng ImagePicker
  }

  // Hàm gửi tin nhắn
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text,
          'isMe': true, // Tin nhắn của người dùng
        });
      });
      _messageController.clear(); // Xóa ô nhập sau khi gửi
    }
  }

  // Hàm chụp ảnh
  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera); // Chụp ảnh
    if (image != null) {
      setState(() {
        _image = File(image.path); // Lưu ảnh vào biến _image
        _messages.add({
          'text': 'Đã gửi ảnh', // Tin nhắn dạng ảnh
          'isMe': true, // Tin nhắn của người dùng
          'image': _image!.path, // Đính kèm ảnh
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.avatar),
            ),
            SizedBox(width: 10),
            Text(widget.username),
          ],
        ),
      ),
      body: Column(
        children: [
          // Danh sách tin nhắn
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: message['isMe'] ? Colors.blue[200] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: message['isMe'] ? Colors.blue : Colors.grey, // Viền khác nhau cho mỗi tin nhắn
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          message['image'] != null // Nếu có ảnh
                              ? Image.file(File(message['image']))
                              : Text(
                            message['text']!,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Phần nhập tin nhắn
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add_circle_sharp),
                  onPressed: () {
                    // Thêm chức năng gửi file
                  },
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: _pickImage, // Chụp ảnh khi nhấn vào nút camera
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage, // Gửi tin nhắn
                ),
              ],
            ),
          ),

          // Hiển thị ảnh đã chụp (nếu có)
          if (_image != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(_image!), // Hiển thị ảnh đã chụp
            ),
        ],
      ),
    );
  }
}
