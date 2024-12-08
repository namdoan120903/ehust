import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project/provider/AuthProvider.dart';
import 'package:project/provider/ClassProvider.dart';
import 'package:project/screens/myAppBar.dart';
import 'package:provider/provider.dart';

class LecturerCreateClass extends StatefulWidget {
  @override
  State<LecturerCreateClass> createState() => _LecturerCreateClassState();
}

class _LecturerCreateClassState extends State<LecturerCreateClass> {

  final TextEditingController classCodeController = TextEditingController();
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController classTypeController = TextEditingController();
  final TextEditingController maxStudentsController = TextEditingController();

  String selectedClassType = 'LT'; // Giá trị mặc định
  List<String> items = ['LT', 'BT', 'LT_BT'];

  DateTime? startDate;
  DateTime? endDate;
  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);
    return Scaffold(

      appBar: MyAppBar(check: true, title: "EHUST-LECTURER"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:SingleChildScrollView(

         child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Tạo lớp học mới',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildTextField(classCodeController, 'Mã lớp'),
              SizedBox(height: 8),
              _buildTextField(classNameController, 'Tên lớp'),
              SizedBox(height: 8),
              _buildDropdown(selectedClassType, items, (newValue) {
                setState(() {
                  selectedClassType = newValue!;
                });
              }, 'Loại lớp'),
              SizedBox(height: 8),
              _buildDatePicker(context, 'Ngày bắt đầu', true),
              SizedBox(height: 8),
              _buildDatePicker(context, 'Ngày kết thúc', false),
              SizedBox(height: 8),
              _buildTextField(maxStudentsController, 'Sinh viên tối đa'),
              SizedBox(height: 16),
              if (classProvider.isLoading) const CircularProgressIndicator(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final int num = int.parse(maxStudentsController.text);
                    if(num >50 || num< 0) {
                      _showSuccessSnackbar(context, "Giới hạn lớp là 50", Colors.red);
                    }else if(classCodeController.text.length !=6){
                      _showSuccessSnackbar(context, "Mã lớp phải có 6 số", Colors.red);
                    }else{
                      classProvider.createClass(
                          context,
                          classCodeController.text,
                          classNameController.text,
                          selectedClassType,
                          startDate.toString().substring(0, 10),
                          endDate.toString().substring(0, 10),
                          maxStudentsController.text);
                    }
                    },
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 20),
                  ),
                  child: Text('Tạo lớp học'),
                )
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Thông tin các lớp đang mở',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),)
    );
  }

  Widget _buildTextField(TextEditingController controller,String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdown(String selectedValue, List<String> items, ValueChanged<String?> onChanged, String label) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, String label, bool isStartDate) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today, color: Colors.red),
      ),
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: isStartDate ? DateTime.now() : (endDate ?? DateTime.now()),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (selectedDate != null) {
          setState(() {
            if (isStartDate) {
              startDate = selectedDate;
            } else {
              endDate = selectedDate;
            }
          });
        }
      },
      controller: TextEditingController(text: isStartDate ? startDate?.toLocal().toString().split(' ')[0] : endDate?.toLocal().toString().split(' ')[0]),
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
