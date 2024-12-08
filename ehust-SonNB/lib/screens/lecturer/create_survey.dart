import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project/provider/SurveyProvider.dart';
import 'package:project/screens/myAppBar.dart';
import 'package:provider/provider.dart';
class CreateSurvey extends StatefulWidget {
  final String? classId;
  CreateSurvey({required this.classId});
  @override
  State<CreateSurvey> createState() => _CreateSurveyState();
}

class _CreateSurveyState extends State<CreateSurvey> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

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

  Future<void> _selectDateTime(BuildContext context) async {
    // Bước 1: Chọn ngày
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      // Bước 2: Chọn giờ
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        // Bước 3: Kết hợp ngày và giờ đã chọn
        final DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        // Cập nhật giá trị của TextField với ngày và giờ đã chọn
        _dateController.text = "${selectedDateTime.toLocal().toIso8601String()}".split('.')[0];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context);
    return Scaffold(
      appBar: MyAppBar(check: true, title: "EHUST-LECTURER"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:SingleChildScrollView( child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Tạo bài kiểm tra',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Tên',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Mô tả',
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
                _selectDateTime(context); // Gọi hàm chọn ngày khi người dùng click vào
              },
            ),SizedBox(height: 20,),
            _file != null
                ? Text("Tệp đã chọn: ${_file!.path.split('/').last}")
                : Text("Chưa chọn tệp"),
            SizedBox(height: 16),
            OutlinedButton(
              onPressed:_pickFile,
              child: Text('Tải tài liệu lên'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red),
              ),
            ),
            SizedBox(height: 16),
            if (surveyProvider.isLoading) const CircularProgressIndicator(),
            OutlinedButton(
              onPressed: () {
                surveyProvider.create_survey(context, _file!, widget.classId!, nameController.text, _dateController.text, descriptionController.text);
              },
              child: Text('Tạo bài kiểm tra'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red),
              ),
            ),
          ],
        ),
      ),)
    );
  }
}
