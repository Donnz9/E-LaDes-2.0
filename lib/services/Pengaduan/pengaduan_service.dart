import 'dart:convert';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class InfrastrukturService {
  static Future<Map<String, dynamic>> submitForm({
    required String nama,
    required String nik,
    required String alamat,
    required String jenis_infrastruktur,
    required String deskripsi,
    required String tanggal_kejadian,
    required String lokasi,
    required List<String> filePaths, // boleh null
    required String username,
  }) async {
    var uri = Uri.parse("${AppConfig.baseUrl}/pengaduan/pengaduan_infrastruktur.php");
    var request = http.MultipartRequest("POST", uri);

    request.fields['kode_pengaduan'] = "infrastruktur";
    request.fields['nama'] = nama;
    request.fields['nik'] = nik;
    request.fields['alamat'] = alamat;
    request.fields['jenis_infrastruktur'] = jenis_infrastruktur;
    request.fields['deskripsi'] = deskripsi;
    request.fields['tanggal_kejadian'] = tanggal_kejadian;
    request.fields['lokasi'] = lokasi;
    request.fields['username'] = username;

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

class KeamananService {
  static Future<Map<String, dynamic>> submitForm({
    required String nama,
    required String tempatLahir,
    required String tanggalLahir,
    required String agama,
    required String jenisKelamin,
    required String pekerjaan,
    required String alamat,
    required String barang,
    required String tanggalHilang,
    required String tempatKehilangan,
    required List<String> filePaths, // boleh null
    required String username,
  }) async {
    var uri = Uri.parse("${AppConfig.baseUrl}/pengajuan/pengajuan_kehilangan.php");
    var request = http.MultipartRequest("POST", uri);

    request.fields['kode_surat'] = "kehilangan barang";
    request.fields['nama'] = nama;
    request.fields['tempat_lahir'] = tempatLahir;
    request.fields['tanggal_lahir'] = tanggalLahir;
    request.fields['agama'] = agama;
    request.fields['jenis_kelamin'] = jenisKelamin;
    request.fields['pekerjaan'] = pekerjaan;
    request.fields['alamat'] = alamat;
    request.fields['barang'] = barang;
    request.fields['tanggal_hilang'] = tanggalHilang;
    request.fields['tempat_kehilangan'] = tempatKehilangan;
    request.fields['username'] = username;

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

class SaranService {
  static Future<Map<String, dynamic>> submitForm({
    //bapak
    required String namaBpk,
    required String tempatLahirBpk,
    required String tanggalLahirBpk,
    required String pekerjaanBpk,
    required String alamatBpk,

    //ibu
    required String namaIbu,
    required String tempatLahirIbu,
    required String tanggalLahirIbu,
    required String pekerjaanIbu,
    required String alamatIbu,

    //anak
    required String nama,
    required String nik,
    required String tempatLahir,
    required String tanggalLahir,
    required String jenisKelamin,
    required String alamat,
    required String keperluan,
    required List<String> filePaths, // boleh null
    required String username,
  }) async {
    var uri = Uri.parse("${AppConfig.baseUrl}/pengajuan/pengajuan_sktm.php");
    var request = http.MultipartRequest("POST", uri);

    request.fields['kode_surat'] = "sktm";
    //bpk
    request.fields['nama_bapak'] = namaBpk;
    request.fields['tempat_tanggal_lahir_bapak'] = tempatLahirBpk + ', ' + tanggalLahirBpk;
    request.fields['pekerjaan_bapak'] = pekerjaanBpk;
    request.fields['alamat_bapak'] = alamatBpk;

    //ibu
    request.fields['nama_ibu'] = namaIbu;
    request.fields['tempat_tanggal_lahir_ibu'] = tempatLahirIbu + ', ' + tanggalLahirIbu;
    request.fields['pekerjaan_ibu'] = pekerjaanIbu;
    request.fields['alamat_ibu'] = alamatIbu;

    //anak
    request.fields['nama'] = nama;
    request.fields['nik'] = nik;
    request.fields['tempat_tanggal_lahir_anak'] = tempatLahir + ', ' + tanggalLahir;
    request.fields['jenis_kelamin_anak'] = jenisKelamin;
    request.fields['alamat'] = alamat;
    request.fields['keperluan'] = keperluan;
    request.fields['username'] = username;

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