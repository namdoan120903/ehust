import 'package:flutter/material.dart';
import 'package:project/components/attend_class_list.dart';
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
      appBar: MyAppBar(
        check: false,
        title: "EHUST-STUDENT",
      ),
      body: Column(
        children: [
          //Header
          Padding(padding: EdgeInsets.only(left: 20, top: 40, bottom: 10)),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/profile");
            },
            child: Row(
              children: [
                authProvider.user.avatar != null &&
                        authProvider.user.avatar != ""
                    ? ClipOval(
                        child: Image.network(
                          'https://drive.google.com/uc?export=view&id=${authProvider.fileId}',
                          width: 65,
                          height: 65,
                          fit: BoxFit.cover, // Cắt ảnh để vừa với kích thước
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 30,
                      ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${authProvider.user.ho} ${authProvider.user.ten}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text('Student')
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(30),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _buildMenuItem(Icons.people, 'Lớp học',
                    'Thông tin các lớp học của sinh viên', context, 'class'),
                _buildMenuItem(Icons.add, 'Đăng kí', 'Đăng kí lớp học', context,
                    '/student/class/register'),
                _buildMenuItem(Icons.folder, 'Tài liệu',
                    'Tài liệu của lớp học, môn học', context, 'document'),
                _buildMenuItem(Icons.assignment, 'Bài tập',
                    'Thông tin bài tập môn học', context, '/student/survey'),
                _buildMenuItem(Icons.note, 'Nghỉ phép',
                    'Đơn xin nghỉ phép của sinh viên', context, 'takeleave'),
                _buildMenuItem(Icons.check, 'Điểm danh',
                    'Điểm danh các lớp học', context, 'attendance'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String subtitle,
      BuildContext context, String route) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 5,
      child: InkWell(
        onTap: () async {
          if (route == "/student/class/register") {
            // Navigate to class registration screen
            Navigator.pushNamed(context, route);
          } else if (route == "attendance") {
            // Handle "Điểm danh" button tap
            final classProvider =
                Provider.of<ClassProvider>(context, listen: false);
            await classProvider.get_class_list(context);

            if (classProvider.classes.isNotEmpty) {
              // Extract class IDs and ensure they are non-null
              final classIds = classProvider.classes
                  .map((c) =>
                      c.classId) // This is likely returning List<String?>
                  .whereType<String>() // Filters out null values
                  .toList();

              debugPrint("classIds: " + classIds.toString());

              // Navigate to AttendanceClassList screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AttendanceClassList(
                    classIds: classIds, // This will now be a List<String>
                    userRole: 'STUDENT', // Set role dynamically as needed
                  ),
                ),
              );
            }
          } else {
            // Navigate to other screens
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentClass(route: route),
              ),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.red),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
