import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/auth/';

  // تسجيل الدخول
  static Future<Map<String, dynamic>> signin(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('فشل تسجيل الدخول: ${response.body}');
    }
  }
}
