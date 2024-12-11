import 'package:flutter/material.dart';
import 'chat_page.dart';  // Trang chat mà bạn muốn chuyển tới
import 'create_message_page.dart';  // Trang tạo tin nhắn mới
import 'dart:convert'; // Để làm việc với JSON
import 'package:http/http.dart' as http;

class MessengerPage extends StatefulWidget {
  @override
  _MessengerPageState createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  // Danh sách hội thoại mẫu ban đầu
  List<Map<String, dynamic>> conversations = [
    {
      "Partner": {"name": "Nguyen Van Tho", "avatar": "https://i.pravatar.cc/300?img=1", "id": "1"},
      "LastMessage": "Em cảm ơn...",
      "numNewMessage": 1,
      "id": "convo_1",
    },
    {
      "Partner": {"name": "Tuong Phi Tuan", "avatar": "https://i.pravatar.cc/300?img=2", "id": "2"},
      "LastMessage": "Oke thankiu",
      "numNewMessage": 0,
      "id": "convo_2",
    },
    {
      "Partner": {"name": "Vu Cong Minh", "avatar": "https://i.pravatar.cc/300?img=3", "id": "3"},
      "LastMessage": "Vâng ạ",
      "numNewMessage": 2,
      "id": "convo_3",
    },
  ];

  bool _isLoading = true; // Biến để kiểm tra trạng thái đang tải dữ liệu

  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

  // Hàm gọi API để lấy danh sách hội thoại
  Future<void> _fetchConversations() async {
    const String apiUrl = 'http://localhost:8080/it5023e/get_list_conversation'; // Đổi URL API thực tế
    const String token = 'h76N0F'; // Token của bạn

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "token": token,
          "index": "0", // Đánh số thứ tự trang
          "count": "10" // Số lượng hội thoại cần lấy
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // Cập nhật danh sách hội thoại với dữ liệu API trả về
          conversations = List<Map<String, dynamic>>.from(data['data']);
          _isLoading = false; // Đánh dấu đã tải xong
        });
      } else {
        throw Exception('Lỗi API: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Lỗi khi gọi API: $e');
    }
  }

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
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Hiển thị khi đang tải dữ liệu
          : ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final convo = conversations[index];
          final bool hasNewMessages = convo['numNewMessage'] > 0;

          return ListTile(
            leading: convo['Partner']['avatar'] != null
                ? CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(convo['Partner']['avatar']),
              backgroundColor: Colors.grey[200],
            )
                : CircleAvatar(
              radius: 25,
              backgroundColor: Colors.red,
              child: Text(
                convo['Partner']['name'][0], // Chữ cái đầu tiên
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            title: Text(convo['Partner']['name']),
            subtitle: Text(
              convo['LastMessage'],
              style: TextStyle(
                fontWeight: hasNewMessages ? FontWeight.bold : FontWeight.normal, // Màu đậm cho tin nhắn chưa đọc
              ),
            ),
            trailing: hasNewMessages
                ? CircleAvatar(
              backgroundColor: Colors.red,
              child: Text(
                '${convo['numNewMessage']}',
                style: TextStyle(color: Colors.white),
              ),
            )
                : null,
            onTap: () {
              // Khi nhấn vào cuộc trò chuyện, chuyển đến trang chat
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    username: convo['Partner']['name'],
                    avatar: convo['Partner']['avatar'],
                    conversationId: convo['id'],  // Truyền conversationId
                    partnerId: convo['Partner']['id'],  // Truyền partnerId
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
