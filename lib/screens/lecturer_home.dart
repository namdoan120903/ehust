import 'package:flutter/material.dart';

import 'myAppBar.dart';

class LecturerHome extends StatelessWidget {
  const LecturerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(check: false, title: "EHUST-LECTURER"),
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
                      Text('Nguyen Tien Thanh | Lecturer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
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
                _buildMenuItem(Icons.people, 'Lớp học', 'Thông tin các lớp học của sinh viên', context, "/lecturer"),
                _buildMenuItem(Icons.add, 'Tạo lớp học', 'Tạo lớp học mới', context, "/lecturer/class"),
                _buildMenuItem(Icons.folder, 'Tài liệu', 'Tài liệu của lớp học, môn học', context, "/lecturer"),
                _buildMenuItem(Icons.assignment, 'Bài tập', 'Thông tin bài tập môn học', context, "/lecturer"),
                _buildMenuItem(Icons.note, 'Nhập điểm', 'Giảng viên nhập điểm cho sinh viên', context, "/lecturer"),
                _buildMenuItem(Icons.check, 'Điểm danh', 'Điểm danh các lớp học',context, "/lecturer"),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget _buildMenuItem(IconData icon, String title, String subtitle, BuildContext context, String route) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
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
