import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/provider/RollCallProvider.dart';

class LecturerAttendancePage extends StatefulWidget {
  final String classId;

  const LecturerAttendancePage({Key? key, required this.classId})
      : super(key: key);

  @override
  _LecturerAttendancePageState createState() => _LecturerAttendancePageState();
}

class _LecturerAttendancePageState extends State<LecturerAttendancePage> {
  final TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final rollCallProvider = Provider.of<RollCallProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: const Center(
          child: Text(
            "Bản ghi điểm danh",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        backgroundColor: Colors.red[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDatePicker(context, "Ngày điểm danh"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final dateStr =
                    selectedDate != null ? selectedDate.toString() : "";
                await rollCallProvider.getAttendanceList(
                    widget.classId, dateStr, 0, 2);

                if (rollCallProvider.attendanceList.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Không có dữ liệu điểm danh."),
                  ));
                }
              },
              child: const Text("Lấy danh sách điểm danh"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: rollCallProvider.attendanceList.isNotEmpty
                  ? _buildAttendanceTable(rollCallProvider.attendanceList)
                  : const Center(
                      child: Text(
                        "Không có dữ liệu điểm danh",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, String label) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
        ),
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.red),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          setState(() {
            selectedDate = pickedDate;
          });
        }
      },
      controller: TextEditingController(
          text: selectedDate?.toLocal().toString().split(' ')[0] ?? ''),
    );
  }

  Widget _buildAttendanceTable(List<Map<String, dynamic>> attendanceList) {
    return Table(
      border: TableBorder.all(color: Colors.black),
      columnWidths: const {
        0: FractionColumnWidth(0.3), // MSSV column
        1: FractionColumnWidth(0.5), // Name column
        2: FractionColumnWidth(0.2), // Attendance column
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
                  child: Text(
                    "MSSV",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Họ và Tên",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Trạng thái",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Table rows with attendance data
        for (var student in attendanceList)
          TableRow(
            children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(student['id'], textAlign: TextAlign.center),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(student['name'], textAlign: TextAlign.center),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      student['status'], // Display attendance status
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: student['status'] == 'ABSENCE'
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
