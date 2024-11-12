import 'package:flutter/material.dart';

import '../myAppBar.dart';

class StudentClassRegister extends StatefulWidget {
  const StudentClassRegister({super.key});

  @override
  State<StudentClassRegister> createState() => _StudentClassRegisterState();
}

class _StudentClassRegisterState extends State<StudentClassRegister> {
  final List<Map<String, String>> classData = [
    {'id': '101', 'name': 'Lớp Toán', 'status': 'Đang hoạt động'},
    {'id': '102', 'name': 'Lớp Lý', 'status': 'Đã kết thúc'},
    {'id': '103', 'name': 'Lớp Hóa', 'status': 'Đang hoạt động'},
    {'id': '104', 'name': 'Lớp Sinh', 'status': 'Đang hoạt động'},
    {'id': '105', 'name': 'Lớp Văn', 'status': 'Đã kết thúc'},
    {'id': '106', 'name': 'Lớp Anh', 'status': 'Đang hoạt động'},
    {'id': '107', 'name': 'Lớp Tin', 'status': 'Đang hoạt động'},
    {'id': '108', 'name': 'Lớp GDCD', 'status': 'Đã kết thúc'},
    {'id': '109', 'name': 'Lớp Địa', 'status': 'Đang hoạt động'},
    {'id': '110', 'name': 'Lớp Thể Dục', 'status': 'Đang hoạt động'},
  ];
  late List<bool> isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = List<bool>.filled(classData.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(check: true, title: "EHUST-STUDENT"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Đăng kí lớp học',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Mã lớp',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: Text('Thêm'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Center(child: Text('Mã lớp'))),
                  Expanded(child: Center(child: Text('Tên lớp'))),
                  Expanded(child: Center(child: Text('Trạng thái'))),
                  Expanded(child: Center(child: Text('Chọn'))),
                ],
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView(
                  children: classData.asMap().entries.map((entry) {
                    int index = entry.key; // Lấy index
                    var classInfo = entry.value; // Lấy thông tin lớp học
                    return _buildClassRow(
                      classInfo['id']!,
                      classInfo['name']!,
                      classInfo['status']!,
                      index, // Truyền index vào hàm
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {

                  },
                  child: Text('Gửi đăng kí'),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {

                  },
                  child: Text('Xóa lớp'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassRow(String classId, String className, String status, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Container(
        height: 50,
        color: Colors.grey[300],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(width: 50, child: Center(child: Text(classId))),
            Container(width: 100, child: Center(child: Text(className))),
            Container(width: 100, child: Center(child: Text(status))),
            Container(width: 50, child: Center(child: Checkbox(
              value: isChecked[index],
              onChanged: (value) {
                setState(() {
                  isChecked[index] = value!;
                });
              },
            ),)),
          ],
        ),
      ),
    );
  }
}
