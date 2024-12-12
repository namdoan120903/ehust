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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      // If the user is a student, fetch the attendance record
                      await rollCallProvider.getAttendanceRecord(classId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StudentAttendancePage(
                              attendanceList: rollCallProvider.attendanceList),
                        ),
                      );
                    } else if (userRole == 'LECTURER') {
                      // If the user is a lecturer, call fetchAttendanceDates and pass the result
                      try {
                        List<String> attendanceDates = await rollCallProvider
                            .fetchAttendanceDates(classId);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LecturerAttendancePage(
                              classId: classId,
                              attendanceList:
                                  attendanceDates, // Pass the list of dates
                            ),
                          ),
                        );
                      } catch (e) {
                        // Handle error (if any)
                        print("Error fetching attendance dates: $e");
                        // Optionally show a message or dialog if fetching fails
                      }
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
