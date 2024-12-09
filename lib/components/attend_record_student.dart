import 'package:flutter/material.dart';
import 'package:project/screens/myAppBar.dart';

class StudentAttendancePage extends StatelessWidget {
  final List<String>? attendanceList;

  const StudentAttendancePage({
    Key? key,
    required this.attendanceList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int absenceDays = 0;
    // Calculate the number of absence days
    if (attendanceList != null) {
      absenceDays = attendanceList!.length;
    }

    return Scaffold(
      appBar: MyAppBar(
        check: true,
        title: "EHUST-STUDENT",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the number of absence days
            if (absenceDays > 0)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.report_gmailerrorred,
                      color: Colors.red,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Số ngày vắng mặt: $absenceDays ngày",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),

            // If no attendance records, display a message
            if (attendanceList!.isEmpty || attendanceList == null)
              Expanded(
                child: Center(
                  child: Text(
                    "Bạn đi học rất đầy đủ!",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              // Display attendance records in a list
              Expanded(
                child: ListView.builder(
                  itemCount: attendanceList!.length,
                  itemBuilder: (context, index) {
                    final record = attendanceList![index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        title: Text(
                          "Ngày vắng mặt: ${record}",
                          style: TextStyle(fontSize: 16),
                        ),
                        tileColor: Colors.grey[100],
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
