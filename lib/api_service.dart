import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://your-backend-url.com';

  // Hàm gọi API lấy danh sách hội thoại
  Future<Map<String, dynamic>> getConversations({
    required String token,
    required int index,
    required int count,
  }) async {
    final url = Uri.parse('$baseUrl/it5023e/get_list_conversation');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'index': index.toString(),
          'count': count.toString(),
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Lỗi: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Không thể kết nối tới server: $e');
    }
  }
}
