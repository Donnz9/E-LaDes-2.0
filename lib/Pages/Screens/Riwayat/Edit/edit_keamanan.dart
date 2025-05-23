import 'package:elades20/Models/user_model.dart';
import 'package:elades20/Pages/Widgets/form_widgets.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
import 'package:elades20/Services/Pengaduan/pengaduan_service.dart';
import 'package:elades20/Services/Riwayat/editPengaduan_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class EditKeamanan extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(int)? onNavigate;
  const EditKeamanan({
    super.key,
    required this.data,
    this.onNavigate,
  });

  @override
  State<EditKeamanan> createState() => _EditKeamananState();
}

class _EditKeamananState extends State<EditKeamanan> {
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
  final TextEditingController _jenisKasusController = TextEditingController();
  final TextEditingController _lokasiController =
      TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  void fillFormFromData(Map<String, dynamic> data) {
    _namaController.text = data['nama'] ?? '';
    _nikController.text = data['nik'] ?? '';
    _jenisKasusController.text = data['jenis_kasus'] ?? '';
    _lokasiController.text = data['lokasi_kejadian'] ?? '';
    _tanggalController.text = data['tanggal'] ?? '';
    _waktuController.text = data['waktu'] ?? '';
    _deskripsiController.text = data['deskripsi'] ?? '';
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
                    "Pengaduan Keamanan",
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
                  "Ajukan laporan pengaduan mengenai gangguan keamanan atau ketertiban masyarakat, seperti pencurian, perkelahian, atau aktivitas mencurigakan, untuk ditindaklanjuti oleh pihak desa dan aparat keamanan.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Tambah Pengaduan",
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
              const Text(
                "Media wajib diisi",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 16),
              FormWidgets.buildTextField(
                  label: "Nama Lengkap", controller: _namaController),
              FormWidgets.buildNikField(
                  label: "NIK", controller: _nikController),
              FormWidgets.buildTextField(
                  label: "Jenis Kasus", controller: _jenisKasusController),
              FormWidgets.buildTextField(
                  label: "Lokasi Lengkap Kejadian",
                  controller: _lokasiController),
              FormWidgets.buildDateField(
                  label: "Tanggal Kejadian",
                  controller: _tanggalController, context: context),
              FormWidgets.buildTimeField(
                  label: "Waktu Kejadian",
                  controller: _waktuController,
                  context: context),
              FormWidgets.buildTextField(
                  label: "Deskripsi",
                  controller: _deskripsiController),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_mediaPaths.isEmpty ||
                      _namaController.text.isEmpty ||
                      _nikController.text.isEmpty ||
                      _jenisKasusController.text.isEmpty ||
                      _lokasiController.text.isEmpty ||
                      _tanggalController.text.isEmpty ||
                      _waktuController.text.isEmpty ||
                      _deskripsiController.text.isEmpty) {
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
                    final response = await EditKeamananService.submitForm(
                      nama: _namaController.text,
                      nik: _nikController.text,
                      jenis_kasus: _jenisKasusController.text,
                      lokasi_kejadian: _lokasiController.text,
                      tanggal: _tanggalController.text,
                      waktu: _waktuController.text,
                      deskripsi: _deskripsiController.text,
                      filePaths: _mediaPaths, // Pass all media paths
                      no_pengaduan: widget.data['no_pengaduan']?.toString() ?? '',
                    );
                    // Close loading dialog
                    Navigator.pop(context);

                    if (response['status'] == 'success') {
                      Snackbar.show(context, "Pengaduan berhasil dikirim!\nTerima kasih atas laporanya");
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
                  "Ajukan Pengaduan",
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
