import 'package:flutter/material.dart';
import 'package:project/components/custom_button.dart';
import 'package:project/components/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart'; // For picking files
import 'dart:io'; // For working with files
import 'package:intl/intl.dart'; // For formatting the date
import 'package:project/provider/LeaveRequestProvider.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  _LeaveRequestScreenState createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  DateTime? selectedDate;
  File? _pickedFile; // To store the picked file
  final _titleController = TextEditingController();
  final _reasonController = TextEditingController();

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Function to pick a file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
      });
    }
  }

  // Function to validate the form
  bool _validateForm() {
    if (_titleController.text.isEmpty ||
        _reasonController.text.isEmpty ||
        selectedDate == null ||
        _pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng điền đầy đủ thông tin."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  // Function to submit the leave request
  Future<void> _submitRequest(BuildContext context) async {
    if (!_validateForm()) return;

    final provider = Provider.of<LeaveRequestProvider>(context, listen: false);
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);

    try {
      await provider.requestLeave(
        classId:
            _titleController.text, // Replace with dynamic classId if needed
        date: formattedDate,
        reason: _reasonController.text,
        filePath: _pickedFile!.path,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đã gửi yêu cầu nghỉ phép thành công."),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop(); // Go back after successful submission
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gửi yêu cầu thất bại: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Add this if you want to pop the page
          },
        ),
        flexibleSpace: const Center(
          child: Text("Nghỉ phép",
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        backgroundColor: Colors.red[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(
              label: "Tiêu đề",
              controller: _titleController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: "Lý do",
              isMultiline: true,
              controller: _reasonController,
            ),
            const SizedBox(height: 10),
            Text(
              "Và",
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: "Tải minh chứng",
              onPressed: _pickFile, // Handle file upload
            ),
            const SizedBox(height: 10),

            // Show the file name if a file is picked
            if (_pickedFile != null)
              Text(
                "Đã chọn file: ${_pickedFile!.path.split('/').last}",
                style: const TextStyle(color: Colors.green),
              ),

            const SizedBox(height: 10),
            InkWell(
              onTap: () => _selectDate(context), // Show date picker when tapped
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red[700]!, width: 2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate != null
                          ? _dateFormat.format(selectedDate!)
                          : "Ngày nghỉ phép", // Placeholder text
                      style: TextStyle(
                        color:
                            selectedDate != null ? Colors.black : Colors.grey,
                      ),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.red),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Submit",
              onPressed: () => _submitRequest(context),
              width: 0.3,
              height: 0.06,
              borderRadius: 5,
            ),
          ],
        ),
      ),
    );
  }
}
