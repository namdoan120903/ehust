import 'package:flutter/material.dart';
import 'package:project/screens/myAppBar.dart';

class StudentAttendancePage extends StatelessWidget {
  final List<Map<String, dynamic>>? attendanceList;

  const StudentAttendancePage({Key? key, required this.attendanceList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        check: false,
        title: "EHUST-STUDENT",
      ),
      body: attendanceList!.isEmpty || attendanceList == null
          ? Center(
              child: Text(
                "Bạn đi học rất đầy đủ!",
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
            )
          : ListView.builder(
              itemCount: attendanceList!.length,
              itemBuilder: (context, index) {
                final record = attendanceList![index];
                return ListTile(
                  title: Text("Ngày vắng mặt: ${record['date']}"),
                );
              },
            ),
    );
  }
}
