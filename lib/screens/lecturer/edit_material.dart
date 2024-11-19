import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project/model/MyMaterial.dart';
import 'package:provider/provider.dart';

import '../../provider/MaterialProvider.dart';
import '../myAppBar.dart';

class EditMaterial extends StatefulWidget {
  final MyMaterial material;
  final int index;
  const EditMaterial({required this.material, required this.index});

  @override
  State<EditMaterial> createState() => _EditMaterialState();
}

class _EditMaterialState extends State<EditMaterial> {
  File? _file;
  late TextEditingController nameController;

  late TextEditingController descriptionController;


  @override
  void initState() {
    super.initState();

    // Gán giá trị ban đầu cho TextEditingController
    nameController = TextEditingController(text: widget.material.materialName);
    descriptionController = TextEditingController(text: widget.material.description);
  }
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
                'Chỉnh sửa tài liệu',
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
                  materialProvider.edit_material(context, _file!, widget.material.id.toString() ,nameController.text, descriptionController.text, widget.index);
                },
                child: Text('Chỉnh sửa tài liệu'),
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
