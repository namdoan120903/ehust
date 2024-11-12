import 'package:flutter/material.dart';
import 'package:project/screens/myAppBar.dart';
import 'package:provider/provider.dart';

import '../../model/Class.dart';
import '../../provider/ClassProvider.dart';

class LecturerClass extends StatefulWidget {
  @override
  State<LecturerClass> createState() => _LecturerClassState();
}

class _LecturerClassState extends State<LecturerClass> {

  int? selectedClassId;

  @override
  void initState() {
    super.initState();
    // Lấy instance của ClassProvider mà không lắng nghe các thay đổi
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    classProvider.get_class_list(context);
    print(classProvider.classes.toString());
  }

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(check: true, title: "EHUST-LECTURER"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Quản lí lớp học',
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
                  onPressed: () {
                  },
                  child: Text('Tìm kiếm'),
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
                  children: classProvider.classes.asMap().entries.map((entry) {
                    final isSelected = selectedClassId == entry.key;
                    int index = entry.key; // Lấy index
                    var classInfo = entry.value; // Lấy thông tin lớp học
                    return _buildClassRow(
                      classInfo.classId!,
                      classInfo.className!,
                      classInfo.status!,
                      index,
                      isSelected// Truyền index vào hàm
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
                    Navigator.pushNamed(context, "/lecturer/class/create");
                  },
                  child: Text('Tạo lớp học'),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if(selectedClassId != null) Navigator.pushNamed(context, '/lecturer/class/edit', arguments: selectedClassId);
                    setState(() {
                      selectedClassId = null;
                    });
                  },
                  child: Text('Chỉnh sửa'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassRow(String classId, String className, String status, int index, bool isSelected) {
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
              value: isSelected,
              onChanged: (bool? value) {
              setState(() {
              if (value == true) {
              selectedClassId = index; // Chọn lớp này
                print(selectedClassId);
              } else {
              selectedClassId = null; // Bỏ chọn nếu checkbox bị bỏ
              }
              });}
            ),)),
          ],
        ),
      ),
    );
  }
}