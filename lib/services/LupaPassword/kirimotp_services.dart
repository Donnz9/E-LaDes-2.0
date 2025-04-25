import 'dart:convert';
import 'package:elades20/Models/otp_response_model.dart';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;

class KirimOtpService {
  static Future<OtpResponse> sendOtp(String emailOrPhone) async {
    final url = Uri.parse("${AppConfig.baseUrl}/send_otp_reset.php");
    final response = await http.post(url, body: {
      'email_or_phone': emailOrPhone,
    });

    final data = jsonDecode(response.body);
    return OtpResponse.fromJson(data);
  }

  static Future<OtpResponse> verifikasiOtp(String emailOrPhone, String kodeOtp) async {
  final url = Uri.parse("${AppConfig.baseUrl}/LupaPassword_verifikasi_otp.php");
  final response = await http.post(url, body: {
    'email_or_phone': emailOrPhone,
    'kode_otp': kodeOtp,
  });

  final data = jsonDecode(response.body);
  return OtpResponse.fromJson(data);
}

}

