import 'package:flutter/material.dart';
import 'package:project/components/attend_record_lecturer.dart';
import 'package:project/components/attend_record_student.dart';
import 'package:project/provider/RollCallProvider.dart';
import 'package:provider/provider.dart';

class ClassCard extends StatelessWidget {
  final String classId;
  final String userRole; // Either 'STUDENT' or 'LECTURER'

  const ClassCard({
    Key? key,
    required this.classId,
    required this.userRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rollCallProvider =
        Provider.of<RollCallProvider>(context, listen: false);

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: classId
            Text(
              "Class ID: $classId",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            // Right side: Buttons based on role
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (userRole == 'STUDENT') {
                      await rollCallProvider.getAttendanceRecord(classId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StudentAttendancePage(
                              attendanceList: rollCallProvider.attendanceList),
                        ),
                      );
                    } else if (userRole == 'LECTURER') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              LecturerAttendancePage(classId: classId),
                        ),
                      );
                    }
                  },
                  child: const Text('View'),
                ),
                if (userRole ==
                    'LECTURER') // Show 'Take' button only for lecturers
                  const SizedBox(width: 8),
                if (userRole == 'LECTURER')
                  ElevatedButton(
                    onPressed: () {
                      print("Navigating with classId: $classId");
                      Navigator.pushNamed(
                        context,
                        '/lecturer/class/take_attendance',
                        arguments: classId,
                      );
                    },
                    child: const Text('Take'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
