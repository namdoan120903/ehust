import 'package:flutter/material.dart';
import 'package:project/model/Class.dart';
import 'package:project/screens/myAppBar.dart';
import 'package:provider/provider.dart';

import '../../provider/ClassProvider.dart';

class LecturerEditClass extends StatefulWidget {
  @override
  State<LecturerEditClass> createState() => _LecturerCreateClassState();
}

class _LecturerCreateClassState extends State<LecturerEditClass> {
  DateTime? startDate;
  DateTime? endDate;
  String selectedClassType = 'ACTIVE'; // Giá trị mặc định
  List<String> items = ['ACTIVE', 'COMPLETED', 'UPCOMING'];
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController classIdController = TextEditingController();
  TextEditingController classNameController = TextEditingController();

  void _showDeleteDialog(BuildContext context, ClassProvider classProvider,
      String classId, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác Nhận Xóa'),
          content: Text('Bạn có chắc chắn muốn xóa mục này không?'),
          actions: [
            // Nút "Không"
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Không'),
            ),
            // Nút "Có"
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                classProvider.deleteClass(context, classId, index);
                print('Mục đã bị xóa');
              },
              child: Text('Có'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    int? selectedClassId = ModalRoute.of(context)!.settings.arguments as int?;
    final classProvider = Provider.of<ClassProvider>(context);
    selectedClassId = selectedClassId! > classProvider.classes.length - 1
        ? classProvider.classes.length - 1
        : selectedClassId;
    Class classEdit = classProvider.classes[selectedClassId!];
    classIdController = TextEditingController(text:classEdit.classId );
    return Scaffold(
        appBar: MyAppBar(check: true, title: "EHUST-LECTURER"),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
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
                  _buildTextField(classIdController, 'Mã lớp'),
                  SizedBox(height: 8),
                  _buildTextField(classNameController, 'Tên lớp'),
                  SizedBox(height: 8),
                  _buildDropdown(selectedClassType, items, (newValue) {
                    setState(() {
                      selectedClassType = newValue!;
                      print(selectedClassType);
                    });
                  }, 'Trạng thái lớp'),
                  SizedBox(height: 8),
                  _buildDatePicker(context, 'Ngày bắt đầu', true),
                  SizedBox(height: 8),
                  _buildDatePicker(context, 'Ngày kết thúc', false),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Phân tán đều
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: () {
                            print(selectedClassType);
                            classProvider.updateClass(
                                context,
                                selectedClassId!,
                                classIdController.text,
                                classNameController.text,
                                selectedClassType,
                                startDateController.text == ""
                                    ? classEdit.startDate!
                                    : startDateController.text,
                                endDateController.text == ""
                                    ? classEdit.endDate!
                                    : endDateController.text);
                          },
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 15),
                          ),
                          child: Text('Chỉnh sửa lớp học'),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            _showDeleteDialog(context, classProvider,
                                classIdController.text, selectedClassId!);
                            setState(() {
                              selectedClassId = 0;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 15),
                              backgroundColor: Colors.red),
                          child: Text('Xoa lớp học'),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildTextField(TextEditingController controller, String label) {
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

  Widget _buildDropdown(String selectedValue, List<String> items,
      ValueChanged<String?> onChanged, String label) {
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

  Widget _buildDatePicker(
    BuildContext context,
    String label,
    bool isStartDate,
  ) {
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
            initialDate:
                isStartDate ? DateTime.now() : (endDate ?? DateTime.now()),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (selectedDate != null) {
            setState(() {
              if (isStartDate) {
                startDateController.text =
                    selectedDate.toLocal().toString().split(' ')[0];
              } else {
                endDateController.text =
                    selectedDate.toLocal().toString().split(' ')[0];
              }
            });
          }
        },
        controller: TextEditingController(
          text: isStartDate ? startDateController.text : endDateController.text,
        ));
  }
}
