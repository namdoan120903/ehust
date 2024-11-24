import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project/provider/MaterialProvider.dart';
import 'package:provider/provider.dart';

import '../myAppBar.dart';

class CreateMaterial extends StatefulWidget {
  final String? classId;
  CreateMaterial({required this.classId});

  @override
  State<CreateMaterial> createState() => _CreateMaterialState();
}

class _CreateMaterialState extends State<CreateMaterial> {
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

  @override
  Widget build(BuildContext context) {
    final materialProvider = Provider.of<MaterialProvider>(context);
    return Scaffold(
        appBar: MyAppBar(check: true, title: "EHUST-LECTURER"),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:SingleChildScrollView( child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Thêm tài liệu mới',
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
              if (materialProvider.isLoading) const CircularProgressIndicator(),
              OutlinedButton(
                onPressed: () {
                  materialProvider.create_material(context, _file!, widget.classId!, nameController.text, descriptionController.text);
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
