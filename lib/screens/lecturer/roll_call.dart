import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:project/components/custom_button.dart'; // Your custom button widget
import 'package:project/model/StudentAccount.dart'; // Ensure the path is correct
import 'package:project/model/StudentAttendance.dart'; // Ensure the path is correct
import 'package:project/provider/ClassProvider.dart'; // Ensure the path is correct
import 'package:project/provider/NotificationProvider.dart';
import 'package:project/provider/RollCallProvider.dart'; // Ensure the path is correct
import 'package:provider/provider.dart'; // Provider package

class RollCallScreen extends StatefulWidget {
  @override
  _RollCallScreenState createState() => _RollCallScreenState();
}

class _RollCallScreenState extends State<RollCallScreen> {
  String currentDate =
      DateFormat('dd/MM/yyyy').format(DateTime.now()); // Get the current date
  String classId = ''; // Default empty string
  late List<StudentAttendance> students = []; // Stateful list for attendance

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve classId from the arguments passed through the route
    final args = ModalRoute.of(context)?.settings.arguments;
    classId = args?.toString() ?? '';

    if (classId.isNotEmpty) {
      final classProvider = Provider.of<ClassProvider>(context, listen: false);

      // Fetch class info for the lecturer
      classProvider.getClassInfoLecturer(context, classId);

      // Populate the students list if data is available
      if (classProvider.getClassLecturer?.studentAccounts != null) {
        students =
            classProvider.getClassLecturer!.studentAccounts!.map((student) {
          return StudentAttendance(
            id: student.studentId ?? "",
            name: "${student.lastName ?? ""} ${student.firstName ?? ""}".trim(),
            accountId: student.accountId ?? "",
          );
        }).toList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rollCallProvider = Provider.of<RollCallProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Add this if you want to pop the page
          },
        ),
        flexibleSpace: const Center(
          child: Text("Điểm danh",
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        backgroundColor: Colors.red[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Display the current date (non-editable)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Ngày điểm danh: "),
                Text(currentDate,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  Table(
                    border: TableBorder.all(color: Colors.black),
                    columnWidths: const {
                      0: FractionColumnWidth(0.3), // ID column
                      1: FractionColumnWidth(0.5), // Name column
                      3: FractionColumnWidth(0.2), // Attendance column
                    },
                    children: [
                      // Table headers
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey[300]),
                        children: const [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text("MSSV",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text("Họ và Tên",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text("Trạng thái",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Table rows with student data
                      for (var student in students)
                        TableRow(
                          children: [
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(student.id,
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(student.name,
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // Toggle attendance status
                                        if (student.attendanceStatus ==
                                            'ABSENCE') {
                                          student.attendanceStatus = 'PRESENT';
                                        } else {
                                          student.attendanceStatus = 'ABSENCE';
                                        }
                                      });
                                    },
                                    child: Icon(
                                      student.attendanceStatus == 'PRESENT'
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color:
                                          student.attendanceStatus == 'PRESENT'
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Submit button
            CustomButton(
              text: "Xác nhận",
              onPressed: () {
                // Collect the absent student IDs
                List<String> absentStudentIds = students
                    .where((student) =>
                        student.attendanceStatus == 'ABSENCE') // Filter ABSENCE
                    .map((student) => student.accountId.toString())
                    .toList();
                print("absentStudentIds: " + absentStudentIds.toString());

                // Call the API to take attendance
                rollCallProvider.takeAttendance(
                    classId, currentDate, absentStudentIds);
                final notificationProvider =
                    Provider.of<NotificationProvider>(context, listen: false);
                for (String id in absentStudentIds) {
                  notificationProvider.sendNotification(
                      message: "Thông báo vắng mặt",
                      toUser: id,
                      type: "ABSENCE");
                }
                Navigator.pop(context);
              },
              width: 0.3,
              height: 0.06,
              borderRadius: 25,
            ),
          ],
        ),
      ),
    );
  }
}
