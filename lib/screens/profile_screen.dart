import 'package:flutter/material.dart';
import 'package:project/model/User.dart';
import 'package:project/provider/NotificationProvider.dart';
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
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: MyAppBar(
        check: true,
        title: "EHUST-STUDENT",
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                ),
                SizedBox(height: 20),
                Divider(),
                ListTile(
                  title: Text('Ten Sinh Vien', textAlign: TextAlign.start),
                  subtitle: Text(
                      '${authProvider.user.ho} ${authProvider.user.ten}',
                      textAlign:
                          TextAlign.start), // Căn giữa các item trong ListTile
                ),
                ListTile(
                  title: Text('Email', textAlign: TextAlign.start),
                  subtitle: Text('${authProvider.user.username}',
                      textAlign: TextAlign.start),
                ),
                ListTile(
                    title: Text('Chức vụ', textAlign: TextAlign.start),
                    subtitle: Text('${authProvider.user.role}',
                        textAlign: TextAlign.start)),
                ListTile(
                  title: Text('Khoa/Viện', textAlign: TextAlign.start),
                  subtitle: Text('CNTT', textAlign: TextAlign.start),
                ),
                ListTile(
                  title: Text('Lớp', textAlign: TextAlign.start),
                  subtitle:
                      Text('Khoa học máy tính', textAlign: TextAlign.start),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showChangeUserInfoDialog(context, authProvider);
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
                        // NotificationProvider notificationProvider =
                        //     NotificationProvider();
                        // notificationProvider.sendNotification(
                        //     message: "This is a test notification",
                        //     userName: "Nguyen Tan",
                        //     type: "ABSENCE");
                        authProvider.user = User();
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

  void _showChangeUserInfoDialog(
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
}
