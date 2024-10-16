import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier{
  bool _isLoaing = false;
  String? _errorMessage;

  bool get isLoaing => _isLoaing;
  String? get errorMessage => _errorMessage;

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = "Vui lòng điền đầy đủ thông tin";
      notifyListeners();
      return;
    }

    _isLoaing = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://api.example.com/login'),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        _errorMessage = null;
      } else {
        // Xử lý khi đăng nhập thất bại
        _errorMessage = "Đăng nhập thất bại. Vui lòng thử lại.";
      }
    } catch (e) {
      _errorMessage = "Có lỗi xảy ra, vui lòng thử lại.";
    }

    _isLoaing = false;
    notifyListeners();
  }
}


