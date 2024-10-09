import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isMultiline;

  const CustomTextField({
    Key? key,
    required this.label,
    this.isMultiline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines:
          isMultiline ? 6 : 1, // Set max lines to 3 if isMultiline is true
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.red[700]),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red[700]!, width: 2),
        ),
      ),
    );
  }
}
