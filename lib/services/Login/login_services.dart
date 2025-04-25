import 'dart:convert';

import 'package:elades20/Models/user_model.dart';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static Future<Map<String, dynamic>> login(
      String login, String password) async {
    final url = Uri.parse("${AppConfig.baseUrl}/login.php");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "login": login,
        "password": password,
      }),
    );
    print("Response body dari login.php: ${response.body}");

    final result = jsonDecode(response.body);
    final rawUser = result['user']; 

    if (result['success'] && rawUser != null) {
      print("Data user dari server sebelum parsing: $rawUser");
      try {
        result['user'] = UserModel.fromJson(rawUser);
      } catch (e) {
        print("Gagal parsing UserModel: $e");
        result['user'] = null;
      }
    } else {
      result['user'] = null;
    }
    return result;
  }
}
