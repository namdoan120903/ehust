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
  int _currentPage = 0;
  final int _pageSize = 18;
  bool _isLoading = false;
  bool _hasMoreData = true; // Track if more data is available
  late ScrollController _scrollController;
  late RollCallProvider rollCallProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rollCallProvider = Provider.of<RollCallProvider>(context, listen: false);
      _fetchAttendanceData();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMoreData) {
      _fetchAttendanceData();
    }
  }

  Future<void> _fetchAttendanceData() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Save the initial length of the records
      int initialSize = rollCallProvider.recordForLecturer.length;

      // Fetch new data
      await rollCallProvider.getAttendanceList(
        widget.classId,
        widget.date,
        _currentPage,
        _pageSize,
      );

      // Check if new data was added
      int finalSize = rollCallProvider.recordForLecturer.length;

      if (finalSize > initialSize) {
        _currentPage++; // Increment the page for the next fetch
      } else {
        _hasMoreData = false; // No more data available
      }
    } catch (e) {
      print("Error fetching attendance data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final attendanceRecords =
        context.watch<RollCallProvider>().recordForLecturer;
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    classProvider.getClassInfoLecturer(context, widget.classId);

    return Scaffold(
      appBar: MyAppBar(check: true, title: "EHUST-LECTURER"),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
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
                    // Populate rows dynamically
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
                                            : 'PRESENT';
                                    await rollCallProvider.setAttendanceStatus(
                                        student.attendanceId, newStatus);
                                    setState(() {
                                      student.status = newStatus;
                                    });
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
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: CircularProgressIndicator(),
            ),
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
