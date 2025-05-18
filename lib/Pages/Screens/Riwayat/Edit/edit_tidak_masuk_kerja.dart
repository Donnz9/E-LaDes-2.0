import 'package:elades20/Pages/Widgets/form_widgets.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class EditTidakMasukKerja extends StatefulWidget {
  const EditTidakMasukKerja({
    Key? key,
  }) : super(key: key);

  @override
  State<EditTidakMasukKerja> createState() =>
      _EditTidakMasukKerjaState();
}

class _EditTidakMasukKerjaState extends State<EditTidakMasukKerja> {
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
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _tanggalAwalIzinController = TextEditingController();
  final TextEditingController _tanggalAkhirIzinController = TextEditingController();
  final TextEditingController _alasanController = TextEditingController();
  final TextEditingController _instansiController = TextEditingController();

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
                    "Surat Izin Tidak Masuk Kerja",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B9560),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              const Center(
                child: Text(
                  // "Ajukan permohonan surat izin tidak masuk kerja sebagai dokumen resmi untuk memberitahukan ketidakhadiran dalam pekerjaan karena alasan tertentu, seperti sakit, urusan keluarga, atau keperluan mendesak lainnya.",
                  "Cek pengajuan permohonan surat izin tidak masuk kerja anda",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Edit Pengajuan",
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
              const SizedBox(height: 20),

              FormWidgets.buildTextField(
                  label: "Nama Lengkap", controller: _namaController),
              FormWidgets.buildTextField(
                  label: "Tempat Lahir", controller: _tempatLahirController),
              FormWidgets.buildDateField(
                  label: "Tanggal Lahir",
                  controller: _tanggalLahirController,
                  context: context),
              FormWidgets.buildTextField(
                  label: "Alamat", controller: _alamatController),
              FormWidgets.buildDateField(
                  label: "Tanggal Awal Izin",
                  controller: _tanggalAwalIzinController,
                  context: context),
              FormWidgets.buildDateField(
                  label: "Tanggal Akhir Izin (opsional)",
                  controller: _tanggalAkhirIzinController,
                  context: context),
              FormWidgets.buildTextField(
                  label: "Alasan", controller: _alasanController),
              FormWidgets.buildTextField(
                  label: "Instansi", controller: _instansiController),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (
                    _namaController.text.isEmpty ||
                    _tempatLahirController.text.isEmpty ||
                    _tanggalLahirController.text.isEmpty ||
                    _tanggalAwalIzinController.text.isEmpty ||
                    _alasanController.text.isEmpty ||
                    _instansiController.text.isEmpty ||
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

                  // try {
                  //   // Jika user sudah
                  //   final response = await TidakMasukKerjaService.submitForm(
                  //     nama: _namaController.text,
                  //     tempatLahir: _tempatLahirController.text,
                  //     tanggalLahir: _tanggalLahirController.text,
                  //     alamat: _alamatController.text,
                  //     tanggalAwalIzin: _tanggalAwalIzinController.text,
                  //     tanggalAkhirIzin: _tanggalAkhirIzinController.text,
                  //     alasan: _alasanController.text,
                  //     instansi: _instansiController.text,
                  //     filePaths: _mediaPaths,
                  //   );
                  //   // Close loading dialog
                  //   Navigator.pop(context);

                  //   if (response['status'] == 'success') {
                  //     Snackbar.show(context, "Pengajuan berhasil dikirim!");
                  //     Navigator.pop(context);
                  //     widget.onNavigate(0);
                  //   } else {
                  //     Snackbar.show(context, "Gagal: ${response['message']}",
                  //         isError: true);
                  //   }
                  // } catch (e) {
                  //   // Close loading dialog
                  //   Navigator.pop(context);
                  //   Snackbar.show(context, "Error: $e", isError: true);
                  // }
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
