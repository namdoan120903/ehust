import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constant {
  static const String baseUrl = "http://157.66.24.126:8080";
  static void showSuccessSnackbar(BuildContext context, String text, Color color) {
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