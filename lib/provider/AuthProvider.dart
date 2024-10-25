import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier{
  bool _isLoading = false;
  String? _errorMessage;
  bool _locked=false;
  String? _haveCode ;
  bool _isLogin = false;

  bool get isLogin => _isLogin;
  bool get isLoading => _isLoading;
  bool get locked => _locked;
  String? get haveCode => _haveCode;
  String? get errorMessage => _errorMessage;

  Future<void> login(BuildContext context,String email, String password) async {
    int deviceId = 1;
    final Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
      "deviceId": deviceId,
    };
    print(requestBody);
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://160.30.168.228:8080/it4788/login'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print(response.body);
        Navigator.pushNamed(context, '/studenthome');
      }if(response.statusCode == 403){
        _locked = true;
        checkCode(context, email, password);
      }
      else {
        // Xử lý khi đăng nhập thất bại
        print(response.body);
      }
    } catch (e) {
      _errorMessage = "Có lỗi xảy ra, vui lòng thử lại.";
    }

    _isLoading = false;
    notifyListeners();
  }


  Future<void> signUp(BuildContext context,String surname, String name, String email, String password, String role) async {
    final Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
      "role": role,
      "uuid": 11111,
    };
    print("dksjdoaskdas $requestBody");

    try {
      final response = await http.post(
        Uri.parse('http://160.30.168.228:8080/it4788/signup'), // Thay đổi URL cho API thực tế
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print(response.body);
        Navigator.pushNamed(context, '/signin');
      } else {
        // Xử lý nếu đăng ký thất bại
        print("Đăng ký thất bại: ${response.body}");
      }
    } catch (e) {
      print("Lỗi khi gửi request: $e");
    }
  }

  Future<void> checkCode(BuildContext context,String email, String password) async {
    final Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };
    print("dksjdoaskdas $requestBody");

    try {
      final response = await http.post(
        Uri.parse('http://160.30.168.228:8080/it4788/get_verify_code'), // Thay đổi URL cho API thực tế
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.body),
            backgroundColor: Colors.green,
          ),
        );
        RegExp regExp = RegExp(r'code sent: (\w+)');
        Match? match = regExp.firstMatch(response.body);
        _haveCode = match?.group(1);
        notifyListeners();
      } else {
        // Xử lý nếu đăng ký thất bại
        print("Đăng ký thất bại: ${response.body}");
      }
    } catch (e) {
      print("Lỗi khi gửi request: $e");
    }
  }

  Future<void> verifyCode(BuildContext context,String email, String code) async {
    final Map<String, dynamic> requestBody = {
      "email": email,
      "code": code,
    };
    print("dksjdoaskdas $requestBody");

    try {
      final response = await http.post(
        Uri.parse('http://160.30.168.228:8080/it4788/verify_code'), // Thay đổi URL cho API thực tế
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Kích hoạt tài khoản thành công"),
            backgroundColor: Colors.green,
          ),
        );
        _haveCode = null;
        _locked = false;
        notifyListeners();
      } else {
        // Xử lý nếu đăng ký thất bại
        print("Đăng ký thất bại: ${response.body}");
      }
    } catch (e) {
      print("Lỗi khi gửi request: $e");
    }
  }

}


