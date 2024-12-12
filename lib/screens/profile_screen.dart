import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project/provider/ChatProvider.dart';
import 'package:project/screens/myAppBar.dart';
import 'package:provider/provider.dart';

import '../provider/AuthProvider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();
  final nameController = TextEditingController();
  File? _file;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: MyAppBar(
        check: true,
        title: "EHUST-STUDENT",
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Căn chỉnh hàng trên cùng
                  children: [
                    authProvider.user.avatar != null &&
                            authProvider.user.avatar != ""
                        ?ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Tạo viền bo với bán kính 20
                      child: Image.network(
                        'https://drive.google.com/uc?export=view&id=${authProvider.fileId}',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover, // Cắt ảnh để vừa với kích thước
                        errorBuilder: (context, error, stackTrace) {
                          // Widget thay thế khi lỗi
                          return SizedBox.shrink(); // Widget rỗng
                        },
                      ),
                    )
                        : Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                    const SizedBox(
                        width: 20), // Khoảng cách giữa hình vuông và chữ
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tên Sinh Viên:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          '${authProvider.user.ho} ${authProvider.user.ten}',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 8), // Khoảng cách giữa các dòng text
                        Text(
                          "Chức vụ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          '${authProvider.user.role}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Divider(),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tên tài khoản:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      '${authProvider.user.name}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Email:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      '${authProvider.user.email}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Trạng thái tài khoản:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      '${authProvider.user.status}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Khoa/Viện:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Text(
                      'CNTT',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Lớp:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Text(
                      'Khoa học máy tính',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showChangeUserInfoDialog(context, authProvider, nameController);
                      },
                      child: Text(
                        'Thay đổi TT',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreenAccent,
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showChangePasswordDialog(context, authProvider);
                      },
                      child: Text(
                        'Đổi mật khẩu',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreenAccent,
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        chatProvider.disconnect();
                        authProvider.logout(context);
                        Navigator.pushNamed(context, '/signin');
                      },
                      child: Text(
                        'Đăng xuất',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),

    );
  }

  void _showChangePasswordDialog(
      BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thay đổi mật khẩu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPassController,
                decoration: InputDecoration(labelText: 'Nhập mật khẩu cũ'),
              ),
              TextField(
                controller: newPassController,
                decoration: InputDecoration(labelText: 'Nhập mật khẩu mới'),
              ),
              TextField(
                controller: confirmPassController,
                decoration: InputDecoration(labelText: 'Xác nhận mật khẩu'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng popup
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newPassController.text == confirmPassController.text) {
                  authProvider.changePassword(
                      context, oldPassController.text, newPassController.text);
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showChangeUserInfoDialog(
      BuildContext context, AuthProvider authProvider, TextEditingController nameController) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text('Đổi ảnh đại diện'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 8),
                    _file != null
                        ? Text("Tệp đã chọn: ${_file!.path.split('/').last}")
                        : Text("Chưa chọn tệp"),
                    SizedBox(height: 8),
                    if(authProvider.isLoading) CircularProgressIndicator(),
                    OutlinedButton(
                      onPressed: () async {
                        // Mở hộp thoại chọn tệp
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();
                        if (result != null) {
                          setState(() {
                            _file = File(result.files.single.path!);
                          });
                        };
                      },
                      child: Text('Tải ảnh lên'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Đóng popup
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      print(nameController.text);
                      print(_file?.path);
                      authProvider.changeInfo(context, _file!, nameController.text! );
                    },
                    child: Text('Submit'),
                  ),
                ],
              );
            },
          );
        });
  }
}
