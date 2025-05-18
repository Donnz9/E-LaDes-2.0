import 'package:elades20/Pages/Screens/Riwayat/Edit/edit_kehilangan_barang.dart';
import 'package:elades20/Pages/Screens/Riwayat/Edit/edit_keramaian.dart';
import 'package:elades20/Pages/Screens/Riwayat/Edit/edit_penghasilan_orang_tua.dart';
import 'package:elades20/Pages/Screens/Riwayat/Edit/edit_skck.dart';
import 'package:elades20/Pages/Screens/Riwayat/Edit/edit_sktm.dart';
import 'package:elades20/Pages/Screens/Riwayat/Edit/edit_tidak_masuk_kerja.dart';
import 'package:elades20/Services/Riwayat/riwayat_service.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RiwayatDetailHelper {
  static String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return dateString;
    }
  }

  static Future<void> viewDetail(
      BuildContext context, dynamic item, bool isPengajuan) async {
    final String kodeSurat = item['kode_surat'] ?? '';
    final String noPengajuan = item['no_pengajuan'] ?? '';
    print(
        '[DEBUG] Menampilkan detail untuk kode_surat: $kodeSurat, no_pengajuan: $noPengajuan');

    // Step 1: Ambil detail surat dari backend
    final response = await RiwayatService.getSuratDetail(
      noPengajuan: noPengajuan,
      kodeSurat: kodeSurat,
    );

    print('[DEBUG] Request noPengajuan: $noPengajuan, kodeSurat: $kodeSurat');
    print('[DEBUG] Response: $response');

    if (!response['success']) {
      print('[ERROR] Gagal mengambil detail surat: ${response['message']}');
      Snackbar.show(
          context, response['message'] ?? 'Gagal mengambil detail surat',
          isError: true);
      return;
    }

    final List<dynamic> detailList = response['data'];
    if (detailList.isEmpty) {
      Snackbar.show(context, "Data detail tidak ditemukan", isError: true);
      return;
    }
    final Map<String, dynamic> detailData = detailList[0];
    print('[DEBUG] Data detail berhasil diambil: $detailData');

    // Step 2: Navigasi berdasarkan kode surat sambil bawa data
    try {
      Widget targetPage;

      switch (kodeSurat.toLowerCase()) {
        case 'tidak masuk kerja':
          targetPage = EditTidakMasukKerja(data: detailData);
          break;
        case 'keramaian':
          targetPage = EditKeramaian(data: detailData);
          break;
        case 'sktm':
          targetPage = EditSktm(data: detailData);
          break;
        case 'penghasilan orang tua':
          targetPage = EditPenghasilanOrangTua(data: detailData);
          break;
        case 'skck':
          targetPage = EditSkck(data: detailData);
          break;
        case 'kehilangan barang':
          targetPage = EditKehilanganBarang(data: detailData);
          break;
        default:
          print('[ERROR] Kode surat tidak dikenali: $kodeSurat');
          Snackbar.show(context, "Kode surat tidak dikenali: $kodeSurat",
              isError: true);
          return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetPage),
      );
    } catch (e) {
      print('[EXCEPTION] Terjadi kesalahan saat mengambil detail surat: $e');
      Snackbar.show(context, "Gagal membuka halaman detail: $e", isError: true);
    }
  }
}
