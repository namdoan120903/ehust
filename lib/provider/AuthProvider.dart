import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../model/User.dart';

class AuthProvider with ChangeNotifier{
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  bool _isLoading = false;
  bool _locked=false;
  String? _haveCode ;
  bool _isLogin = false;
  String? _token;
  String? _role;
  User _user = User();
  String? _verify_code="";

  User get user => _user;
  set user(User newUser) {
    _user = newUser;
    notifyListeners();
  }
  bool get isLogin => _isLogin;
  bool get isLoading => _isLoading;
  bool get locked => _locked;
  String? get haveCode => _haveCode;
  String? get token => _token;
  String? get role => _role;

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
          ],
        );
      },
    );
  }

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
        _isLogin = true;
        _user = User.fromJson(jsonDecode(response.body)['data']);
        _secureStorage.write(key: 'token', value: _user.token);
        print(_user);
        if(_user.role == "STUDENT"){
          Navigator.pushNamed(context, '/student');
        }
        if(_user.role == "LECTURER"){
          Navigator.pushNamed(context, '/lecturer');
        }

      }else if(response.statusCode == 403){
        _locked = true;
        verifyCode(context, email, password, _verify_code!);
        notifyListeners();
      }
      else {
        _showErrorDialog(context, "Có lôĩ xảy ra, vui lòng thử lại");
      }
    } catch (e) {
      _showErrorDialog(context, "Có lỗi xảy ra, vui lòng thử lại Exception");
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
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('http://160.30.168.228:8080/it4788/signup'), // Thay đổi URL cho API thực tế
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print(response.body);
        Navigator.pushNamed(context, '/signin');
        _verify_code = jsonDecode(response.body)['verify_code'];
        print(_verify_code);
        notifyListeners();
      } else {
        _showErrorDialog(context, "Đăng kí thất bại, vui lòng thu lại");
      }
    } catch (e) {
      print("Lỗi khi gửi request: $e");
      _showErrorDialog(context, "CÓ lỗi xảy ra");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> verifyCode(BuildContext context,String email,String password, String code) async {
    final Map<String, dynamic> requestBody = {
      "email": email,
      "verify_code": code,
    };
    print("dksjdoaskdas $requestBody");
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('http://160.30.168.228:8080/it4788/check_verify_code'), // Thay đổi URL cho API thực tế
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print(response.body);
        _showErrorDialog(context, "Kích hoạt tài khoản thành công");
        _locked = false;
        notifyListeners();
        login(context, email, password);
      } else {
        // Xử lý nếu đăng ký thất bại
        print("Đăng ký thất bại: ${response.body}");
        _showErrorDialog(context, "Có lỗi xảy ra, vui lòng thử lại");
      }
    } catch (e) {
      print("Lỗi khi gửi request: $e");
      _showErrorDialog(context, "Có lỗi xảy ra, vui lòng thử lại");
    }
    _isLoading = false;
    notifyListeners();
  }

}


