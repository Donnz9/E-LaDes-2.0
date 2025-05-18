import 'package:elades20/Pages/Screens/Riwayat/Edit/edit_tidak_masuk_kerja.dart';
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
    final String kodeSurat = item['kode_surat'] ?? '';

    // Jika kode surat adalah "tidak masuk kerja", alihkan ke halaman EditTidakMasukKerja
    if (kodeSurat.toLowerCase() == 'tidak masuk kerja') {
      try {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EditTidakMasukKerja(),
          ),
        );
      } catch (e) {
        // Tangani error dengan menampilkan dialog
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text("Tidak dapat membuka halaman Edit Tidak Masuk Kerja: ${e.toString()}"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
      return; // Keluar dari method viewDetail karena sudah dialihkan
    }

    // Buat salinan item untuk menampung perubahan
    Map<String, dynamic> editedItem = Map<String, dynamic>.from(item);

    // Controller untuk mode edit
    Map<String, TextEditingController> controllers = {};

    // Inisialisasi controller untuk setiap field yang bisa diedit
    void initControllers() {
      // Common fields
      controllers['nama'] = TextEditingController(text: item['nama'] ?? '');
      controllers['alamat'] = TextEditingController(text: item['alamat'] ?? '');

      // Keramaian fields
      if (kodeSurat.toLowerCase() == 'keramaian') {
        controllers['kegiatan'] =
            TextEditingController(text: item['kegiatan'] ?? '');
        controllers['tanggal_kegiatan'] =
            TextEditingController(text: item['tanggal_kegiatan'] ?? '');
        controllers['waktu'] = TextEditingController(text: item['waktu'] ?? '');
        controllers['tempat'] =
            TextEditingController(text: item['tempat'] ?? '');
      }
    }

    // Inisialisasi controllers
    initControllers();

    // State untuk mode edit
    bool isEditMode = false;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isPengajuan ? 'Detail Pengajuan' : 'Detail Pengaduan',
                  style: const TextStyle(
                    color: Color(0xFF4B9560),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (item['status']?.toLowerCase() ==
                    'masuk') // Hanya izinkan edit jika status "masuk"
                  IconButton(
                    icon: Icon(
                      isEditMode ? Icons.save : Icons.edit,
                      color: Color(0xFF4B9560),
                    ),
                    onPressed: () {
                      if (isEditMode) {
                        // Simpan perubahan
                        controllers.forEach((key, controller) {
                          editedItem[key] = controller.text;
                        });


                        // Untuk demo, kita hanya ubah state
                        setState(() {
                          isEditMode = false;
                          item = editedItem;
                        });

                        // Tampilkan snackbar sukses
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          SnackBar(
                            content: Text('Perubahan berhasil disimpan'),
                            backgroundColor: Color(0xFF4B9560),
                          ),
                        );
                      } else {
                        // Masuk mode edit
                        setState(() {
                          isEditMode = true;
                        });
                      }
                    },
                  ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow(
                    'No Pengajuan',
                    item['no_pengajuan'] ?? '-',
                    null, // Tidak perlu controller (tidak dapat diedit)
                    isEditMode,
                    isEditable: false,
                  ),
                  if (isPengajuan)
                    _buildRow(
                      'Kode Surat',
                      kodeSurat,
                      null, // Tidak perlu controller (tidak dapat diedit)
                      isEditMode,
                      isEditable: false,
                    ),

                  // Tampilkan field berbeda berdasarkan kode surat
                  if (kodeSurat.toLowerCase() == 'keramaian')
                    ..._buildKeramaianDetails(
                        editedItem, controllers, isEditMode)
                  else ...[
                    _buildRow('Nama', item['nama'] ?? '-', controllers['nama'],
                        isEditMode),
                  ],

                  _buildRow(
                    'Tanggal Pengajuan',
                    formatDate(item['tanggal'] ?? ''),
                    null, // Tidak perlu controller (tidak dapat diedit)
                    isEditMode,
                    isEditable: false,
                  ),
                  _buildStatusRow('Status', item['status'] ?? '-'),
                ],
              ),
            ),
            actions: [
              if (isEditMode)
                TextButton(
                  onPressed: () {
                    setState(() {
                      isEditMode = false;
                      initControllers(); // Reset controllers ke nilai awal
                    });
                  },
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Tutup',
                  style: TextStyle(color: Color(0xFF4B9560)),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  // Detail spesifik untuk Surat Izin Keramaian
  static List<Widget> _buildKeramaianDetails(Map<String, dynamic> item,
      Map<String, TextEditingController> controllers, bool isEditMode) {
    return [
      _buildRow('Nama', item['nama'] ?? '-', controllers['nama'], isEditMode),
      _buildRow(
          'Alamat', item['alamat'] ?? '-', controllers['alamat'], isEditMode),
      _buildRow('Kegiatan', item['kegiatan'] ?? '-', controllers['kegiatan'],
          isEditMode),
      _buildRow('Tanggal Kegiatan', formatDate(item['tanggal_kegiatan'] ?? ''),
          controllers['tanggal_kegiatan'], isEditMode,
          isDateField: true),
      _buildRow(
          'Waktu', item['waktu'] ?? '-', controllers['waktu'], isEditMode),
      _buildRow(
          'Tempat', item['tempat'] ?? '-', controllers['tempat'], isEditMode),
    ];
  }

  // Helper untuk menangani pemilihan tanggal
  static Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  // Helper untuk baris detail dengan mode edit
  static Widget _buildRow(String label, String value,
      TextEditingController? controller, bool isEditMode,
      {bool isEditable = true, bool isDateField = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: isEditMode && isEditable
                ? isDateField
                    ? Builder(
                        builder: (context) => TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            suffixIcon: Icon(Icons.calendar_today, size: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectDate(context, controller!);
                          },
                        ),
                      )
                    : TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      )
                : Text(value),
          ),
        ],
      ),
    );
  }

  // Helper untuk baris status
  static Widget _buildStatusRow(String label, String value) {
    Color statusColor = Colors.grey;
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
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
            ),
          ),
        ],
      ),
    );
  }
}