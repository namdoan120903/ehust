import 'package:flutter/material.dart';
import 'package:project/model/Conversation.dart';
import 'package:project/model/StudentAccount.dart';
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
  List<StudentAccount> searchResults = []; // Danh sách kết quả tìm kiếm
  TextEditingController searchController = TextEditingController();

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
    final chatProvider = Provider.of<ChatProvider>(context);
    conversations = chatProvider.conversations;
    return Scaffold(
      appBar: MyAppBar(check: true, title: "EHUST-CHAT"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (value) async {
                if (value.isNotEmpty) {
                  await chatProvider.search_student(context, value);
                  setState(() {
                    searchResults = chatProvider.searchStudent; // Thêm vào danh sách tìm kiếm
                  });
                }
              },
            ),
          ),
          if (searchResults.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Kết quả tìm kiếm",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final student = searchResults[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        "${student.firstName![0]}", // Chữ cái đầu của tên
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      "${student.firstName} ${student.lastName} ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                      onTap: () async {
                      print(student.accountId);
                        // Kiểm tra nếu đã có cuộc trò chuyện với student trong danh sách conversations
                        final existingConversation = chatProvider.conversations.where(
                              (conversation) => conversation.partner?.id.toString() == student.accountId.toString(),
                        );
                        if (existingConversation.isNotEmpty) {
                          setState(() {
                            searchResults = [];
                            chatProvider.searchStudent = [];
                            searchController.text = "";
                            conversations = chatProvider.conversations; // Cập nhật danh sách cuộc trò chuyện
                          });
                          // Nếu đã có cuộc trò chuyện, chuyển hướng đến trang chat
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(partner: existingConversation.first.partner!, id: existingConversation.first.id!),
                            ),
                          );
                        } else {
                          // Nếu chưa có, tạo cuộc trò chuyện mới và chuyển hướng
                          await chatProvider.sendMessage(context, student.accountId!, "Xin chào", "");
                          setState(() {
                            searchResults = [];
                            chatProvider.searchStudent = [];
                            searchController.text = "";
                            conversations = chatProvider.conversations; // Cập nhật danh sách cuộc trò chuyện
                          });

                          await chatProvider.get_conversation_list(context);
                          // Lấy cuộc trò chuyện mới tạo và chuyển hướng
                          final newConversation = chatProvider.conversations.firstWhere(
                                (conversation) => conversation.partner?.id.toString() == student.accountId.toString(),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(partner: newConversation.partner!, id: newConversation.id!),
                            ),
                          );
                        }
                      }

                  );
                },
              ),
            ),
          ],
          // Tiêu đề
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Danh sách trò chuyện",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatProvider.conversations.length,
              itemBuilder: (context, index) {
                final conversation = chatProvider.conversations[index];
                final lastMessage = conversation.lastMessage;
                final partner = conversation.partner;

                return ListTile(
                  leading: ClipOval(
                    child: partner?.avatar != null && partner!.avatar!.isNotEmpty
                        ? Image.network(
                      'https://drive.google.com/uc?export=view&id=${partner!.avatar!.substring(partner!.avatar!.indexOf('d/') + 2, partner!.avatar!.indexOf('/view'))}',
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        // Nếu không thể tải ảnh, hiển thị CircleAvatar với chữ cái đầu
                        return CircleAvatar(
                          child: Text(
                            "${partner!.name![0]}", // Hiển thị chữ cái đầu tiên trong tên
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    )
                        : CircleAvatar(
                      child: Text(
                        "${partner!.name![0]}", // Hiển thị chữ cái đầu tiên trong tên nếu không có avatar
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),


                  title: Text(
                    partner!.name!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(lastMessage?.message != null ? lastMessage!.message! : 'Tin nhắn đã bị xóa',),
                  trailing: Text(
                    lastMessage!.createdAt!.substring(11, 16), // Hiển thị giờ và phút
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
          ),
        ],
      ),
    );
  }
}
