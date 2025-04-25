import 'dart:convert';
import 'package:elades20/Models/register_response_model.dart';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  static Future<RegisterResponse> registerWithOtp({
    required String email,
    required String noHp,
    required String nama,
    required String password,
    required String kodeOtp,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/register.php'),
      body: {
        'email': email,
        'no_hp': noHp,
        'nama': nama,
        'password': password,
        'kode_otp': kodeOtp,
      },
    );

    final data = jsonDecode(response.body);
    return RegisterResponse.fromJson(data);
  }
}