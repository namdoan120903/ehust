import 'package:flutter/material.dart';
import 'package:project/model/User.dart';
import 'package:project/screens/myAppBar.dart';
import 'package:provider/provider.dart';

import '../provider/AuthProvider.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: MyAppBar(check: true, title: "EHUST-STUDENT",),
      body: Padding(padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [SizedBox(height: 20,),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20)
            ),
          ),
          SizedBox(height: 20),
          Divider(),
          ListTile(
            title: Text('Ten Sinh Vien', textAlign: TextAlign.start),
            subtitle: Text('Doan Van Nam', textAlign: TextAlign.start), // Căn giữa các item trong ListTile
          ),
          ListTile(
            title: Text('Email', textAlign: TextAlign.start),
            subtitle: Text('${authProvider.user.username}', textAlign: TextAlign.start),
          ),
          ListTile(
            title: Text('Chức vụ', textAlign: TextAlign.start),
            subtitle: Text('${authProvider.user.role}', textAlign: TextAlign.start)
          ),
          ListTile(
            title: Text('Khoa/Viện', textAlign: TextAlign.start),
            subtitle: Text('CNTT', textAlign: TextAlign.start),
          ),
          ListTile(
            title: Text('Lớp', textAlign: TextAlign.start),
            subtitle: Text('Khoa học máy tính', textAlign: TextAlign.start),
          ),
          Row( mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  authProvider.user = User();
                  Navigator.pushNamed(context, '/signin');
                },
                child: Text('Đăng xuất', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold
                ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                ),
              ),
            ],
          )

        ],
      ),
      ),
    );
  }
}
