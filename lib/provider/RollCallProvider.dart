import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project/Constant.dart';
import 'package:project/components/attend_record_lecturer.dart';
import 'package:project/model/StudentAttendanceRecord.dart';

class RollCallProvider with ChangeNotifier {
  bool _isLoading = false;
  List<String> _attendanceList = [];
  List<StudentAttendanceRecord> _recordForLecturer = [];
  String? _attendanceStatus;
  String? token;
  final secureStorage = FlutterSecureStorage();

  bool get isLoading => _isLoading;
  List<String> get attendanceList => _attendanceList;
  String? get attendanceStatus => _attendanceStatus;
  List<StudentAttendanceRecord> get recordForLecturer => _recordForLecturer;
  String formatDateString(String dateString) {
    // Parse the input date string to a DateTime object
    final DateFormat inputFormat = DateFormat('dd/MM/yyyy');
    final DateFormat outputFormat = DateFormat('yyyy-MM-dd');

    try {
      DateTime date = inputFormat.parse(dateString); // Parse to DateTime
      return outputFormat.format(date); // Format to 'yyyy-MM-dd'
    } catch (e) {
      // If parsing fails, return an error or default value
      return 'Invalid date format';
    }
  }

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
      "date": formatDateString(date),
      "attendance_list": absentStudentIds,
    };
    print(requestBody);
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/take_attendance'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      print(response.statusCode);
      print("body: " + response.body.toString());

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
        Uri.parse('${Constant.baseUrl}/it5023e/get_attendance_record'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"token": token, "class_id": classId}),
      );

      print("response.statusCode " + response.statusCode.toString());
      print("response.body " + response.body.toString());
      if (response.statusCode == 200) {
        _attendanceList = List<String>.from(
          json.decode(response.body)['data']["absent_dates"],
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
  Future<void> setAttendanceStatus(String attendanceId, String status) async {
    _isLoading = true;
    notifyListeners();
    token = await secureStorage.read(key: 'token');
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/set_attendance_status'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "token": token,
          "attendance_id": attendanceId,
          "status": status.toUpperCase(),
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
    final Map<String, dynamic> requestBody = {
      "token": token, // Ensure 'token' is defined in your class
      "class_id": classId,
      "date": date,
      "pageable_request": {
        "page": page.toString(),
        "page_size": pageSize.toString()
      }
    };
    print("requestBody: " + requestBody.toString());
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/get_attendance_list'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        print("response.body " + response.body.toString());
        // Extract the list of attendance details
        List<dynamic> attendanceDetails =
            json.decode(response.body)['data']['attendance_student_details'];

        // Convert the list of maps into a List<StudentAttendanceRecord>
        if (page == 0) {
          recordForLecturer.clear();
        }
        _recordForLecturer.addAll(attendanceDetails
            .map((attendance) => StudentAttendanceRecord.fromMap(attendance))
            .toList());
        notifyListeners();
      } else {
        _attendanceList = [];
      }
    } catch (e) {
      _attendanceList = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<String>> fetchAttendanceDates(String classId) async {
    // Set the API endpoint URL
    token = await secureStorage.read(key: 'token');
    final url = Uri.parse('${Constant.baseUrl}/it5023e/get_attendance_dates');

    // Prepare the request body
    final body = json.encode({
      'token': token,
      'class_id': classId,
    });

    // Send the POST request
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    // Check for a successful response
    if (response.statusCode == 200) {
      // Parse the JSON response
      final responseJson = json.decode(response.body);

      // Extract the 'data' field and return as a List<String>
      final List<String> attendanceDates =
          List<String>.from(responseJson['data']);
      return attendanceDates;
    } else {
      throw Exception('Failed to load attendance dates');
    }
  }
}
