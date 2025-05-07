import 'dart:convert';
import 'package:elades20/Models/dashboard/dashboard_model.dart';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;

class KabarDesaService {
  Future<List<KabarDesaModel>> fetchKabarDesa() async {
    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/dashboard/status_pengajuan.php"),
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((e) => KabarDesaModel.fromJson(e)).toList();
      } else {
        print('Error fetching kabar desa: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception when fetching kabar desa: $e');
      return [];
    }
  }
}