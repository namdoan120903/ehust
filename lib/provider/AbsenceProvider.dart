import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project/model/Absence.dart';
import 'package:http/http.dart' as http;
import '../Constant.dart';

class AbsenceProvider with ChangeNotifier {
  final secureStorage = FlutterSecureStorage();
  bool isLoading = false;
  List<Absence> absences = [];
  String? token;


  Future<void> getAllAbsenceStudent(BuildContext context, String classId)async{
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "class_id": classId
    };
    print(requestBody);
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/get_student_absence_requests'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      print(response.body);
      final responseBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(responseBody);

        absences = await (jsonData['data']['page_content'] as List)
            .map((classJson) => Absence.fromJson(classJson))
            .toList();

        print(absences);
        notifyListeners();
      } else {
        Constant.showSuccessSnackbar(context, "Có lỗi xảy ra, vui lòng thử lại", Colors.red);
      }
    } catch (e) {
      Constant.showSuccessSnackbar(context, "Có lỗi xảy ra, vui lòng thử lại", Colors.red);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getAllAbsenceLecturer(BuildContext context, String classId)async{
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "class_id": classId
    };
    print(requestBody);
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/get_absence_requests'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      print(response.body);
      final responseBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(responseBody);

        absences = await (jsonData['data']['page_content'] as List)
            .map((classJson) => Absence.fromJson(classJson))
            .toList();

        print(absences);
        notifyListeners();
      } else {
        Constant.showSuccessSnackbar(context, responseBody, Colors.red);
      }
    } catch (e) {
      Constant.showSuccessSnackbar(context, "Có lỗi xảy ra, vui lòng thử lại", Colors.red);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> reviewAbsence(BuildContext context, String id, String status, String classId)async{
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "request_id": id,
      "status": status
    };
    print(requestBody);
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/review_absence_request'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      print(response.body);
      final responseBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        print(absences);
        Constant.showSuccessSnackbar(context, "Cập nhật trạng thái thành công", Colors.green);
        await getAllAbsenceLecturer(context, classId);
        Navigator.pop(context);
        notifyListeners();
      } else {
        Constant.showSuccessSnackbar(context, responseBody, Colors.red);
      }
    } catch (e) {
      // Constant.showSuccessSnackbar(context, e.toString(), Colors.red);
      Constant.showSuccessSnackbar(context, "Có lỗi xảy ra, vui lòng thử lại", Colors.red);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> createAbsence(BuildContext context, File uploadFile,
      String classId, String title, String reason, String date) async {
    token = await secureStorage.read(key: 'token');
    try{
      var request = http.MultipartRequest('POST', Uri.parse("${Constant.baseUrl}/it5023e/request_absence"));

      // Thêm các trường văn bản (text)
      request.fields['token'] = token!;
      request.fields['classId'] = classId;
      request.fields['date'] = date;
      request.fields['reason'] = reason;
      request.fields['title'] = title;

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

      isLoading = true;
      notifyListeners();
      var response = await request.send();
      print('send request');
      var responseBody = await http.Response.fromStream(response);
      print(responseBody.body);
      if (response.statusCode == 200) {
        await getAllAbsenceStudent(context, classId);
        notifyListeners();
        Navigator.pop(context);
      } else {
        Constant.showSuccessSnackbar(context, "Thời gian xin nghỉ không trong thời gian học", Colors.red);
      }
    } catch (e) {
      Constant.showSuccessSnackbar(context, e.toString(), Colors.red);
    }
    isLoading = false;
    notifyListeners();
  }
}