import 'package:elades20/Pages/Screens/Riwayat/Edit/edit_infrastruktur.dart';
import 'package:elades20/Pages/Screens/Riwayat/Edit/edit_keamanan.dart';
import 'package:elades20/Pages/Screens/Riwayat/Edit/edit_kehilangan_barang.dart';
import 'package:elades20/Pages/Screens/Riwayat/Edit/edit_keramaian.dart';
import 'package:elades20/Pages/Screens/Riwayat/Edit/edit_penghasilan_orang_tua.dart';
import 'package:elades20/Pages/Screens/Riwayat/Edit/edit_saran.dart';
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
    final String kode =
        isPengajuan ? item['kode_surat'] ?? '' : item['kode_pengaduan'] ?? '';
    final String nomor =
        isPengajuan ? item['no_pengajuan'] ?? '' : item['no_pengaduan'] ?? '';
    final response = isPengajuan
        ? await RiwayatService.getSuratDetail(
            noPengajuan: nomor, kodeSurat: kode)
        : await RiwayatService.getPengaduanDetail(
            noPengaduan: nomor, kodePengaduan: kode);

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
      if (isPengajuan) {
        switch (kode.toLowerCase()) {
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
            print('[ERROR] Kode surat tidak dikenali: $kode');
            Snackbar.show(context, "Kode surat tidak dikenali: $kode",
                isError: true);
            return;
        }
      } else {
        // Kasus untuk pengaduan
        switch (kode.toLowerCase()) {
          case 'infrastruktur':
            targetPage = EditInfrastruktur(data: detailData);
            break;
          case 'keamanan':
            targetPage = EditKeamanan(data: detailData);
            break;
          case 'saran':
            targetPage = EditSaran(data: detailData);
            break;
          default:
            print('[ERROR] Kode pengaduan tidak dikenali: $kode');
            Snackbar.show(context, "Kode pengaduan tidak dikenali: $kode",
                isError: true);
            return;
        }
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
