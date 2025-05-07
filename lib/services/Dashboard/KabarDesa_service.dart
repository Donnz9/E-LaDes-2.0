import 'dart:convert';
import 'package:elades20/Models/dashboard/dashboard_model.dart';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;

class KabarDesaService {
  Future<List<KabarDesaModel>> fetchKabarDesa() async {
    try {
      print("Fetching kabar desa from: ${AppConfig.baseUrl}/dashboard/kabar_desa.php");
      final response = await http.get(
        Uri.parse("${AppConfig.baseUrl}/dashboard/kabar_desa.php"),
      );
      
      if (response.statusCode == 200) {
        print("Response received: ${response.body}");
        List<dynamic> jsonData = json.decode(response.body);
        
        List<KabarDesaModel> result = [];
        
        // Process each item individually to handle potential parsing errors
        for (var item in jsonData) {
          try {
            print("Processing kabar desa item: ${item['judul']} with image: ${item['gambar']}");
            result.add(KabarDesaModel.fromJson(item));
          } catch (e) {
            print('Error parsing kabar desa item: $e');
            print('Problem item: $item');
            // Continue with next item
          }
        }
        print("Successfully parsed ${result.length} kabar desa items");
        return result;
      } else {
        print('Error fetching kabar desa: ${response.statusCode}');
        print('Response body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exception when fetching kabar desa: $e');
      return [];
    }
  }
}