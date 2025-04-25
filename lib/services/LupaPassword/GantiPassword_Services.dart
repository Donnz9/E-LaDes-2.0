import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:elades20/Services/config.dart';

class UbahPasswordService {
  static Future<Map<String, dynamic>> ubahPassword(
      String emailOrPhone, String passwordBaru) async {
    final url = Uri.parse("${AppConfig.baseUrl}/LupaPassword.php");

    final response = await http.post(url, body: {
      'email_or_phone': emailOrPhone,
      'password_baru': passwordBaru,
    });

    return json.decode(response.body);
  }
}
