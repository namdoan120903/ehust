import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RollCallProvider with ChangeNotifier {
  bool _isLoading = false;
  List<Map<String, dynamic>> _attendanceList = [];
  String? _attendanceStatus;
  String? token;
  final secureStorage = FlutterSecureStorage();

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get attendanceList => _attendanceList;
  String? get attendanceStatus => _attendanceStatus;

  // 1. Take Attendance (take_attendance API)
  //lecturer take attendance
  Future<void> takeAttendance(
      String classId, String date, List<String> absentStudentIds) async {
    _isLoading = true;
    notifyListeners();
    token = (await secureStorage.read(key: 'token'))!;
    final Map<String, dynamic> requestBody = {
      "token": token,
      "class_id": classId,
      "date": date,
      "attendance_list": absentStudentIds,
    };
    print(requestBody);
    try {
      final response = await http.post(
        Uri.parse('http://160.30.168.228:8080/it5023e/take_attendance'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        _attendanceStatus = "Attendance recorded successfully";
      } else {
        _attendanceStatus = "Failed to record attendance";
      }
    } catch (e) {
      _attendanceStatus = "Error: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  // 2. Get Attendance Record (get_attendance_record API)
  //student get all absense date by class
  //response: private List<LocalDate> absentDates
  Future<void> getAttendanceRecord(String classId) async {
    _isLoading = true;
    notifyListeners();
    token = await secureStorage.read(key: 'token');
    print("START Get Attendance Record");
    print("body: " +
        json.encode({"token": token, "class_id": classId}).toString());
    try {
      final response = await http.post(
        Uri.parse('http://160.30.168.228:8080/it5023e/get_attendance_record'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"token": token, "class_id": classId}),
      );

      print("response.statusCode " + response.statusCode.toString());
      print("response.body " + response.body.toString());
      if (response.statusCode == 200) {
        _attendanceList = List<Map<String, dynamic>>.from(
          json.decode(response.body)['attendance_list'],
        );
      } else {
        _attendanceList = [];
      }
    } catch (e) {
      _attendanceList = [];
      print(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  // 3. Set Attendance Status (set_attendance_status API)
  //lecturer re set attendance status of a student (attendance_id)
  Future<void> setAttendanceStatus(String attendanceId, bool status) async {
    _isLoading = true;
    notifyListeners();
    token = await secureStorage.read(key: 'token');
    try {
      final response = await http.post(
        Uri.parse('http://160.30.168.228:8080/it5023e/set_attendance_status'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "token": token,
          "attendance_id": attendanceId,
          "status": status ? "present" : "absent",
        }),
      );

      if (response.statusCode == 200) {
        _attendanceStatus = "Attendance status updated successfully";
      } else {
        _attendanceStatus = "Failed to update attendance status";
      }
    } catch (e) {
      _attendanceStatus = "Error: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  // 4. Get Attendance List (get_attendance_list API)
  //lecturer get a list attendance of a date - a class
  Future<void> getAttendanceList(
      String classId, String date, int page, int pageSize) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://160.30.168.228:8080/it5023e/get_attendance_list'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "token": token, // Ensure 'token' is defined in your class
          "class_id": classId,
          "date": date,
          "pageable_request": {
            "page": page.toString(),
            "page_size": pageSize.toString()
          }
        }),
      );

      if (response.statusCode == 200) {
        _attendanceList = List<Map<String, dynamic>>.from(
          json.decode(response.body)['attendance_list'],
        );
      } else {
        _attendanceList = [];
      }
    } catch (e) {
      _attendanceList = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
