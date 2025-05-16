import 'package:elades20/Models/user_model.dart';
import 'package:elades20/Pages/Widgets/form_widgets.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
import 'package:elades20/Services/Pengaduan/pengaduan_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PengaduanInfrastruktur extends StatefulWidget {
  final void Function(int) onNavigate;
  final UserModel user;
  const PengaduanInfrastruktur({
    Key? key,
    required this.user,
    required this.onNavigate,
  }) : super(key: key);

  @override
  State<PengaduanInfrastruktur> createState() => _PengaduanInfrastrukturState();
}

class _PengaduanInfrastrukturState extends State<PengaduanInfrastruktur> {
  List<String> _mediaPaths = [];

  @override
  void initState() {
    super.initState();
    requestPermissions();
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
  final TextEditingController _jenisInfrastrukturController =
      TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();

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
                    "Pengaduan Infrastruktur",
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
                  "Ajukan laporan pengaduan terkait infrastruktur desa, seperti jalan rusak, saluran air tersumbat, atau fasilitas umum yang tidak layak guna mendorong perbaikan dari pihak terkait.",
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
                  label: "Alamat", controller: _alamatController),
              FormWidgets.buildTextField(
                  label: "Jenis Infrastruktur",
                  controller: _jenisInfrastrukturController),
              FormWidgets.buildTextField(
                  label: "Deskripsi Masalah",
                  controller: _deskripsiController),
              FormWidgets.buildDateField(
                  label: "Tanggal Kejadian",
                  controller: _tanggalController,
                  context: context),
              FormWidgets.buildTextField(
                  label: "Lokasi Lengkap",
                  controller: _lokasiController),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_mediaPaths.isEmpty ||
                      _namaController.text.isEmpty ||
                      _nikController.text.isEmpty ||
                      _alamatController.text.isEmpty ||
                      _jenisInfrastrukturController.text.isEmpty ||
                      _deskripsiController.text.isEmpty ||
                      _tanggalController.text.isEmpty ||
                      _lokasiController.text.isEmpty) {
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
                    final response = await InfrastrukturService.submitForm(
                      nama: _namaController.text,
                      nik: _nikController.text,
                      alamat: _alamatController.text,
                      jenis_infrastruktur: _jenisInfrastrukturController.text,
                      deskripsi: _deskripsiController.text,
                      tanggal_kejadian: _tanggalController.text,
                      filePaths: _mediaPaths, // Pass all media paths
                      lokasi: _lokasiController.text,
                      username: widget.user.nama,
                    );
                    // Close loading dialog
                    Navigator.pop(context);

                    if (response['status'] == 'success') {
                      Snackbar.show(context, "Pengaduan berhasil dikirim!\nTerima kasih atas laporanya");
                      Navigator.pop(context);
                      widget.onNavigate(2);
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
