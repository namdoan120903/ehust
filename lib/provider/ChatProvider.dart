import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project/model/Conversation.dart';
import 'package:project/model/StudentAccount.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:http/http.dart' as http;
import '../Constant.dart';

class ChatProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? token;
  bool isLoading = false;
  late StompClient stompClient;
  bool isConnected = false;
  List<Conversation> conversations = [];
  List<LastMessage> messages = [];
  List<StudentAccount> searchStudent = [];

  // Hàm khởi tạo WebSocket kết nối
  void connect(String userId) async {

    stompClient = await StompClient(
      config: StompConfig.sockJS(
        url: '${Constant.baseUrl}/ws',
        onConnect: (StompFrame frame) {
          isConnected = true;
          notifyListeners();
          print('WebSocket connected: $frame');

          // Subscribe vào hộp thư đến của người dùng
          stompClient.subscribe(
            destination: '/user/$userId/inbox',
            callback: (frame) {
              final msg = jsonDecode(frame.body!);
              print('Message received: $msg');
              notifyListeners();
            },
          );
        },
        onDisconnect: (frame) {
          isConnected = false;
          print('WebSocket disconnected: $frame');
          notifyListeners();
        },
        onWebSocketError: (dynamic error) => print('WebSocket error: $error'),
      ),
    );

    stompClient.activate();
  }

  // Gửi tin nhắn
  Future<void> sendMessage(BuildContext context, String receiverId, String content, String conversationId) async {
    token = await _secureStorage.read(key: 'token');
    final message = {
      'receiver': {'id': receiverId},
      'content': content,
      'token': token,
    };

    if (isConnected) {
      stompClient.send(
        destination: '/chat/message',
        body: jsonEncode(message),
      );
      print('Message sent: $message');
    } else {
      print('WebSocket is not connected!');
    }
    if(!conversationId.isEmpty){
      await get_conversation_list(context);
      await get_conversation(context, conversationId);
      notifyListeners();
    }
    notifyListeners();
  }

  // Ngắt kết nối WebSocket
  void disconnect() {
    if (stompClient.isActive) {
      stompClient.deactivate();
    }
  }

  Future<void> get_conversation_list(BuildContext context) async {

    token = await _secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "index": "0",
      "count": "100"
    };
    try {
      isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/get_list_conversation'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> jsonData = json.decode(responseBody)['data'];
        conversations = (jsonData['conversations'] as List)
            .map((classJson) => Conversation.fromJson(classJson))
            .toList();
        print(conversations);
        notifyListeners();
      } else {
        Constant.showSuccessSnackbar(context, response.body, Colors.red);
      }
    } catch (e) {
      Constant.showSuccessSnackbar(context, e.toString(), Colors.red);
      print(e.toString());
    }
    isLoading = false;
    notifyListeners();
  }


  Future<void> get_conversation(BuildContext context, String id) async {
    token = await _secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "index": "0",
      "count": "100",
      "conversation_id": id,
      "mark_as_read": "true"
    };
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/get_conversation'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> jsonData = json.decode(responseBody)['data'];
        messages = (jsonData['conversation'] as List)
            .map((classJson) => LastMessage.fromJson(classJson))
            .toList();
        print(conversations);
        notifyListeners();
      } else {
        Constant.showSuccessSnackbar(context, response.body, Colors.red);
      }
    } catch (e) {
      Constant.showSuccessSnackbar(context, e.toString(), Colors.red);
      print(e.toString());
    }
  }

  Future<void> delete_message(BuildContext context, String message_id, String con_id) async {
    token = await _secureStorage.read(key: 'token');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "message_id": message_id,
      "conversation_id": con_id,
    };
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/delete_message'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        await get_conversation(context, con_id);
        notifyListeners();
      } else {
        Constant.showSuccessSnackbar(context, response.body, Colors.red);
      }
    } catch (e) {
      Constant.showSuccessSnackbar(context, e.toString(), Colors.red);
      print(e.toString());
    }
  }

  Future<void> search_student(BuildContext context, String name) async {
    final Map<String, dynamic> requestBody = {
      "search": name,
    };
    try {
      final response = await http.post(
        Uri.parse('${Constant.baseUrl}/it5023e/search_account'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> jsonData = json.decode(responseBody)['data'];
        searchStudent = (jsonData['page_content'] as List)
            .map((classJson) => StudentAccount.fromJson(classJson))
            .toList();
        print(searchStudent);
        notifyListeners();
      } else {
        Constant.showSuccessSnackbar(context, response.body, Colors.red);
      }
    } catch (e) {
      Constant.showSuccessSnackbar(context, e.toString(), Colors.red);
      print(e.toString());
    }
  }
}
