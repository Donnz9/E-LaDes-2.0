import 'dart:convert';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

//pengantar
class SKCKService {}

class KehilanganBarangService {
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
    var uri =
        Uri.parse("${AppConfig.baseUrl}/pengajuan/pengajuan_kehilangan.php");
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

//keterangan
class SKTMService {}

class PenghasilanService {
  static Future<Map<String, dynamic>> submitForm({
    required String nama,
    required String nik,
    required String tempatTglLahir,
    required String noHp,
    required String namaAnak,
    required String nikAnak,
    required String jenisKelamin,
    required String ttlAnak,
    required String alamatAnak,
    required String username,
    required List<String> filePaths, // boleh null
  }) async {
    var uri =
        Uri.parse("${AppConfig.baseUrl}/pengajuan/pengajuan_penghasilan.php");
    var request = http.MultipartRequest("POST", uri);

    request.fields['kode_surat'] = "penghasilan";
    request.fields['nama'] = nama;
    request.fields['nik'] = nik;
    request.fields['ttl'] = tempatTglLahir;
    request.fields['no_hp'] = noHp;
    request.fields['nama_anak'] = namaAnak;
    request.fields['nik_anak'] = nikAnak;
    request.fields['jenis_kelamin'] = jenisKelamin;
    request.fields['ttl_anak'] = ttlAnak;
    request.fields['alamat_anak'] = alamatAnak;
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

//izin
class TidakMasukKerjaService {
  static Future<Map<String, dynamic>> submitForms({
    required String nama,
    required String nik,
    required String alamat,
    required String jabatan,
    required String instansi,
    required String tglAwal,
    required String tglAkhir,
    required String alasan,
    required List<String> filePaths, // boleh null
    required String username,
  }) async {
    var uri = Uri.parse("${AppConfig.baseUrl}/pengajuan/izin_kerja.php");
    var request = http.MultipartRequest("POST", uri);

    request.fields['kode_surat'] = "izin_kerja";
    request.fields['nama'] = nama;
    request.fields['nik'] = nik;
    request.fields['alamat'] = alamat;
    request.fields['jabatan'] = jabatan;
    request.fields['instansi'] = instansi;
    request.fields['tgl_awal'] = tglAwal;
    request.fields['tgl_akhir'] = tglAkhir;
    request.fields['alasan'] = alasan;
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

class KeramaianService {
  static Future<Map<String, dynamic>> submitForm({
    required String nama,
    required String nik,
    required String hari,
    required String tanggal,
    required String waktu,
    required String tempat,
    required String acara,
    required List<String> filePaths, // boleh null
    required String username,
  }) async {
    var uri = Uri.parse("${AppConfig.baseUrl}/pengajuan/izin_keramaian.php");
    var request = http.MultipartRequest("POST", uri);

    request.fields['kode_surat'] = "keramaian";
    request.fields['nama'] = nama;
    request.fields['nik'] = nik;
    request.fields['hari'] = hari;
    request.fields['tanggal'] = tanggal;
    request.fields['waktu'] = waktu;
    request.fields['tempat'] = tempat;
    request.fields['acara'] = acara;
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
