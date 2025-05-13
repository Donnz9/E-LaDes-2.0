import 'dart:convert';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

//pengantar
class SKCKService {
  static Future<Map<String, dynamic>> submitForm({
    required String nama,
    required String nik,
    required String tempatLahir,
    required String tanggalLahir,
    required String kebangsaan,
    required String agama,
    required String jenisKelamin,
    required String statusPerkawinan,
    required String pekerjaan,
    required String alamat,
    required List<String> filePaths, // boleh null
    required String username,
  }) async {
    var uri = Uri.parse("${AppConfig.baseUrl}/pengajuan/pengajuan_skck.php");
    var request = http.MultipartRequest("POST", uri);

    request.fields['kode_surat'] = "skck";
    request.fields['nama'] = nama;
    request.fields['nik'] = nik;
    request.fields['tempat_lahir'] = tempatLahir;
    request.fields['tanggal_lahir'] = tanggalLahir;
    request.fields['kebangsaan'] = kebangsaan;
    request.fields['agama'] = agama;
    request.fields['jenis_kelamin'] = jenisKelamin;
    request.fields['status_perkawinan'] = statusPerkawinan;
    request.fields['pekerjaan'] = pekerjaan;
    request.fields['alamat'] = alamat;
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

//keterangan
class SKTMService {
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

class PenghasilanService {
  static Future<Map<String, dynamic>> submitForm({
    //bapak
    required String namaOrtu,
    required String tempatLahirOrtu,
    required String tanggalLahirOrtu,
    required String pekerjaanOrtu,
    required String alamatOrtu,

    //anak
    required String namaAnak,
    required String tempatLahirAnak,
    required String tanggalLahirAnak,
    required String alamatAnak,
    required String keperluan,
    required List<String> filePaths, // boleh null
    required String username,
  }) async {
    var uri = Uri.parse("${AppConfig.baseUrl}/pengajuan/pengajuan_penghasilan.php");
    var request = http.MultipartRequest("POST", uri);

    request.fields['kode_surat'] = "penghasilan orang tua";
    //bpk
    request.fields['nama_ortu'] = namaOrtu;
    request.fields['tempat_tanggal_lahir_ortu'] = tempatLahirOrtu + ', ' + tanggalLahirOrtu;
    request.fields['pekerjaan_ortu'] = pekerjaanOrtu;
    request.fields['alamat_ortu'] = alamatOrtu;

    //anak
    request.fields['nama_anak'] = namaAnak;
    request.fields['tempat_tanggal_lahir_anak'] = tempatLahirAnak + ', ' + tanggalLahirAnak;
    request.fields['alamat_anak'] = alamatAnak;
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

//izin
class TidakMasukKerjaService {
  static Future<Map<String, dynamic>> submitForm({
    required String nama,
    required String tempatLahir,
    required String tanggalLahir,
    required String alamat,
    required String tanggalAwalIzin,
    required String tanggalAkhirIzin,
    required String alasan,
    required String instansi,
    required List<String> filePaths, // boleh null
    required String username,
  }) async {
    var uri = Uri.parse("${AppConfig.baseUrl}/pengajuan/pengajuan_TidakMasukKerja.php");
    var request = http.MultipartRequest("POST", uri);

    String tanggalIzin = tanggalAkhirIzin.isEmpty 
        ? tanggalAwalIzin 
        : tanggalAwalIzin + ' - ' + tanggalAkhirIzin;

    request.fields['kode_surat'] = "tidak masuk kerja";
    request.fields['nama'] = nama;
    request.fields['tempat_tanggal_lahir'] = tempatLahir + ', ' + tanggalLahir;
    request.fields['alamat'] = alamat;
    request.fields['tanggal_izin'] = tanggalIzin;
    request.fields['alasan'] = alasan;
    request.fields['instansi'] = instansi;
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
  
}