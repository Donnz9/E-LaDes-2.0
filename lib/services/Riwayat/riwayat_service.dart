import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:elades20/Services/config.dart';

class RiwayatService {
  // Method untuk mengambil data riwayat (pengajuan atau pengaduan)
  static Future<Map<String, dynamic>> fetchRiwayatData({
    required String username,
    required bool isPengajuan,
    required Function(bool) setLoading,
    required Function(String) setErrorMessage,
  }) async {
    setLoading(true);
    setErrorMessage('');
    
    try {
      // Get the correct endpoint based on the current tab
      final endpoint = isPengajuan ? 'riwayat_pengajuan' : 'riwayat_pengaduan';
      print("Endpoint yang dipakai: $endpoint");

      // Follow the same pattern as ProfileService for API calls
      final url = Uri.parse("${AppConfig.baseUrl}/$endpoint");
      print("URL yang dibentuk: $url");

      final response = await http.post(
        url,
        body: {'username': username},
      );
      print("Username yang dikirim: $username");
      print("Status code dari response: ${response.statusCode}");
      print("Body dari response: berhasil");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Data ter-decode: $responseData");

        if (responseData['kode'] == 1) {
          List<dynamic> data = responseData['data'];

          // Urutkan data berdasarkan tanggal (dari yang terbaru)
          data.sort((a, b) {
            DateTime dateA = DateTime.parse(a['tanggal'] ?? '2000-01-01');
            DateTime dateB = DateTime.parse(b['tanggal'] ?? '2000-01-01');
            return dateB.compareTo(dateA); // Descending (terbaru dulu)
          });

          setLoading(false);
          return {
            'success': true,
            'data': data,
            'message': '',
          };
        } else {
          setErrorMessage(responseData['pesan'] ?? 'Data tidak ditemukan');
          setLoading(false);
          return {
            'success': false,
            'data': [],
            'message': responseData['pesan'] ?? 'Data tidak ditemukan',
          };
        }
      } else {
        setErrorMessage('Server error: ${response.statusCode}');
        setLoading(false);
        return {
            'success': false,
            'data': [],
            'message': 'Server error: ${response.statusCode}',
          };
      }
    } catch (e) {
      setErrorMessage('Gagal memuat data: ${e.toString()}');
      setLoading(false);
      return {
            'success': false,
            'data': [],
            'message': 'Gagal memuat data: ${e.toString()}',
          };
    }
  }
}