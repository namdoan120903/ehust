import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project/Constant.dart';

class LeaveRequestProvider with ChangeNotifier {
  final secureStorage = FlutterSecureStorage();
  String? _token;
  bool _isLoading = false;

  List<Map<String, dynamic>> _leaveRequests = [];

  List<Map<String, dynamic>> get leaveRequests => _leaveRequests;
  bool get isLoading => _isLoading;

  // Create a leave request (request_absence API)
  Future<void> requestLeave({
    required String classId,
    required String date,
    required String reason,
    required String filePath,
  }) async {
    _isLoading = true;
    notifyListeners();
    _token = await secureStorage.read(key: 'token');

    print("start send leave request!");
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Constant.baseUrl}/request_absence'),
      )
        ..fields['token'] = _token ?? ''
        ..fields['classId'] = classId
        ..fields['date'] = date
        ..fields['reason'] = reason
        ..files.add(await http.MultipartFile.fromPath('file', filePath));
      print(request.toString());
      final response = await request.send();
      if (response.statusCode == 200) {
        print("Leave request created successfully.");
      } else {
        print("Failed to create leave request: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error creating leave request: $error");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Review a leave request (review_absence_request API)
  Future<void> reviewLeaveRequest({
    required String requestId,
    required String status,
  }) async {
    _token = await secureStorage.read(key: 'token');

    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/review_absence_request'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "token": _token,
          "request_id": requestId,
          "status": status,
        }),
      );

      if (response.statusCode == 200) {
        print("Leave request reviewed successfully.");
        // Update the local state if necessary
        _leaveRequests.removeWhere((request) => request['id'] == requestId);
        notifyListeners();
      } else {
        print("Failed to review leave request: ${response.body}");
      }
    } catch (error) {
      print("Error reviewing leave request: $error");
    }
  }

  // Fetch leave requests (get_absence_requests API)
  Future<void> fetchLeaveRequests({
    required String classId,
    String status = "PENDING",
  }) async {
    _isLoading = true;
    notifyListeners();
    _token = await secureStorage.read(key: 'token');

    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/get_absence_requests'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "token": _token,
          "class_id": classId,
          "status": status,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['absence_requests'] != null) {
          _leaveRequests =
              List<Map<String, dynamic>>.from(data['absence_requests']);
          notifyListeners();
        }
      } else {
        print("Failed to fetch leave requests: ${response.body}");
      }
    } catch (error) {
      print("Error fetching leave requests: $error");
    }

    _isLoading = false;
    notifyListeners();
  }
}
