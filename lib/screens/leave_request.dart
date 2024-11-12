import 'package:flutter/material.dart';
import 'package:project/components/custom_button.dart';
import 'package:project/components/custom_text_field.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:image_picker/image_picker.dart'; // For picking images
import 'dart:io'; // For working with files

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  _LeaveRequestScreenState createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  DateTime? selectedDate;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  File? _pickedImage; // To store the picked image
  bool _isUploadSuccessful = false; // Track upload status

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

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
        _isUploadSuccessful = true; // Simulate upload success after selection
      });
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
            const CustomTextField(label: "Tiêu đề"),
            const SizedBox(height: 20),
            const CustomTextField(label: "Lý do", isMultiline: true),
            const SizedBox(height: 10),
            Text(
              "Và",
              style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: "Tải minh chứng",
              onPressed: _pickImage, // Handle file upload
            ),
            const SizedBox(height: 10),

            // Show success message if image upload is successful
            if (_isUploadSuccessful)
              const Text(
                "Tải minh chứng thành công",
                style: TextStyle(color: Colors.green),
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
              onPressed: () {
                // Handle form submission
              },
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