import 'package:flutter/material.dart';
import 'package:project/screens/lecturer/lecturer_survey.dart';
import 'package:project/screens/myAppBar.dart';
import 'package:provider/provider.dart';

import '../../provider/ClassProvider.dart';

class LecturerClassList extends StatelessWidget {
  final String route;
  LecturerClassList({required this.route});

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);
    return Scaffold(
      appBar: MyAppBar(check: true, title: "EHUST-LECTURER"),
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
                itemCount: classProvider.classes.length,
                itemBuilder: (context, index) {
                  final classItem = classProvider.classes[index];
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
                        if(route == "survey"){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LecturerSurvey(classA: classItem)));
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
