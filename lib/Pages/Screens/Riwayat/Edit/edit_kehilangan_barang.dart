import 'package:elades20/Pages/Widgets/form_widgets.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
import 'package:elades20/Services/config.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class EditKehilanganBarang extends StatefulWidget {
  final Map<String, dynamic> data;
  const EditKehilanganBarang({super.key, required this.data});

  @override
  State<EditKehilanganBarang> createState() => _EditKehilanganBarangState();
}

class _EditKehilanganBarangState extends State<EditKehilanganBarang> {
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

  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _tanggalHilangController =
      TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _agamaController = TextEditingController();
  final TextEditingController _pekerjaanController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _barangHilangController = TextEditingController();
  final TextEditingController _tempatKehilanganController =
      TextEditingController();
  String? _selectedGender;

  void fillFormFromData(Map<String, dynamic> data) {
    _tanggalLahirController.text = data['tanggal_lahir'] ?? '';
    _tanggalHilangController.text = data['hilang_pada_tanggal'] ?? '';
    _namaController.text = data['nama'] ?? '';
    _tempatLahirController.text = data['tempat_lahir'] ?? '';
    _agamaController.text = data['agama'] ?? '';
    _pekerjaanController.text = data['pekerjaan'] ?? '';
    _alamatController.text = data['alamat'] ?? '';
    _barangHilangController.text = data['barang_yang_hilang'] ?? '';
    _tempatKehilanganController.text = data['tempat_kehilangan'] ?? '';
    _selectedGender = data['jenis_kelamin'];

    // Load media paths jika ada
    if (data['file'] != null && data['file'] is List) {
      List<dynamic> rawMedia = data['file'];
      _mediaPaths = rawMedia
          .map((filename) =>
              "${AppConfig.uploads}/uploads/pengajuan/$filename")
          .cast<String>()
          .toList();
    }
    print("[DEBUG] Media URLs: $_mediaPaths");
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
                    "Surat Pengantar Kehilangan Barang",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B9560),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Ajukan permohonan surat pengantar kehilangan barang untuk keperluan administrasi pelaporan kehilangan di kepolisian.",
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
                  label: "Tempat Lahir", controller: _tempatLahirController),
              FormWidgets.buildDateField(
                  label: "Tanggal Lahir",
                  controller: _tanggalLahirController,
                  context: context),
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
              FormWidgets.buildTextField(
                  label: "Pekerjaan", controller: _pekerjaanController),
              FormWidgets.buildTextField(
                  label: "Alamat", controller: _alamatController),
              FormWidgets.buildTextField(
                  label: "Barang yang Hilang",
                  controller: _barangHilangController),
              FormWidgets.buildDateField(
                  label: "Hilang Pada Tanggal",
                  controller: _tanggalHilangController,
                  context: context),
              FormWidgets.buildTextField(
                  label: "Tempat Kehilangan",
                  controller: _tempatKehilanganController),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_namaController.text.isEmpty ||
                      _tempatLahirController.text.isEmpty ||
                      _tanggalLahirController.text.isEmpty ||
                      _agamaController.text.isEmpty ||
                      _selectedGender == null ||
                      _pekerjaanController.text.isEmpty ||
                      _alamatController.text.isEmpty ||
                      _barangHilangController.text.isEmpty ||
                      _tanggalHilangController.text.isEmpty ||
                      _tempatKehilanganController.text.isEmpty) {
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
                          ),
                        ),
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
                  //   final response = await KehilanganBarangService.submitForm(
                  //     nama: _namaController.text,
                  //     tempatLahir: _tempatLahirController.text,
                  //     tanggalLahir: _tanggalLahirController.text,
                  //     agama: _agamaController.text,
                  //     jenisKelamin: _selectedGender!,
                  //     pekerjaan: _pekerjaanController.text,
                  //     alamat: _alamatController.text,
                  //     barang: _barangHilangController.text,
                  //     tanggalHilang: _tanggalHilangController.text,
                  //     tempatKehilangan: _tempatKehilanganController.text,
                  //     filePaths: _mediaPaths, // Pass all media paths
                  //     username: widget.user.nama,
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
