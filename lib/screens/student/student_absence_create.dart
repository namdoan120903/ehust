import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project/provider/AbsenceProvider.dart';
import 'package:provider/provider.dart';

import '../myAppBar.dart';

class StudentAbsenceCreate extends StatefulWidget {
  final String? classId;
  StudentAbsenceCreate({required this.classId});

  @override
  State<StudentAbsenceCreate> createState() => _StudentAbsenceCreateState();
}

class _StudentAbsenceCreateState extends State<StudentAbsenceCreate> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController reasonController = TextEditingController();

  TextEditingController _dateController = TextEditingController();

  File? _file;

  Future<void> _pickFile() async {
    // Mở hộp thoại chọn tệp
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    } else {
      print("Chưa chọn tệp");
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    // Bước 1: Chọn ngày
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      // Cập nhật giá trị của TextField với ngày đã chọn
      _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
    }
  }


  @override
  Widget build(BuildContext context) {
    final absenceProvider = Provider.of<AbsenceProvider>(context);
    return Scaffold(
        appBar: MyAppBar(check: true, title: "EHUST-STUDENT"),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Thêm đơn xin nghỉ học mới',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Nhập tiêu đề',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: reasonController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Lí do xin nghỉ học',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Chọn ngày',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true, // Làm cho TextField không thể chỉnh sửa
                  onTap: () {
                    _selectDate(context); // Gọi hàm chọn ngày khi người dùng click vào
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                _file != null
                    ? Text("Tệp đã chọn: ${_file!.path.split('/').last}")
                    : Text("Chưa chọn tệp"),
                SizedBox(height: 16),
                OutlinedButton(
                  onPressed: _pickFile,
                  child: Text('Tải minh chứng lên'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                  ),
                ),
                SizedBox(height: 16),
                if (absenceProvider.isLoading)
                  const CircularProgressIndicator(),
                OutlinedButton(
                  onPressed: () {
                    if (_file != null) {
                      String extension = _file!.path.split('.').last;
                      absenceProvider.createAbsence(
                          context,
                          _file!,
                          widget.classId!,
                          titleController.text,
                          reasonController.text,
                          _dateController.text);
                    }
                  },
                  child: Text('Tạo bài kiểm tra'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
