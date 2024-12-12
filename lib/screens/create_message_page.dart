import 'package:flutter/material.dart';
import 'chat_page.dart';  // Import trang ChatPage

class CreateMessagePage extends StatefulWidget {
  @override
  _CreateMessagePageState createState() => _CreateMessagePageState();
}

class _CreateMessagePageState extends State<CreateMessagePage> {
  final TextEditingController _searchController = TextEditingController();

  // Danh sách người dùng mẫu với avatar
  List<Map<String, String>> suggestedUsers = [
    {
      "name": "Nguyen Van Tho",
      "email": "tho.nguyen@example.com",
      "avatar": "https://hoangthuong.net/wp-content/uploads/2022/05/hinh-anh-cho-con-de-thuong-21.jpg",
    },
    {
      "name": "Tuong Phi Tuan",
      "email": "tuan.tu@example.com",
      "avatar": "https://i.pravatar.cc/300?img=2",
    },
    {
      "name": "Vu Cong Minh",
      "email": "minh.vu@example.com",
      "avatar": "https://i.pravatar.cc/300?img=3",
    },
    {
      "name": "Nguyen Quoc Khanh",
      "email": "khanh.nguyen@example.com",
      "avatar": "https://i.pravatar.cc/300?img=4",
    },
    {
      "name": "Nguyen The Nam",
      "email": "nam.nguyen@example.com",
      "avatar": "https://i.pravatar.cc/300?img=5",
    },
  ];

  List<Map<String, String>> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    filteredUsers = suggestedUsers; // Khởi tạo danh sách người dùng ban đầu
  }

  void _filterUsers(String query) {
    final filteredList = suggestedUsers
        .where((user) =>
    user["name"]!.toLowerCase().contains(query.toLowerCase()) ||
        user["email"]!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredUsers = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tạo tin nhắn mới"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tìm kiếm
            TextField(
              controller: _searchController,
              onChanged: _filterUsers,
              decoration: InputDecoration(
                labelText: "Tìm kiếm: tên người dùng, email, nhóm...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Danh sách đề xuất người dùng
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(user["avatar"]!),
                      backgroundColor: Colors.grey[200],
                    ),
                    title: Text(user["name"]!),
                    subtitle: Text(user["email"]!),
                    onTap: () {
                      // Chuyển đến trang chat khi nhấn vào người dùng
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            username: user["name"]!,
                            avatar: user["avatar"]!,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
