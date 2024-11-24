import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:project/components/custom_button.dart'; // Your custom button widget
import 'package:project/model/StudentAccount.dart'; // Ensure the path is correct
import 'package:project/model/StudentAttendance.dart'; // Ensure the path is correct
import 'package:project/provider/ClassProvider.dart'; // Ensure the path is correct
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

  late List<StudentAccount> studentAccounts; // Declare studentAccounts here
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve classId from the arguments passed through the route
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      classId = args.toString();
    } else {
      classId = ''; // Default value if no classId is passed
    }

    // Now call getClassInfoLecturer after classId has been set
    final classProvider = Provider.of<ClassProvider>(context, listen: false);

    // Only fetch the class info if classId is not empty
    if (classId.isNotEmpty) {
      classProvider.getClassInfoLecturer(context, classId);
      if (classProvider.getClassLecturer?.studentAccounts != null) {
        studentAccounts = classProvider.getClassLecturer!.studentAccounts!;
      } else {
        studentAccounts = [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the RollCallProvider
    final rollCallProvider = Provider.of<RollCallProvider>(context);
    List<StudentAttendance> students = studentAccounts.map((student) {
      return StudentAttendance(
        id: student.studentId ?? "",
        name: "${student.lastName ?? ""} ${student.firstName ?? ""}".trim(),
        accountId: student.accountId ?? "",
      );
    }).toList();
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
                Text("Ngày điểm danh: "),
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
                    columnWidths: {
                      0: const FractionColumnWidth(0.3), // ID column
                      1: const FractionColumnWidth(0.5), // Name column
                      3: const FractionColumnWidth(0.2), // Attendance column
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
                                child: Text("Vắng",
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
                                      print("before student.attendanceStatus " +
                                          student.attendanceStatus.toString());
                                      setState(() {
                                        // Find the student by their id and toggle their attendance status
                                        int studentIndex = students.indexWhere(
                                            (s) => s.id == student.id);
                                        if (studentIndex != -1) {
                                          // Toggle the attendance status
                                          if (students[studentIndex]
                                                  .attendanceStatus ==
                                              'ABSENCE') {
                                            students[studentIndex]
                                                    .attendanceStatus =
                                                'NOT_ABSENCE';
                                          } else {
                                            students[studentIndex]
                                                .attendanceStatus = 'ABSENCE';
                                          }
                                        }
                                        print(
                                            "after student.attendanceStatus " +
                                                student.attendanceStatus
                                                    .toString());
                                      });
                                    },
                                    child: Icon(
                                      student.attendanceStatus == 'NOT_ABSENCE'
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: student.attendanceStatus ==
                                              'NOT_ABSENCE'
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
                        student.attendanceStatus ==
                        'ABSENCE') // Filter for ABSENCE status
                    .map((student) =>
                        student.accountId.toString()) // Extract the student IDs
                    .toList();
                print("absentStudentIds: " + absentStudentIds.toString());

                // Call the API to take attendance
                rollCallProvider.takeAttendance(
                    classId, currentDate, absentStudentIds);
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
