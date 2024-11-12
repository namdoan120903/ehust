import 'package:flutter/material.dart';
import 'myAppBar.dart';

class CreateAssignmentScreen extends StatefulWidget {
  @override
  _CreateAssignmentScreenState createState() => _CreateAssignmentScreenState();
}

class _CreateAssignmentScreenState extends State<CreateAssignmentScreen> {
  DateTime? startTime;
  DateTime? endTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(check: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.red[700],
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                'CREATE ASSIGNMENT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Tên bài kiểm tra*',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Mô tả',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Hoặc',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.upload_file, color: Colors.white),
                        label: Text(
                          'Tải tài liệu lên',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          // Handle file upload
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? selectedStartTime = await showDateTimePicker(context);
                            if (selectedStartTime != null) {
                              setState(() {
                                startTime = selectedStartTime; // Cập nhật thời gian bắt đầu
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Bắt đầu',
                              border: OutlineInputBorder(),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  startTime != null
                                      ? "${startTime!.day}/${startTime!.month}/${startTime!.year}"
                                      : "Chọn thời gian",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  startTime != null
                                      ? "${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}"
                                      : "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? selectedEndTime = await showDateTimePicker(context);
                            if (selectedEndTime != null) {
                              setState(() {
                                endTime = selectedEndTime; // Cập nhật thời gian kết thúc
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Kết thúc',
                              border: OutlineInputBorder(),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  endTime != null
                                      ? "${endTime!.day}/${endTime!.month}/${endTime!.year}"
                                      : "Chọn thời gian",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  endTime != null
                                      ? "${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}"
                                      : "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          if (startTime == null || endTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Vui lòng chọn đầy đủ thời gian bắt đầu và kết thúc'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          };

                          if (endTime != null && startTime != null && endTime!.isBefore(startTime!)) {
                            // Hiển thị cảnh báo nếu thời gian kết thúc trước thời gian bắt đầu
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Thời gian kết thúc không được chọn trước thời gian bắt đầu.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            // Handle form submission
                            print("Bắt đầu: ${startTime != null ? "${startTime!.day}/${startTime!.month}/${startTime!.year} ${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}" : "Chưa chọn"}");
                            print("Kết thúc: ${endTime != null ? "${endTime!.day}/${endTime!.month}/${endTime!.year} ${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}" : "Chưa chọn"}");
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> showDateTimePicker(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        return DateTime(date.year, date.month, date.day, time.hour, time.minute);
      }
    }
    return null;
  }
}






