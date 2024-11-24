import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project/model/Survey.dart';
import 'package:provider/provider.dart';

import '../../DocumentVIewer.dart';
import '../../provider/SurveyProvider.dart';
import '../myAppBar.dart';

class StudentSubmitSurvey extends StatefulWidget {
  final Survey survey;
  StudentSubmitSurvey({required this.survey});

  @override
  State<StudentSubmitSurvey> createState() => _StudentSubmitSurveyState();
}

class _StudentSubmitSurveyState extends State<StudentSubmitSurvey> {
  final TextEditingController descriptionController = TextEditingController();
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


  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context);
    return Scaffold(
      appBar: MyAppBar(check: true, title: "EHUST-STUDENT"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${widget.survey.classId} - ${widget.survey.title}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Text(
                '${widget.survey.deadline}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Text(
                '${widget.survey.description}',
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              // Link Google Drive ở đây
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoogleDriveViewer(
                          driveUrl: widget.survey.fileUrl!
                      ),
                    ),
                  );
                },
                child: Text(
                  'Mở tài liệu hướng dẫn',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Nộp bài kiểm tra',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
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
              SizedBox(height: 20),
              _file != null
                  ? Text("Tệp đã chọn: ${_file!.path.split('/').last}")
                  : Text("Chưa chọn tệp"),
              SizedBox(height: 16),
              OutlinedButton(
                onPressed: _pickFile,
                child: Text('Tải tài liệu lên'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red),
                ),
              ),
              SizedBox(height: 16),
              if (surveyProvider.isLoading) const CircularProgressIndicator(),
              OutlinedButton(
                onPressed: (){
                  print(widget.survey);
                  if(_file !=null) {surveyProvider.submit_survey(context, _file!, widget.survey.id.toString(), descriptionController.text, widget.survey.classId!);}
                  else {
                    _showSuccessSnackbar(context, "Thêm file để nộp", Colors.red);
                  }
                },
                child: Text('Nộp bài'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showSuccessSnackbar(BuildContext context, String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10), // Thêm khoảng cách
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
