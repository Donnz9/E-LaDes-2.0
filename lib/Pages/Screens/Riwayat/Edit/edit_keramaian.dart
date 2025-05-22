import 'package:elades20/Pages/Widgets/form_widgets.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
import 'package:elades20/Services/Riwayat/editPengajuan_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class EditKeramaian extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(int)? onNavigate;
  const EditKeramaian({
    super.key,
    required this.data,
    this.onNavigate,
  });

  @override
  State<EditKeramaian> createState() => _EditKeramaianState();
}

class _EditKeramaianState extends State<EditKeramaian> {
  List<String> _mediaPaths = [];

  @override
  void initState() {
    super.initState();
    requestPermissions();
    fillFormFromData(widget.data);
  }

  Future<void> requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _kegiatanController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  final TextEditingController _tempatController = TextEditingController();

  void fillFormFromData(Map<String, dynamic> data) {
    _namaController.text = data['nama'] ?? '';
    _nikController.text = data['nik'] ?? '';
    _alamatController.text = data['alamat'] ?? '';
    _kegiatanController.text = data['kegiatan'] ?? '';
    _tanggalController.text = data['tanggal'] ?? '';
    _waktuController.text = data['waktu'] ?? '';
    _tempatController.text = data['tempat'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: Color(0xFF4B9560)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Surat Izin Keramaian",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B9560),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Ajukan permohonan surat izin keramaian sebagai syarat administratif untuk menyelenggarakan acara yang melibatkan orang banyak, seperti hajatan, pertunjukan, atau kegiatan masyarakat lainnya, dengan persetujuan dari pihak desa.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Tambah Pengajuan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF4B9560),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.grey[200],
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Pastikan data permohonan lengkap diisi",
                        style: TextStyle(fontSize: 13),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Menggunakan widget dari FormWidgets
              FormWidgets.buildMedia(context, _mediaPaths,
                  (paths) => setState(() => _mediaPaths = paths)),
              const SizedBox(height: 16),
              FormWidgets.buildTextField(
                  label: "Nama Lengkap", controller: _namaController),
              FormWidgets.buildTextField(
                  label: "Alamat", controller: _alamatController),
              FormWidgets.buildNikField(
                  label: "NIK", controller: _nikController),
              FormWidgets.buildTextField(
                  label: "Kegiatan", controller: _kegiatanController),
              FormWidgets.buildDateField(
                  label: "Tanggal Kegiatan",
                  controller: _tanggalController,
                  context: context),
              FormWidgets.buildTimeField(
                  label: "Waktu",
                  controller: _waktuController,
                  context: context),
              FormWidgets.buildTextField(
                  label: "Tempat", controller: _tempatController),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_namaController.text.isEmpty ||
                      _nikController.text.isEmpty ||
                      _kegiatanController.text.isEmpty ||
                      _tanggalController.text.isEmpty ||
                      _waktuController.text.isEmpty ||
                      _tempatController.text.isEmpty ||
                      _alamatController.text.isEmpty) {
                    Snackbar.show(context, "Semua data wajib diisi!",
                        isError: true);
                    return;
                  }

                  // Tampilkan dialog konfirmasi
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Konfirmasi"),
                      content: const Text("Apakah semua data sudah benar?"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text(
                              "Belum",
                              style: TextStyle(color: Colors.black),
                            )),
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text(
                              "Sudah",
                              style: TextStyle(color: Color(0xFF4B9560)),
                            )),
                      ],
                    ),
                  );

                  // Jika user batal, hentikan
                  if (confirm != true) return;

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  try {
                    // Jika user sudah
                    final response = await editKeramaianService.submitForm(
                      nama: _namaController.text,
                      alamat: _alamatController.text,
                      nik: _nikController.text,
                      kegiatan: _kegiatanController.text,
                      tanggal: _tanggalController.text,
                      waktu: _waktuController.text,
                      tempat: _tempatController.text,
                      filePaths: _mediaPaths, // Pass all media paths
                      no_pengajuan: widget.data['no_pengajuan']?.toString() ?? '',
                    );
                    // Close loading dialog
                    Navigator.pop(context);

                    if (response['status'] == 'success') {
                      Snackbar.show(context, "Pengajuan berhasil dikirim!");
                      Navigator.pop(context);
                      if (widget.onNavigate != null) {
                        widget.onNavigate!(1); // Index 1 adalah halaman Riwayat
                      }
                    } else {
                      Snackbar.show(context, "Gagal: ${response['message']}",
                          isError: true);
                    }
                  } catch (e) {
                    // Close loading dialog
                    Navigator.pop(context);
                    Snackbar.show(context, "Error: $e", isError: true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B9560),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Ajukan Permohonan",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
