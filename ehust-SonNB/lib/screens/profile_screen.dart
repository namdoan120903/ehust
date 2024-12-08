import 'package:flutter/material.dart';
import 'package:project/appBar/bottomBar.dart';
import 'package:project/appBar/myAppBar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
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
            subtitle: Text('doanvan@ehust.edu.vn', textAlign: TextAlign.start),
          ),
          ListTile(
            title: Text('Mã số sinh viên', textAlign: TextAlign.start),
            subtitle: Text('20215430', textAlign: TextAlign.start)
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
                  // Handle logout
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
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
