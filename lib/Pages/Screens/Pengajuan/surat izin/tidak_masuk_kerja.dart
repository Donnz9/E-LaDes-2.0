import 'dart:io';

import 'package:elades20/Models/user_model.dart';
import 'package:elades20/Pages/Widgets/form_widgets.dart';
import 'package:elades20/Services/Pengajuan/pengajuan_service.dart';
import 'package:elades20/Services/permission_services.dart';
import 'package:flutter/material.dart';
import 'package:elades20/Services/Pengajuan/media_picker_service.dart';
import 'package:permission_handler/permission_handler.dart';

class SuratIzinTidakMasukKerja extends StatefulWidget {
  final void Function(int) onNavigate;
  final UserModel user;
  const SuratIzinTidakMasukKerja({
    Key? key,
    required this.user,
    required this.onNavigate,
  }) : super(key: key);

  @override
  State<SuratIzinTidakMasukKerja> createState() =>
      _SuratIzinTidakMasukKerjaState();
}

class _SuratIzinTidakMasukKerjaState extends State<SuratIzinTidakMasukKerja> {
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
  final TextEditingController _jabatanController = TextEditingController();
  final TextEditingController _instansiController = TextEditingController();
  final TextEditingController _tglAwalController = TextEditingController();
  final TextEditingController _tglAkhirController = TextEditingController();
  final TextEditingController _alasanController = TextEditingController();
  // String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFF4B9560),
      //   title: const Text('Surat Kehilangan Barang'),
      //   foregroundColor: Colors.white,
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
                    "Surat Izin Tidak Masuk Kerja",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B9560),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Ajukan permohonan Anda untuk mendapatkan Surat Izin Tidak Masuk Kerja sebagai dokumen resmi yang menerangkan jumlah penghasilan orang tua, yang dikeluarkan oleh Pemerintah Desa Kauman.",
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
                  label: "NIK", controller: _nikController),
              FormWidgets.buildTextField(
                  label: "Alamat", controller: _alamatController),
              FormWidgets.buildTextField(
                  label: "Jabatan", controller: _jabatanController),
              FormWidgets.buildTextField(
                  label: "Instansi", controller: _instansiController),
              FormWidgets.buildDateField(
                  label: "Berlaku Tanggal",
                  controller: _tglAwalController,
                  context: context),
              FormWidgets.buildDateField(
                  label: "Berakhir Tanggal",
                  controller: _tglAkhirController,
                  context: context),
              FormWidgets.buildTextField(
                  label: "Alasan", controller: _alasanController),
              // FormWidgets.buildDropdownField(
              //   label: "Jenis Kelamin",
              //   selectedValue: _selectedGender,
              //   onChanged: (value) {
              //     setState(() {
              //       _selectedGender = value;
              //     });
              //   },
              //   items: const [
              //     DropdownMenuItem(
              //         value: "Laki-laki", child: Text("Laki-laki")),
              //     DropdownMenuItem(
              //         value: "Perempuan", child: Text("Perempuan")),
              //   ],
              // ),

              // FormWidgets.buildTextField(
              //     label: "Alamat Anak", controller: _alamatAnakController),
              // FormWidgets.buildTextField(
              //     label: "Tempat Kehilangan",
              //     controller: _tempatKehilanganController),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_namaController.text.isEmpty ||
                      _nikController.text.isEmpty ||
                      _alamatController.text.isEmpty ||
                      _jabatanController.text.isEmpty ||
                      // _selectedGender == null ||
                      _instansiController.text.isEmpty ||
                      _tglAwalController.text.isEmpty ||
                      _tglAkhirController.text.isEmpty ||
                      _alasanController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Semua data wajib diisi!"),
                        backgroundColor: Colors.red,
                      ),
                    );
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
                          child: const Text("Belum"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Sudah"),
                        ),
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
                    final response = await TidakMasukKerjaService.submitForms(
                      nama: _namaController.text,
                      nik: _nikController.text,
                      alamat: _alamatController.text,
                      jabatan: _jabatanController.text,
                      instansi: _instansiController.text,
                      tglAwal: _tglAwalController.text,
                      tglAkhir: _tglAkhirController.text,
                      alasan: _alasanController.text,
                      filePaths: _mediaPaths, // Pass all media paths
                      username: widget.user.nama,
                    );
                    // Close loading dialog
                    Navigator.pop(context);

                    if (response['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Pengajuan berhasil dikirim!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                      widget.onNavigate(0);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Gagal: ${response['message']}"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    // Close loading dialog
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
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
