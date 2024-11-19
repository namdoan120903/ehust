import 'package:flutter/material.dart';
import 'package:project/screens/myAppBar.dart';
import 'package:project/screens/student/student_class.dart';
import 'package:provider/provider.dart';

import '../../provider/AuthProvider.dart';
import '../../provider/ClassProvider.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {

  @override
  void initState() {
    super.initState();
    // Lấy instance của ClassProvider mà không lắng nghe các thay đổi
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    classProvider.get_class_list(context);
    print(classProvider.classes.toString());
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
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
                authProvider.user.avatar!=null&&authProvider.user.avatar!=""
                    ?ClipOval(
                  child: Image.network(
                    'https://drive.google.com/uc?export=view&id=${authProvider.fileId}',
                    width: 65,
                    height: 65,
                    fit: BoxFit.cover, // Cắt ảnh để vừa với kích thước
                  ),
                ):CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 30,
                ),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${authProvider.user.ho} ${authProvider.user.ten}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Text('Student')
                  ],
                ),
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
                _buildMenuItem(Icons.people, 'Lớp học', 'Thông tin các lớp học của sinh viên',context, 'class'),
                _buildMenuItem(Icons.add, 'Đăng kí', 'Đăng kí lớp học', context, '/student/class/register'),
                _buildMenuItem(Icons.folder, 'Tài liệu', 'Tài liệu của lớp học, môn học', context, 'document'),
                _buildMenuItem(Icons.assignment, 'Bài tập', 'Thông tin bài tập môn học', context, '/student/survey'),
                _buildMenuItem(Icons.note, 'Nghỉ phép', 'Đơn xin nghỉ phép của sinh viên', context, 'takeleave'),
                _buildMenuItem(Icons.check, 'Điểm danh', 'Điểm danh các lớp học', context, 'attendance'),
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
          if(route == "/student/class/register"){ Navigator.pushNamed(context, route);};
          if(route == "/student/survey"){ Navigator.pushNamed(context, route);}
          else{
            Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentClass(route: route)));
          }
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
