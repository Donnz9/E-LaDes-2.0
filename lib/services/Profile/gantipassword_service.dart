import 'dart:convert';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;

Future<bool> update_password(String idUser, String newPassword) async {
  try {
    final url = Uri.parse("${AppConfig.baseUrl}/update_password.php"); // URL harus dideklarasikan di luar body
    final response = await http.post(
      url,
      body: {
        'id_user': idUser,  // Gunakan idUser yang dinamis
        'password': newPassword,
      },
    );

    // Cek status code untuk memastikan request sukses
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      return false;
    }
  } catch (e) {
    print('Error: $e');  // Debugging error jika ada masalah jaringan atau lainnya
    return false;
  }
}
