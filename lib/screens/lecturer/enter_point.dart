import 'package:flutter/material.dart';
import 'package:project/components/custom_button.dart';

class EnterPointScreen extends StatefulWidget {
  @override
  _EnterPointScreenState createState() => _EnterPointScreenState();
}

class _EnterPointScreenState extends State<EnterPointScreen> {
  List<Map<String, dynamic>> students = [
    {'id': 'E190001', 'name': 'Nguyễn Văn Anh', 'qtScore': '', 'ckScore': ''},
    {
      'id': 'E190002',
      'name': 'Nguyễn Thị Phương Anh',
      'qtScore': '',
      'ckScore': ''
    },
    {'id': 'E190003', 'name': 'Lê Văn Hoàng', 'qtScore': '', 'ckScore': ''},
    // Add more students here...
  ];

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
          child: Text("Nhập điểm",
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        backgroundColor: Colors.red[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Class Information
            Text("Mã lớp: 48785",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Tên học phần: Đa nền tảng"),
            SizedBox(height: 8),
            Text("Mã học phần: IT0000"),
            SizedBox(height: 16),

            // Table for entering scores
            Expanded(
              child: ListView(
                children: [
                  Table(
                    border: TableBorder.all(color: Colors.black),
                    columnWidths: {
                      0: FixedColumnWidth(100), // MSSV column
                      1: FlexColumnWidth(), // Name column
                      2: FixedColumnWidth(100), // QT Score column
                      3: FixedColumnWidth(100), // CK Score column
                    },
                    children: [
                      // Table header
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
                                child: Text("Điểm QT",
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
                                child: Text("Điểm CK",
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
                            // QT Score input
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      student['qtScore'] = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Nhập điểm QT',
                                  ),
                                ),
                              ),
                            ),
                            // CK Score input
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      student['ckScore'] = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Nhập điểm CK',
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

            // Confirm Button aligned to bottom-right
            Align(
              alignment: Alignment.bottomRight,
              child: CustomButton(
                text: "Xác nhận",
                onPressed: () {
                  // Handle form submission
                },
                width: 0.3,
                height: 0.06,
                borderRadius: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
