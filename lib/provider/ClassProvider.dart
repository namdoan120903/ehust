import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project/model/Class.dart';
import 'package:project/model/StudentAccount.dart';
import 'package:provider/provider.dart';

import '../Constant.dart';

class ClassProvider with ChangeNotifier {
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

  final secureStorage = FlutterSecureStorage();
  String? token;
  bool isLoading = false;
  List<Class> classes = [];
  List<Class> registerClass = [];
  Class? getClassLecturer;
  List<Class> openClasss = [];

  String findNameById(String studentId) {
    for (StudentAccount studentAccount in getClassLecturer!.studentAccounts!) {
      if (studentAccount.studentId == studentId) {
        return "${studentAccount.lastName ?? ""} ${studentAccount.firstName ?? ""}"
            .trim();
      }
    }
    return "";
  }

  Future<void> createClass(
      BuildContext context,
      String classCode,
      String className,
      String classType,
      String start,
      String end,
      String amount) async {
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "class_id": classCode,
      "class_name": className,
      "class_type": classType,
      "start_date": start,
      "end_date": end,
      "max_student_amount": amount
    };
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/create_class'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      print(response.body);
      if (response.statusCode == 200) {
        Class newClass = Class.fromJson(json.decode(response.body)['data']);
        print(newClass);
        classes.add(newClass);
        _showSuccessSnackbar(
            context, "Tạo lớp học mới thành công", Colors.green);
        Navigator.pop(context);
        notifyListeners();
      } else if (response.statusCode == 400) {
        _showSuccessSnackbar(context, "Mã lớp đã tồn tại", Colors.red);
      } else {
        _showSuccessSnackbar(
            context, jsonDecode(response.body)['data'], Colors.red);
      }
    } catch (e) {
      print(e.toString());
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> get_class_list(BuildContext context) async {
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
    };
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/get_class_list'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> jsonData = json.decode(responseBody)['data'];

        classes = (jsonData['page_content'] as List)
            .map((classJson) => Class.fromJson(classJson))
            .toList();
        print("lay du lieu thanh cong");
        notifyListeners();
      } else {
        _showErrorDialog(context, "Có lôĩ xảy ra, vui lòng thử lại");
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
      print(e.toString());
    }
  }

  Future<void> updateClass(BuildContext context, int selectedId, String id,
      String name, String status, String start, String end) async {
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "class_id": id,
      "class_name": name,
      "status": status, //ACTIVE, COMPLETED, UPCOMING
      "start_date": start,
      "end_date": end
    };
    print(requestBody);
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/edit_class'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        classes[selectedId] =
            Class.fromJson(json.decode(response.body)['data']);
        _showSuccessSnackbar(
            context, "Cập nhật lớp học thành công", Colors.green);
        print(response.body);
        Navigator.pop(context);
        notifyListeners();
      } else {
        _showErrorDialog(context, response.body.toString());
      }
    } catch (e) {
      _showErrorDialog(context, "Có lỗi xảy ra, vui lòng thử lại Exception");
    }
  }

  Future<void> deleteClass(
      BuildContext context, String classId, int index) async {
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "class_id": classId,
    };
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/delete_class'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        classes.removeAt(index);
        _showSuccessSnackbar(context, "Xóa lớp học thành công", Colors.green);
        notifyListeners();
        Navigator.pop(context);
      } else {
        _showSuccessSnackbar(
            context, "Có lỗi xảy ra, không thể xóa lớp", Colors.red);
      }
    } catch (e) {
      _showErrorDialog(context, "Có lỗi xảy ra, vui lòng thử lại Exception");
    }
  }

  Future<void> getClassInfoStudent(BuildContext context, String classId) async {
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "class_id": classId,
    };
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/get_basic_class_info'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        print(response.body);
        final responseBody = utf8.decode(response.bodyBytes);
        Class newRegisterClass =
            Class.fromJson(json.decode(responseBody)['data']);
        if (registerClass.contains(newRegisterClass)) {
          _showSuccessSnackbar(
              context, "Đã tồn tại lớp này trong bảng đăng kí", Colors.red);
        } else {
          registerClass.add(newRegisterClass);
        }
        notifyListeners();
      } else if (response.statusCode == 400) {
        _showSuccessSnackbar(
            context, "Không tồn tại lớp có mã này", Colors.red);
      } else {
        _showErrorDialog(context, response.body.toString());
      }
    } catch (e) {
      _showErrorDialog(context, "Có lỗi xảy ra, vui lòng thử lại Exception");
    }
  }

  void removeRegisterClass(BuildContext context, List<bool> isChecked) {
    for (int i = isChecked.length - 1; i >= 0; i--) {
      if (isChecked[i]) {
        registerClass.removeAt(i);
      }
    }
    notifyListeners();
  }

  Future<void> registerStudentClass(BuildContext context) async {
    token = await secureStorage.read(key: 'token');
    final List<String?> classId =
        registerClass.map((item) => item.classId).toList();
    final Map<String, dynamic> requestBody = {
      "token": token,
      "class_ids": classId
    };
    print(requestBody);
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/register_class'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      print(response.body);
      if (response.statusCode == 200) {
        _showSuccessSnackbar(
            context, "Đăng kí danh sách lớp thành công", Colors.green);
        registerClass = [];
        get_class_list(context);
        notifyListeners();
      } else {
        _showErrorDialog(context, response.body.toString());
      }
    } catch (e) {
      _showErrorDialog(context, "Có lỗi xảy ra, vui lòng thử lại Exception");
    }
  }

  Future<void> getClassInfoLecturer(
      BuildContext context, String classId) async {
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "class_id": classId,
    };
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/get_class_info'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        getClassLecturer = Class.fromJson(json.decode(responseBody)['data']);
        print(getClassLecturer);
        notifyListeners();
      } else {
        _showErrorDialog(context, response.body.toString());
      }
    } catch (e) {
      _showErrorDialog(context, "Có lỗi xảy ra, vui lòng thử lại Exception");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getOpenClass(BuildContext context, String? classId,
      String? status, String? name, String? type) async {
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "class_id": classId!.isEmpty ? null : classId,
      "status": status, //ACTIVE, COMPLETED, UPCOMING
      "class_name": name!.isEmpty ? null : name,
      "class_type": type
    };
    print(requestBody);
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/get_classes_by_filter'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> jsonData = json.decode(responseBody)['data'];

        openClasss = (jsonData['page_content'] as List)
            .map((classJson) => Class.fromJson(classJson))
            .toList();
        notifyListeners();
      } else {
        print(response.body);
        _showSuccessSnackbar(
            context, "Không lấy được dữ liệu lớp mo", Colors.red);
      }
    } catch (e) {
      _showErrorDialog(context, "Có lỗi xảy ra, vui lòng thử lại Exception");
    }
  }
}
