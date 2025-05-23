import 'package:elades20/Pages/Widgets/form_widgets.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
import 'package:elades20/Services/Riwayat/editPengajuan_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class EditSkck extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(int)? onNavigate;
  const EditSkck({super.key, required this.data, this.onNavigate});

  @override
  State<EditSkck> createState() => _EditSkckState();
}

class _EditSkckState extends State<EditSkck> {
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
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  String? _selectedKebangsaan;
  final TextEditingController _agamaController = TextEditingController();
  String? _selectedGender;
  String? _selectedStatusPerkawinan;
  final TextEditingController _pekerjaanController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  void fillFormFromData(Map<String, dynamic> data) {
    _namaController.text = data['nama'] ?? '';
    _nikController.text = data['nik'] ?? '';
    _tempatLahirController.text = data['tempat_lahir'] ?? '';
    _tanggalLahirController.text = data['tanggal_lahir'] ?? '';
    _selectedKebangsaan = data['kebangsaan'];
    _agamaController.text = data['agama'] ?? '';
    _selectedGender = data['jenis_kelamin'];
    _selectedStatusPerkawinan = data['status_perkawinan'];
    _pekerjaanController.text = data['pekerjaan'] ?? '';
    _alamatController.text = data['alamat'] ?? '';
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
                    "Surat Pengantar SKCK",
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
                  "Cek data laporan pengajuan permohonan surat pengantar SKCK anda.",
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
              const SizedBox(height: 16),
              FormWidgets.buildTextField(
                  label: "Nama Lengkap", controller: _namaController),
              FormWidgets.buildNikField(
                  label: "NIK", controller: _nikController),
              FormWidgets.buildTextField(
                  label: "Tempat Lahir", controller: _tempatLahirController),
              FormWidgets.buildDateField(
                  label: "Tanggal Lahir",
                  controller: _tanggalLahirController,
                  context: context),
              FormWidgets.buildDropdownField(
                label: "Kebangsaan",
                selectedValue: _selectedKebangsaan,
                onChanged: (value) {
                  setState(() {
                    _selectedKebangsaan = value;
                  });
                },
                items: const [
                  DropdownMenuItem(value: "WNI", child: Text("WNI")),
                  DropdownMenuItem(value: "WNA", child: Text("WNA")),
                ],
              ),
              FormWidgets.buildTextField(
                  label: "Agama", controller: _agamaController),
              FormWidgets.buildDropdownField(
                label: "Jenis Kelamin",
                selectedValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                items: const [
                  DropdownMenuItem(
                      value: "Laki-laki", child: Text("Laki-laki")),
                  DropdownMenuItem(
                      value: "Perempuan", child: Text("Perempuan")),
                ],
              ),
              FormWidgets.buildDropdownField(
                label: "Status Perkawinan",
                selectedValue: _selectedStatusPerkawinan,
                onChanged: (value) {
                  setState(() {
                    _selectedStatusPerkawinan = value;
                  });
                },
                items: const [
                  DropdownMenuItem(value: "Kawin", child: Text("Kawin")),
                  DropdownMenuItem(
                      value: "Belum kawin", child: Text("Belum kawin")),
                ],
              ),
              FormWidgets.buildTextField(
                  label: "Pekerjaan", controller: _pekerjaanController),
              FormWidgets.buildTextField(
                  label: "Alamat", controller: _alamatController),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_namaController.text.isEmpty ||
                      _nikController.text.isEmpty ||
                      _tempatLahirController.text.isEmpty ||
                      _tanggalLahirController.text.isEmpty ||
                      _selectedKebangsaan == null ||
                      _agamaController.text.isEmpty ||
                      _selectedGender == null ||
                      _selectedStatusPerkawinan == null ||
                      _pekerjaanController.text.isEmpty ||
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
                            child: const Text("Sudah",
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
                    final response = await editSKCKService.submitForm(
                      nama: _namaController.text,
                      nik: _nikController.text,
                      tempatLahir: _tempatLahirController.text,
                      tanggalLahir: _tanggalLahirController.text,
                      kebangsaan: _selectedKebangsaan!,
                      agama: _agamaController.text,
                      jenisKelamin: _selectedGender!,
                      statusPerkawinan: _selectedStatusPerkawinan!,
                      pekerjaan: _pekerjaanController.text,
                      alamat: _alamatController.text,
                      filePaths: _mediaPaths, // Pass all media paths
                      no_pengajuan: widget.data['no_pengajuan']?.toString() ?? '',
                    );
                    // Close loading dialog
                    Navigator.pop(context);

                    if (response['status'] == 'success') {
                      Snackbar.show(context, "Pengajuan berhasil dirubah!");
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
                  "Simpan Perubahan",
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
