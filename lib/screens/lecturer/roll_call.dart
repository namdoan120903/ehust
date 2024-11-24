import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:project/components/custom_button.dart';
import 'package:project/provider/RollCallProvider.dart';
import 'package:provider/provider.dart'; // Import provider

class RollCallScreen extends StatefulWidget {
  @override
  _RollCallScreenState createState() => _RollCallScreenState();
}

class _RollCallScreenState extends State<RollCallScreen> {
  String currentDate =
      DateFormat('dd/MM/yyyy').format(DateTime.now()); // Get the current date
  String classId = ''; // Default empty string

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve classId from the arguments passed through the route
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      classId = args; // Assign the passed classId
    } else {
      classId = ''; // Default value if no classId is passed
    }
  }

  // Initialize the students data with attendance status
  List<Map<String, dynamic>> students = [
    {
      'id': 'E190001',
      'name': 'Nguyễn Văn Anh',
      'attendanceStatus': 'NOT_ABSENCE'
    },
    {
      'id': 'E190002',
      'name': 'Nguyễn Thị Phương Anh',
      'attendanceStatus': 'NOT_ABSENCE'
    },
    {
      'id': 'E190003',
      'name': 'Lê Văn Hoàng',
      'attendanceStatus': 'NOT_ABSENCE'
    },
    // Add more students here...
  ];

  @override
  Widget build(BuildContext context) {
    // Get the RollCallProvider
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
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Display the current date (non-editable)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Ngày điểm danh: "),
                Text(currentDate,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  Table(
                    border: TableBorder.all(color: Colors.black),
                    columnWidths: {
                      0: FractionColumnWidth(0.3), // ID column
                      1: FractionColumnWidth(0.5), // Name column
                      3: FractionColumnWidth(0.2), // Attendance off column
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
                                  padding: EdgeInsets.all(8),
                                  child: Text(student['id'],
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(student['name'],
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // Toggle attendance status
                                        student['attendanceStatus'] =
                                            student['attendanceStatus'] ==
                                                    'ABSENCE'
                                                ? 'NOT_ABSENCE'
                                                : 'ABSENCE';
                                      });
                                    },
                                    child: Icon(
                                      student['attendanceStatus'] ==
                                              'NOT_ABSENCE'
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: student['attendanceStatus'] ==
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
                        student['attendanceStatus'] ==
                        'ABSENCE') // Filter for ABSENCE status
                    .map((student) =>
                        student['id'].toString()) // Extract the student IDs
                    .toList();
                print("absentStudentIds  " + absentStudentIds.toString());

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
