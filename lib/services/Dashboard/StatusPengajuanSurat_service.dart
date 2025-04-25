import 'dart:convert';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, String>> fetchStatusCounts() async {
  final url = Uri.parse("${AppConfig.baseUrl}/StatusPengajuanSurat.php");
  final response = await http.get(
    url,
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return {
      'Masuk': data['masuk'],
      'Selesai': data['selesai'],
      'Tolak': data['tolak'],
    };
  } else {
    throw Exception("Gagal memuat data status surat");
  }
}