import 'package:http/http.dart' as http;

class AuthService {
  static Future<bool> sendOtp(String emailOrPhone) async {
    final url = Uri.parse("https://192.168.0.3/elades20_api/send_otp.php");
    final response = await http.post(url, body: {'email_or_phone': emailOrPhone});

    return response.statusCode == 200 && response.body.contains("success");
  }
}
