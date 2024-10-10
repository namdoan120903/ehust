import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:project/components/custom_button.dart';

class RollCallScreen extends StatefulWidget {
  @override
  _RollCallScreenState createState() => _RollCallScreenState();
}

class _RollCallScreenState extends State<RollCallScreen> {
  String currentDate =
      DateFormat('dd/MM/yyyy').format(DateTime.now()); // Get the current date

  List<Map<String, dynamic>> students = [
    {'id': 'E190001', 'name': 'Nguyễn Văn Anh', 'status': 'Có'},
    {'id': 'E190002', 'name': 'Nguyễn Thị Phương Anh', 'status': 'Vắng'},
    {'id': 'E190003', 'name': 'Lê Văn Hoàng', 'status': 'Chậm'},
    {'id': 'E190001', 'name': 'Nguyễn Văn Anh', 'status': 'Có'},
    {'id': 'E190002', 'name': 'Nguyễn Thị Phương Anh', 'status': 'Vắng'},
    {'id': 'E190003', 'name': 'Lê Văn Hoàng', 'status': 'Chậm'},
    {'id': 'E190001', 'name': 'Nguyễn Văn Anh', 'status': 'Có'},
    {'id': 'E190002', 'name': 'Nguyễn Thị Phương Anh', 'status': 'Vắng'},
    {'id': 'E190003', 'name': 'Lê Văn Hoàng', 'status': 'Chậm'},
    {'id': 'E190001', 'name': 'Nguyễn Văn Anh', 'status': 'Có'},
    {'id': 'E190002', 'name': 'Nguyễn Thị Phương Anh', 'status': 'Vắng'},
    {'id': 'E190003', 'name': 'Lê Văn Hoàng', 'status': 'Chậm'},
    {'id': 'E190001', 'name': 'Nguyễn Văn Anh', 'status': 'Có'},
    {'id': 'E190002', 'name': 'Nguyễn Thị Phương Anh', 'status': 'Vắng'},
    {'id': 'E190003', 'name': 'Lê Văn Hoàng', 'status': 'Chậm'},
    // Add more students here...
  ];

  final List<String> attendanceOptions = ['Có', 'Vắng', 'Chậm'];

  @override
  Widget build(BuildContext context) {
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
                      0: FixedColumnWidth(100), // ID column
                      1: FlexColumnWidth(), // Name column
                      2: FixedColumnWidth(100), // Present/Absent column
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
                                child: Text("Trạng Thái",
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
                                  child: DropdownButton<String>(
                                    value: student['status'],
                                    isExpanded: true,
                                    items: attendanceOptions
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Center(child: Text(value)),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        student['status'] = newValue!;
                                      });
                                    },
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
                // Handle form submission
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
