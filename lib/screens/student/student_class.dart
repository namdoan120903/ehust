import 'package:flutter/material.dart';
import 'package:project/screens/class_info.dart';
import 'package:project/screens/lecturer/lecturer_survey.dart';
import 'package:project/screens/myAppBar.dart';
import 'package:project/screens/student/student_absence.dart';
import 'package:project/screens/student/student_material.dart';
import 'package:project/screens/student/student_survey.dart';
import 'package:provider/provider.dart';

import '../../provider/ClassProvider.dart';

class StudentClass extends StatefulWidget {
  final String route;
  StudentClass({required this.route});

  @override
  State<StudentClass> createState() => _StudentClassState();
}

class _StudentClassState extends State<StudentClass> {
  int _currentPage = 0;

  final int _classesPerPage = 5;

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);
    final totalPages = (classProvider.classes.length / _classesPerPage).ceil();
    final currentPageClasses = classProvider.classes
        .skip(_currentPage * _classesPerPage)
        .take(_classesPerPage)
        .toList();
    return Scaffold(
      appBar: MyAppBar(check: true, title: "EHUST-STUDENT"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Danh sách lớp học',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: currentPageClasses.length,
                itemBuilder: (context, index) {
                  final classItem = currentPageClasses[index];
                  return Card(
                    color: Colors.red[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        '${classItem.classId} - ${classItem.className}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${classItem.classType}\n${classItem.status}, ${classItem.lecturerName}'),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
                      onTap: () {

                        print(widget.route);
                        if(widget.route == "class"){
                          classProvider.getClassInfoLecturer(context, classItem.classId!);
                          if(classProvider.getClassLecturer!=null) Navigator.push(context, MaterialPageRoute(builder: (context)=>ClassInfo()));
                        }
                        if(widget.route == "material") Navigator.push(context, MaterialPageRoute(builder: (context)=> StudentMaterial(classA: classItem,)));
                        if(widget.route == "absence") Navigator.push(context, MaterialPageRoute(builder: (context)=> StudentAbsence(classA: classItem,)));
                        },
                    ),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nút Previous
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _currentPage > 0
                      ? () {
                    setState(() {
                      _currentPage--;
                    });
                  }
                      : null,
                ),
                // Hiển thị trang hiện tại
                Text('Trang ${_currentPage + 1} / $totalPages'),
                // Nút Next
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: _currentPage < totalPages - 1
                      ? () {
                    setState(() {
                      _currentPage++;
                    });
                  }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
