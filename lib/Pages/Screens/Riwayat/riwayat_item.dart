import 'package:elades20/Pages/Widgets/snackbar.dart';
import 'package:flutter/material.dart';

class RiwayatItem extends StatelessWidget {
  final String noPengajuan;
  final String kodeSurat;
  final String nama;
  final String nik;
  final String tanggal;
  final String status;
  final bool isPengajuan;
  final VoidCallback onTap;

  const RiwayatItem({
    super.key,
    required this.noPengajuan,
    required this.kodeSurat,
    required this.nama,
    required this.nik,
    required this.tanggal,
    required this.status,
    required this.isPengajuan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    // Menentukan warna dan ikon berdasarkan status
    switch (status.toLowerCase()) {
      case 'masuk':
        statusColor = Colors.blue;
        statusIcon = Icons.arrow_downward;
        break;
      case 'selesai':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'tolak':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID: $noPengajuan',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusIcon,
                            size: 14,
                            color: statusColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            status,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (isPengajuan)
                  Text(
                    '$kodeSurat',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tanggal,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    // Menu Pop Up
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 'delete':
                            _showDeleteConfirmation(context);
                            break;
                          case 'edit':
                            _showEditDialog(context);
                            break;
                          case 'download':
                            _downloadDocument(context);
                            break;
                        }
                      },
                      itemBuilder: (context) {
                        // Kondisikan menu berdasarkan status
                        List<PopupMenuEntry<String>> menuItems = [];

                        if (status.toLowerCase() == 'selesai') {
                          // Jika selesai, hanya tampilkan unduh
                          menuItems.add(
                            const PopupMenuItem<String>(
                              value: 'download',
                              child: Row(
                                children: [
                                  Icon(Icons.download,
                                      color: Color(0xFF4B9560)),
                                  SizedBox(width: 8),
                                  Text('Unduh'),
                                ],
                              ),
                            ),
                          );
                        } else if (status.toLowerCase() == 'tolak' ||
                            status.toLowerCase() == 'masuk') {
                          // Jika tolak atau masuk, tampilkan hapus dan edit
                          menuItems.add(
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                          );

                          menuItems.add(
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Hapus'),
                                ],
                              ),
                            ),
                          );
                        }

                        return menuItems;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi hapus
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Konfirmasi',
          style: TextStyle(
            color: Color(0xFF4B9560),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text('Apakah Anda yakin ingin menghapus item ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implementasi hapus item
              Navigator.pop(context);
              Snackbar.show(context, "Item berhasil dihapus");
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan dialog edit
  void _showEditDialog(BuildContext context) {
    Snackbar.show(context, "Edit item akan tersedia");
  }

  // Fungsi untuk download dokumen
  void _downloadDocument(BuildContext context) {
    Snackbar.show(context, "Dokumen sedang diunduh...");
  }
}