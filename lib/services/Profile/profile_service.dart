import 'dart:convert';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  static Future<Map<String, dynamic>> fetchUserProfile(String id) async {
    final url = Uri.parse("${AppConfig.baseUrl}/login.php");
    final response = await http.post(
      url,
      body: {'id_user': id}, // atau 'id_user': '1'
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil data profil');
    }
  }
}
