import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/model/MyMaterial.dart';

import '../Constant.dart';

class MaterialProvider with ChangeNotifier {
  final secureStorage = FlutterSecureStorage();
  String? token;
  bool isLoading = false;
  List<MyMaterial> materials = [];

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

  Future<void> create_material(BuildContext context, File uploadFile,
      String classId, String title, String des, String type) async {
    token = await secureStorage.read(key: 'token');
    try{
      var request = http.MultipartRequest('POST', Uri.parse("${Constant.baseUrl}/it5023e/upload_material"));

      // Thêm các trường văn bản (text)
      request.fields['token'] = token!;
      request.fields['classId'] = classId;
      request.fields['title'] = title;
      request.fields['materialType'] = type;
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
      print('send request');
      var responseBody = await http.Response.fromStream(response);
      print(responseBody.body);
      if (response.statusCode == 201) {
        MyMaterial material1 = MyMaterial.fromJson(jsonDecode(responseBody.body)['data']);
        materials.add(material1);
        _showSuccessSnackbar(context, "Thêm tài liệu mới thành công", Colors.green);
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

  Future<void> getAllMaterial(BuildContext context, String classId)async{
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "class_id": classId
    };
    print(requestBody);
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/get_material_list'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      print(response.body);final responseBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(responseBody);

        materials = (jsonData['data'] as List)
            .map((classJson) => MyMaterial.fromJson(classJson))
            .toList();
        print("lay du lieu tai lieu thanh cong");
        notifyListeners();
      } else {
        _showErrorDialog(context, responseBody);
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteMaterial(BuildContext context, String materialId, int index)async{
    token = await secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "material_id": materialId
    };
    print(requestBody);
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/delete_material'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        materials.removeAt(index);
        print("xoa thanh cong");
        notifyListeners();
      } else {
        _showErrorDialog(context, response.body);
      }
    } catch (e) {
      _showErrorDialog(context, "Có lỗi xảy ra, vui lòng thử lại Exception");
    }}

  Future<void> edit_material(BuildContext context, File uploadFile,
      String materialId, String title, String des, int index, String type) async {
    print(title);
    token = await secureStorage.read(key: 'token');
    try{
      var request = http.MultipartRequest('POST', Uri.parse("${Constant.baseUrl}/it5023e/edit_material"));

      // Thêm các trường văn bản (text)
      request.fields['token'] = token!;
      request.fields['materialId'] = materialId;
      request.fields['title'] = title;
      request.fields['materialType'] = type;
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
        MyMaterial material1 = MyMaterial.fromJson(jsonDecode(responseBody.body)['data']);
        materials[index] = material1;
        print(material1.materialName);
        _showSuccessSnackbar(context, "Chỉnh sửa tài liệu thành công", Colors.green);
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

}