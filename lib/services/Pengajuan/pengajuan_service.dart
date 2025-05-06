import 'dart:convert';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

//pengantar
class SKCKService {

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
  
}

class PenghasilanService {
  
}

//izin
class TidakMasukKerjaService {
  
}

class KeramaianService {
  
}