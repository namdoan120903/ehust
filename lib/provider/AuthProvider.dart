import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project/Constant.dart';

import '../model/User.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  bool _isLoading = false;
  bool _locked = false;
  String? _haveCode;
  bool _isLogin = false;
  String? _token;
  String? _role;
  User _user = User();
  String? _verify_code = "";
  String? fileId;

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

  Future<void> login(
      BuildContext context, String email, String password) async {
    int deviceId = 1;
    final Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
      "device_id": deviceId,
      "fcm_token": ""
    };
    print(requestBody);
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it4788/login'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      String code = jsonDecode(response.body)['code'].toString();
      if (response.statusCode == 200) {
        print(response.body);
        _isLogin = true;
        final responseBody = utf8.decode(response.bodyBytes);
        _user = User.fromJson(jsonDecode(responseBody)['data']);
        _secureStorage.write(key: 'token', value: _user.token);
        String url = _user.avatar!;
        if (url != "")
          fileId = url.substring(url.indexOf('d/') + 2, url.indexOf('/view'));
        print(_user);
        if (_user.role == "STUDENT") {
          Navigator.pushNamed(context, '/student');
        }
        if (_user.role == "LECTURER") {
          Navigator.pushNamed(context, '/lecturer');
        }
        _showSuccessSnackbar(context, "Đăng nhâp thành công", Colors.green);
      } else if (response.statusCode == 403) {
        _locked = true;
        if (_verify_code == "") await getVerifyCode(context, email, password);

        verifyCode(context, email, password, _verify_code!);
        notifyListeners();
      } else if (code == "1011") {
        _showSuccessSnackbar(
            context, "Email không đúng định dạng @hust.edu.vn", Colors.red);
      } else if (code == "1016") {
        _showSuccessSnackbar(context,
            "Không tồn tại tài khoản này, vui lòng thử lại", Colors.red);
      } else if (code == "1017") {
        _showSuccessSnackbar(
            context, "Mật khẩu sai, vui lòng thử lại", Colors.red);
      } else {
        _showErrorDialog(context, response.body.toString());
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signUp(BuildContext context, String surname, String name,
      String email, String password, String role) async {
    final Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
      "role": role,
      "uuid": 11111,
      "ho": surname,
      "ten": name
    };
    print("dksjdoaskdas $requestBody");
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse(
            '${Constant.baseUrl}/it4788/signup'), // Thay đổi URL cho API thực tế
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      String code = jsonDecode(response.body)['code'].toString();
      if (response.statusCode == 200) {
        print(response.body);
        Navigator.pushNamed(context, '/signin');
        _verify_code = jsonDecode(response.body)['verify_code'];
        print(_verify_code);
        _showSuccessSnackbar(context, "Đăng kí thành công", Colors.green);
        notifyListeners();
      } else if (code == "1011") {
        _showSuccessSnackbar(
            context, "Email không đúng định dạng @hust.edu.vn", Colors.red);
      } else if (code == "9996") {
        _showSuccessSnackbar(
            context, "Tài khoản đã tồn tại với email này", Colors.red);
      } else if (code == "1015") {
        _showSuccessSnackbar(
            context, "Mật khẩu không nên chứa các kí tự đặc biệt", Colors.red);
      } else {
        _showErrorDialog(context, response.body);
      }
    } catch (e) {
      print("Lỗi khi gửi request: $e");
      _showErrorDialog(context, "CÓ lỗi xảy ra");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> verifyCode(
      BuildContext context, String email, String password, String code) async {
    final Map<String, dynamic> requestBody = {
      "email": email,
      "verify_code": code,
    };
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse(
            '${Constant.baseUrl}/it4788/check_verify_code'), // Thay đổi URL cho API thực tế
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print(response.body);
        _showSuccessSnackbar(
            context, "Kích hoạt tài khoản thành công", Colors.green);
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

  Future<void> getVerifyCode(
      BuildContext context, String email, String password) async {
    final Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse(
            '${Constant.baseUrl}/it4788/get_verify_code'), // Thay đổi URL cho API thực tế
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print(response.body);
        _verify_code = jsonDecode(response.body)['verify_code'];
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

  Future<void> changePassword(
      BuildContext context, String oldPass, String newPass) async {
    String? token = await _secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "old_password": oldPass,
      "new_password": newPass
    };
    print(requestBody);

    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it4788/change_password'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      String code = jsonDecode(response.body)['code'].toString();
      if (response.statusCode == 200) {
        Navigator.pop(context);
        _showSuccessSnackbar(
            context, "Thay đổi mật khẩu thanh công", Colors.green);
        notifyListeners();
      } else if (code == "1018") {
        _showSuccessSnackbar(
            context,
            "Mật khẩu mới liên quan đến mật khẩu cũ, vui lòng đặt lại",
            Colors.red);
      } else {
        _showErrorDialog(context, response.body.toString());
      }
    } catch (e) {
      _showErrorDialog(context, "Có lỗi xảy ra, vui lòng thử lại Exception");
    }
  }

  Future<void> changeInfo(
      BuildContext context, File uploadFile, String name) async {
    String? token = await _secureStorage.read(key: 'token');
    try {
      var request = http.MultipartRequest('POST',
          Uri.parse("${Constant.baseUrl}/it4788/change_info_after_signup"));

      // Thêm các trường văn bản (text)
      request.fields['token'] = token!;
      //request.fields['name'] = name;

      // Thêm tệp vào request mà không cần chỉ định contentType
      var file = await http.MultipartFile.fromPath(
        'file', // Tên trường file trong form
        uploadFile.path, // Đường dẫn đến tệp
      );
      request.files.add(file);
      // Kiểm tra các trường và file đã thêm
      print("Fields: ${request.fields}");
      print("Files: ${request.files.map((f) => f.filename)}");
      // Thêm header nếu cần
      request.headers['Content-Type'] = 'multipart/form-data';

      _isLoading = true;
      notifyListeners();
      var response = await request.send();
      print('send request');
      var responseBody = await http.Response.fromStream(response);
      String code = jsonDecode(responseBody.body)['code'].toString();
      print(responseBody.body);
      if (response.statusCode == 200) {
        _user.avatar =
            User.fromJson(jsonDecode(responseBody.body)['data']).avatar;
        String url = _user.avatar!;
        if (url != "")
          fileId = url.substring(url.indexOf('d/') + 2, url.indexOf('/view'));
        _showSuccessSnackbar(
            context, "Cập nhật thông tin thành công", Colors.green);
        Navigator.pop(context);
        notifyListeners();
      } else if (code == "1011") {
        _showSuccessSnackbar(
            context, "Email không đúng định dạng @hust.edu.vn", Colors.red);
      } else {
        print(responseBody.body);
      }
    } catch (e) {
      print(e.toString());
      _showErrorDialog(context, e.toString());
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    String? token = await _secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
    };
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it4788/logout'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        _user = User();
        _secureStorage.delete(key: 'token');
        Navigator.pushNamed(context, '/signin');
        _showSuccessSnackbar(context, "Đăng xuất thành công", Colors.green);
        notifyListeners();
      } else {
        _showErrorDialog(context, response.body.toString());
      }
    } catch (e) {
      _showErrorDialog(context, "Có lỗi xảy ra, vui lòng thử lại Exception");
    }
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

  Future<List<Map<String, dynamic>>> searchAccount(String searchQuery) async {
    final String url = 'http://160.30.168.228:8080/it5023e/search_account';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'search': searchQuery,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Ensure response has 'data' and 'meta'
        if (responseData['meta']['code'] == 1000 &&
            responseData['data'] is List) {
          return List<Map<String, dynamic>>.from(responseData['data']);
        } else {
          throw Exception(
              'Invalid response structure: ${responseData['meta']['message']}');
        }
      } else {
        throw Exception(
            'Failed to fetch accounts. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching accounts: $error');
    }
  }
}
