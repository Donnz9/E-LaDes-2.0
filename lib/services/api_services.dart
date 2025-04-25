import 'dart:convert';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse("${AppConfig.baseUrl}/get_users.php"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load users");
    }
  }
}
