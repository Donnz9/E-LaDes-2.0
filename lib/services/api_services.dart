import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "http://10.0.2.2/elades_api";

  static Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse("$_baseUrl/get_users.php"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load users");
    }
  }
}
