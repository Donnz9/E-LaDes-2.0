import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RiwayatDetailHelper {
  // Format tanggal dari API
  static String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return dateString;
    }
  }

  // Fungsi untuk menampilkan detail riwayat
  static void viewDetail(BuildContext context, dynamic item, bool isPengajuan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isPengajuan ? 'Detail Pengajuan' : 'Detail Pengaduan',
          style: const TextStyle(
            color: Color(0xFF4B9560),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('No Pengajuan', item['no_pengajuan'] ?? '-'),
            if (isPengajuan)
              _detailRow('Kode Surat', item['kode_surat'] ?? '-'),
            _detailRow('Nama', item['nama'] ?? '-'),
            _detailRow('NIK', item['nik'] ?? '-'),
            _detailRow('Tanggal', formatDate(item['tanggal'] ?? '')),
            _detailRow('Status', item['status'] ?? '-', isStatus: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Tutup',
              style: TextStyle(color: Color(0xFF4B9560)),
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk baris detail
  static Widget _detailRow(String label, String value, {bool isStatus = false}) {
    Color statusColor = Colors.grey;
    if (isStatus) {
      switch (value.toLowerCase()) {
        case 'masuk':
          statusColor = Colors.blue;
          break;
        case 'selesai':
          statusColor = Colors.green;
          break;
        case 'tolak':
          statusColor = Colors.red;
          break;
        default:
          statusColor = Colors.grey;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: isStatus
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Text(value),
          ),
        ],
      ),
    );
  }
}