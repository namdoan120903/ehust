import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project/model/Class.dart';
import 'package:provider/provider.dart';

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

  final secureStorage = FlutterSecureStorage();
  String? token;
  bool _isLoading = false;
  List<Class> classes = [];
  List<Class> registerClass = [];

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
    print("START CREATE CLASS!");
    print(requestBody);
    try {
      final response = await http.post(
        Uri.parse('http://160.30.168.228:8080/it5023e/create_class'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      print(response.body);
      if (response.statusCode == 200) {
        Class newClass = Class.fromJson(json.decode(response.body)['data']);
        classes.add(newClass);
        _showErrorDialog(context, "Tạo lớp học mới thành công");
        notifyListeners();
      } else {
        _showErrorDialog(context, "Có lôĩ xảy ra, vui lòng thử lại");
      }
    } catch (e) {
      _showErrorDialog(context, "Có lỗi xảy ra, vui lòng thử lại Exception");
    }
  }

  Future<void> get_class_list(BuildContext context) async {
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
    };
    try {
      final response = await http.post(
        Uri.parse('http://160.30.168.228:8080/it5023e/get_class_list'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> jsonData = json.decode(responseBody);
        debugPrint(responseBody.toString());
        classes = (jsonData['data'] as List)
            .map((classJson) => Class.fromJson(classJson))
            .toList();
        print("lay du lieu thanh cong");
        debugPrint(classes.toString());
        notifyListeners();
      } else {
        _showErrorDialog(context, "Có lôĩ xảy ra, vui lòng thử lại");
      }
    } catch (e) {
      _showErrorDialog(context, "Có lỗi xảy ra, vui lòng thử lại Exception");
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
        Uri.parse('http://160.30.168.228:8080/it5023e/edit_class'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        classes[selectedId] =
            Class.fromJson(json.decode(response.body)['data']);
        _showErrorDialog(context, "Cap nhat lớp học thành công");
        print("lay du lieu thanh cong");
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
        Uri.parse('http://160.30.168.228:8080/it5023e/delete_class'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        classes.removeAt(index);
        _showErrorDialog(context, "Xoa lớp học thành công");
        notifyListeners();
      } else {
        _showErrorDialog(context, response.body.toString());
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
        Uri.parse('http://160.30.168.228:8080/it5023e/get_basic_class_info'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        print(response.body);
        final responseBody = utf8.decode(response.bodyBytes);
        Class newRegisterClass =
            Class.fromJson(json.decode(responseBody)['data']);
        if (registerClass.contains(newRegisterClass)) {
          _showErrorDialog(context, "da co lop nay roi");
        } else {
          registerClass.add(newRegisterClass);
        }
        notifyListeners();
      } else if (response.statusCode == 400) {
        _showErrorDialog(context, "Khong ton tai lop nay");
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
        Uri.parse('http://160.30.168.228:8080/it5023e/register_class'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        _showErrorDialog(context, "Dang ki lop thanh cong");
        registerClass = [];
        notifyListeners();
      } else {
        _showErrorDialog(context, response.body.toString());
      }
    } catch (e) {
      _showErrorDialog(context, "Có lỗi xảy ra, vui lòng thử lại Exception");
    }
  }
}
