import 'package:flutter/material.dart';
import 'package:project/screens/myAppBar.dart';

class LecturerEditClass extends StatefulWidget {
  @override
  State<LecturerEditClass> createState() => _LecturerCreateClassState();
}

class _LecturerCreateClassState extends State<LecturerEditClass> {

  final TextEditingController classCodeController = TextEditingController();
  final TextEditingController additionalClassCodeController = TextEditingController();
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController courseCodeController = TextEditingController();
  final TextEditingController classTypeController = TextEditingController();
  final TextEditingController maxStudentsController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: MyAppBar(check: true, title: "EHUST-LECTURER"),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:SingleChildScrollView(

            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Chỉnh sửa lớp học',
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
                  _buildTextField(additionalClassCodeController, 'Mã lớp kèm'),
                  SizedBox(height: 8),
                  _buildTextField(classNameController, 'Tên lớp'),
                  SizedBox(height: 8),
                  _buildTextField(courseCodeController, 'Mã học phần'),
                  SizedBox(height: 8),
                  _buildTextField(classTypeController, 'Loại lớp'),
                  SizedBox(height: 8),
                  _buildDatePicker(context, 'Ngày bắt đầu', true),
                  SizedBox(height: 8),
                  _buildDatePicker(context, 'Ngày kết thúc', false),
                  SizedBox(height: 8),
                  _buildTextField(maxStudentsController, 'Sinh viên tối đa'),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Thực hiện hành động khi nhấn nút
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 20),
                      ),
                      child: Text('Tạo lớp học'),
                    ),
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
}
