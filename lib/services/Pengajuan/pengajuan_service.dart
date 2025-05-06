import 'dart:convert';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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
    required String? filePath, // boleh null
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

    if (filePath != null && filePath.isNotEmpty) {
      var file = await http.MultipartFile.fromPath(
        'file',
        filePath,
        contentType: MediaType('application', 'octet-stream'),
      );
      request.files.add(file);
    }

    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    print("Response: $respStr");
    return json.decode(respStr);
  }
}
