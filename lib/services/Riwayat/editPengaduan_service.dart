import 'dart:convert';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class EditInfrastrukturService {
  static Future<Map<String, dynamic>> submitForm({
    required String no_pengaduan,
    required String nama,
    required String nik,
    required String alamat,
    required String jenis_infrastruktur,
    required String deskripsi,
    required String tanggal_kejadian,
    required String lokasi,
    required List<String> filePaths, // boleh null
  }) async {
    var uri = Uri.parse("${AppConfig.baseUrl}/edit_infrastruktur");
    var request = http.MultipartRequest("POST", uri);

    request.fields['no_pengaduan'] = no_pengaduan;
    request.fields['kode_pengaduan'] = "infrastruktur";
    request.fields['nama'] = nama;
    request.fields['nik'] = nik;
    request.fields['alamat'] = alamat;
    request.fields['jenis_infrastruktur'] = jenis_infrastruktur;
    request.fields['deskripsi'] = deskripsi;
    request.fields['tanggal_kejadian'] = tanggal_kejadian;
    request.fields['lokasi'] = lokasi;

    if (filePaths.isNotEmpty) {
      for (int i = 0; i < filePaths.length; i++) {
        if (filePaths[i].isNotEmpty) {
          var file = await http.MultipartFile.fromPath(
            'file[]', // Changed to array notation for PHP
            filePaths[i],
            contentType: MediaType('application', 'octet-stream'),
          );
          request.files.add(file);
        }
      }
    }

    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    print("Response: $respStr");
    return json.decode(respStr);
  }
}

class EditKeamananService {
  static Future<Map<String, dynamic>> submitForm({
    required String no_pengaduan,
    required String nama,
    required String nik,
    required String jenis_kasus,
    required String lokasi_kejadian,
    required String tanggal,
    required String waktu,
    required String deskripsi,
    required List<String> filePaths, // boleh null
  }) async {
    var uri = Uri.parse("${AppConfig.baseUrl}/edit_keamanan");
    var request = http.MultipartRequest("POST", uri);

    request.fields['no_pengaduan'] = no_pengaduan;
    request.fields['kode_pengaduan'] = "keamanan";
    request.fields['nama'] = nama;
    request.fields['nik'] = nik;
    request.fields['jenis_kasus'] = jenis_kasus;
    request.fields['lokasi_kejadian'] = lokasi_kejadian;
    request.fields['tanggal'] = tanggal;
    request.fields['waktu'] = waktu;
    request.fields['deskripsi'] = deskripsi;

    if (filePaths.isNotEmpty) {
      for (int i = 0; i < filePaths.length; i++) {
        if (filePaths[i].isNotEmpty) {
          var file = await http.MultipartFile.fromPath(
            'file[]', // Changed to array notation for PHP
            filePaths[i],
            contentType: MediaType('application', 'octet-stream'),
          );
          request.files.add(file);
        }
      }
    }

    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    print("Response: $respStr");
    return json.decode(respStr);
  }
}

class EditSaranService {
  static Future<Map<String, dynamic>> submitForm({
    required String no_pengaduan,
    required String? nama,
    required String alamat,
    required String topik,
    required String judul_saran,
    required String deskripsi,
    required String tanggal,
    required List<String> filePaths, // boleh null
  }) async {
    var uri = Uri.parse("${AppConfig.baseUrl}/edit_saran");
    var request = http.MultipartRequest("POST", uri);

    request.fields['no_pengaduan'] = no_pengaduan;
    request.fields['kode_pengaduan'] = "saran";
    if (nama != null && nama.isNotEmpty) {
      request.fields['nama'] = nama;
    }
    if (alamat != null && alamat.isNotEmpty) {
      request.fields['alamat'] = alamat;
    }
    request.fields['topik'] = topik;
    request.fields['judul_saran'] = judul_saran;
    request.fields['deskripsi'] = deskripsi;
    request.fields['tanggal'] = tanggal;

    if (filePaths.isNotEmpty) {
      for (int i = 0; i < filePaths.length; i++) {
        if (filePaths[i].isNotEmpty) {
          var file = await http.MultipartFile.fromPath(
            'file[]', // Changed to array notation for PHP
            filePaths[i],
            contentType: MediaType('application', 'octet-stream'),
          );
          request.files.add(file);
        }
      }
    }

    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    print("Response: $respStr");
    return json.decode(respStr);
  }
}
