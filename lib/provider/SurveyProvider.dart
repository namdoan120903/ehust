import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project/model/Submission.dart';
import 'package:project/model/Survey.dart';

import '../Constant.dart';

class SurveyProvider with ChangeNotifier {
  final secureStorage = FlutterSecureStorage();
  String? token;
  List<Survey> surveys=[];
  bool isLoading = false;
  List<Survey> studentSurvey = [];
  List<Submission> submissions = [];
  Submission? selectSubmission;

  Future<void> create_survey(BuildContext context, File uploadFile,
      String classId, String title, String date, String des) async {
    token = await secureStorage.read(key: 'token');
    try{
    var request = http.MultipartRequest('POST', Uri.parse("${Constant.baseUrl}/it5023e/create_survey"));

      // Thêm các trường văn bản (text)
      request.fields['token'] = token!;
      request.fields['classId'] = classId;
      request.fields['title'] = title;
      request.fields['deadline'] = DateTime.parse(date).toIso8601String();
      request.fields['description'] = des;

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
    var responseBody = await http.Response.fromStream(response);
    String code = jsonDecode(responseBody.body)['meta']['code'].toString();
      if (response.statusCode == 200) {
        _showSuccessSnackbar(context, "Thêm bài kiểm tra mới thành công", Colors.green);
        notifyListeners();
        await getAllSurvey(context, classId);
        Navigator.pop(context);
      }else {
        print(responseBody.body);
      }
    } catch (e) {
      print(e.toString());
      _showErrorDialog(context, e.toString());
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> edit_survey(BuildContext context, File uploadFile,
      String classId, String surveyId, String date, String des) async {
    token = await secureStorage.read(key: 'token');
    try{
      var request = http.MultipartRequest('POST', Uri.parse("${Constant.baseUrl}/it5023e/create_survey"));

      // Thêm các trường văn bản (text)
      request.fields['token'] = token!;
      request.fields['assignmentId'] = classId;
      request.fields['deadline'] = DateTime.parse(date).toIso8601String();
      request.fields['description'] = des;

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
      var responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        _showErrorDialog(context, "Dang ki lop thanh cong");
        //surveys.add(Survey.fromJson(responseBody.body));
        notifyListeners();
        getAllSurvey(context, classId);
      } else {
        print(responseBody.body);
      }
    } catch (e) {
      print(e.toString());
      _showErrorDialog(context, e.toString());
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getAllSurvey(BuildContext context, String classId)async{
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "class_id": classId
    };
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/get_all_surveys'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> jsonData = json.decode(responseBody);
        print(responseBody);
        surveys = (jsonData['data'] as List)
            .map((classJson) => Survey.fromJson(classJson))
            .toList();
        print("lay du lieu survey thanh cong");
        notifyListeners();
      }else {
        _showErrorDialog(context, response.body);
      }
    } catch (e) {
      print(e.toString());
    }}

  Future<void> deleteSurvey(BuildContext context, String surveyId, int index)async{
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "survey_id": surveyId
    };
    print(requestBody);
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/delete_survey'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
          surveys.removeAt(index);
        print("xoa thanh cong");
        _showSuccessSnackbar(context, "Xóa thành công bài kiểm tra", Colors.green);
        notifyListeners();
      } else {
        _showSuccessSnackbar(context, "Không được xóa bài tập này", Colors.red);
      }
    } catch (e) {
      _showErrorDialog(context, "Có lỗi xảy ra, vui lòng thử lại Exception");
    }}

  Future<void> submit_survey(BuildContext context, File uploadFile,
      String surveyId, String des, String classId) async {
    token = await secureStorage.read(key: 'token');
    try{
      var request = http.MultipartRequest('POST', Uri.parse("${Constant.baseUrl}/it5023e/submit_survey"));

      // Thêm các trường văn bản (text)
      request.fields['token'] = token!;
      request.fields['assignmentId'] = surveyId ;
      request.fields['textResponse'] = des;

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
      var responseBody = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        _showSuccessSnackbar(context, "Nộp bài thành công", Colors.green);
        await get_survey_student(context);
        notifyListeners();
        Navigator.pop(context);
      } else {
        print(responseBody.body);
      }
    } catch (e) {
      print(e.toString());
      _showErrorDialog(context, e.toString());
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> get_survey_student(BuildContext context)async {
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
    };
    try {
      print("start http request");
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/get_student_assignments'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> jsonData = json.decode(responseBody);
        studentSurvey = (jsonData['data'] as List)
            .map((classJson) => Survey.fromJson(classJson))
            .toList();
        print(studentSurvey.length);
        notifyListeners();
      } else {
        _showErrorDialog(context, response.body);
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  Future<void> get_survey_response(BuildContext context, String surveyId)async{
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
    "survey_id": surveyId
    };
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/get_survey_response'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> jsonData = json.decode(responseBody);
        print(responseBody);
        submissions = (jsonData['data'] as List)
            .map((classJson) => Submission.fromJson(classJson))
            .toList();
        print(submissions);
        notifyListeners();
      } else {
        _showErrorDialog(context, "Có lôĩ xảy ra, vui lòng thử lại");
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
      print(e.toString());
    }

  }

  Future<void> grade_survey(BuildContext context, String surveyId, String score, String subId)async{
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> grade = {
      "score": score,
      "submission_id": subId
    };
    final Map<String, dynamic> requestBody = {
      "token": token,
      "survey_id": surveyId,
      "grade": grade
    };
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/get_survey_response'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> jsonData = json.decode(responseBody);
        print(responseBody);
        submissions = (jsonData['data'] as List)
            .map((classJson) => Submission.fromJson(classJson))
            .toList();
        print(submissions);
        notifyListeners();
        Navigator.pop(context);
      } else {
        _showErrorDialog(context, "Có lôĩ xảy ra, vui lòng thử lại");
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
      print(e.toString());
    }

  }

  Future<void> get_submission(BuildContext context, String assignment_id)async{
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "assignment_id": assignment_id
    };
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/get_submission'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> jsonData = json.decode(responseBody);
        print(responseBody);
        selectSubmission =  Submission.fromJson(jsonData['data']);
        print(selectSubmission);
        notifyListeners();
      } else {
        _showErrorDialog(context, "Có lôĩ xảy ra, vui lòng thử lại");
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
      print(e.toString());
    }

  }

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
}
