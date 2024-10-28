import 'package:flutter/material.dart';
import 'package:project/screens/myAppBar.dart';
import 'package:provider/provider.dart';

import '../provider/AuthProvider.dart';

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(check: false, title: "EHUST-STUDENT",),
      body: Column(
        children: [
          //Header
          Padding(padding: EdgeInsets.only(left: 20, top: 40, bottom: 10),
          child: GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, "/profile");
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 30,
                ),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Doan Van Nam | Student', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Text('Khoa hoc may tinh')
                  ],
                )
              ],
            ),
          ),
          ),
          Expanded(
            child: GridView.count(crossAxisCount: 2,
              padding: EdgeInsets.all(30),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _buildMenuItem(Icons.people, 'Lớp học', 'Thông tin các lớp học của sinh viên'),
                _buildMenuItem(Icons.add, 'Đăng kí', 'Đăng kí lớp học'),
                _buildMenuItem(Icons.folder, 'Tài liệu', 'Tài liệu của lớp học, môn học'),
                _buildMenuItem(Icons.assignment, 'Bài tập', 'Thông tin bài tập môn học'),
                _buildMenuItem(Icons.note, 'Nghỉ phép', 'Đơn xin nghỉ phép của sinh viên'),
                _buildMenuItem(Icons.check, 'Điểm danh', 'Điểm danh các lớp học'),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget _buildMenuItem(IconData icon, String title, String subtitle) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 5,
      child: InkWell(
        onTap: () {
          // Handle menu item tap
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.red),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
