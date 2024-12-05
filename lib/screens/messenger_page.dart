import 'package:flutter/material.dart';
import 'chat_page.dart';  // Trang chat mà bạn muốn chuyển tới
import 'create_message_page.dart';  // Trang tạo tin nhắn mới

class MessengerPage extends StatelessWidget {
  final List<Map<String, String>> conversations = [
    {
      "name": "Nguyen Van Tho",
      "message": "Em cảm ơn...",
      "time": "24/6",
      "avatar": "https://hoangthuong.net/wp-content/uploads/2022/05/hinh-anh-cho-con-de-thuong-21.jpg"
    },
    {
      "name": "Tuong Phi Tuan",
      "message": "Oke thankiu",
      "time": "16/6",
      "avatar": "https://i.pravatar.cc/300?img=2"
    },
    {
      "name": "Vu Cong Minh",
      "message": "Vâng ạ",
      "time": "4/6",
      "avatar": "https://i.pravatar.cc/300?img=3"
    },
    {
      "name": "Nguyen Quoc Khanh",
      "message": "Dạ vâng ạ",
      "time": "1/6",
      "avatar": "https://i.pravatar.cc/300?img=4"
    },
    {
      "name": "Nguyen The Nam",
      "message": "Okok",
      "time": "26/5",
      "avatar": "https://i.pravatar.cc/300?img=5"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messenger'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Thêm chức năng tìm kiếm nếu cần
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final convo = conversations[index];
          return ListTile(
            leading: convo['avatar'] != null && convo['avatar']!.isNotEmpty
                ? CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(convo['avatar']!),
              backgroundColor: Colors.grey[200],
            )
                : CircleAvatar(
              radius: 25,
              backgroundColor: Colors.red,
              child: Text(
                convo['name']![0], // Chữ cái đầu tiên
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            title: Text(convo['name']!),
            subtitle: Text(convo['message']!),
            trailing: Text(convo['time']!),
            onTap: () {
              // Khi nhấn vào cuộc trò chuyện, chuyển đến trang chat
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    username: convo['name']!,
                    avatar: convo['avatar']!,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Chuyển đến trang tạo tin nhắn mới khi nhấn vào nút
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateMessagePage()),
          );
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
