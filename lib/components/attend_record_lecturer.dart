import 'package:flutter/material.dart';
import 'package:project/model/StudentAttendanceRecord.dart';
import 'package:project/provider/ClassProvider.dart';
import 'package:project/provider/RollCallProvider.dart';
import 'package:project/screens/myAppBar.dart';
import 'package:provider/provider.dart';

class LecturerAttendancePage extends StatelessWidget {
  final String classId;
  final List<String> attendanceList; // List of dates for attendance

  const LecturerAttendancePage(
      {super.key, required this.attendanceList, required this.classId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(check: true, title: "EHUST-LECTURER"),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: attendanceList.length,
        itemBuilder: (context, index) {
          final date = attendanceList[index];
          return GestureDetector(
            onTap: () {
              // Handle what happens when a date is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AttendanceDetailPage(date: date, classId: classId),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: Text(
                  date,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AttendanceDetailPage extends StatefulWidget {
  final String date;
  final String classId;

  const AttendanceDetailPage({
    super.key,
    required this.date,
    required this.classId,
  });

  @override
  State<AttendanceDetailPage> createState() => _AttendanceDetailPageState();
}

class _AttendanceDetailPageState extends State<AttendanceDetailPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int _pageSize = 9;
  late var rollCallProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      rollCallProvider = Provider.of<RollCallProvider>(context, listen: false);
      _fetchAttendanceData(rollCallProvider);
    });

    // Scroll listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchAttendanceData(rollCallProvider);
      }
    });
  }

  void _fetchAttendanceData(RollCallProvider rollCallProvider) async {
    try {
      // Replace with your API call
      await rollCallProvider.getAttendanceList(
          widget.classId, widget.date, _currentPage, _pageSize);
    } catch (e) {
      print("Error fetching attendance data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final rollCallProvider =
        Provider.of<RollCallProvider>(context, listen: false);
    final attendanceRecords = rollCallProvider.recordForLecturer;

    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    classProvider.getClassInfoLecturer(context, widget.classId);

    return Scaffold(
      appBar: MyAppBar(check: true, title: "EHUST-LECTURER"),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
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
                          verticalAlignment: TableCellVerticalAlignment.middle,
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
                          verticalAlignment: TableCellVerticalAlignment.middle,
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
                          verticalAlignment: TableCellVerticalAlignment.middle,
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
                    for (var student in attendanceRecords)
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(student.studentId,
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
                                child: Text(
                                    classProvider
                                        .findNameById(student.studentId),
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
                                  onTap: () async {
                                    String newStatus =
                                        student.status == 'PRESENT'
                                            ? 'EXCUSED_ABSENCE'
                                            : 'PRESENT'; // Toggle the status
                                    await rollCallProvider.setAttendanceStatus(
                                        student.attendanceId, newStatus);
                                    setState(() {
                                      student.status =
                                          newStatus; // Set the new status
                                    }); // Call the method with the attendance ID and new status
                                  },
                                  child: Icon(
                                    student.status == 'PRESENT'
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: student.status == 'PRESENT'
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
          if (rollCallProvider.isLoading && attendanceRecords.isEmpty)
            const Center(child: CircularProgressIndicator()), // Initial loader
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
