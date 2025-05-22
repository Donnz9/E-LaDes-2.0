import 'package:elades20/Pages/Widgets/form_widgets.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
import 'package:elades20/Services/Riwayat/editPengajuan_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class EditPenghasilanOrangTua extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(int)? onNavigate;
  const EditPenghasilanOrangTua({super.key, required this.data, this.onNavigate,});

  @override
  State<EditPenghasilanOrangTua> createState() =>
      _EditPenghasilanOrangTuaState();
}

class _EditPenghasilanOrangTuaState extends State<EditPenghasilanOrangTua> {
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

  void fillFormFromData(Map<String, dynamic> data) {
    // Helper: pisah "Tempat, Tanggal"
    List<String> splitTempatTanggal(String? value) {
      if (value == null || !value.contains(',')) return ['', ''];
      final parts = value.split(',');
      return [parts[0].trim(), parts[1].trim()];
    }

    // ORANG TUA
    final ttlOrtu = splitTempatTanggal(data['tempat_tanggal_lahir_ortu']);
    _tempatLahirOrtuController.text = ttlOrtu[0];
    _tanggalLahirOrtuController.text = ttlOrtu[1];
    _namaOrtuController.text = data['nama_ortu'] ?? '';
    _pekerjaanOrtuController.text = data['pekerjaan_ortu'] ?? '';
    _alamatOrtuController.text = data['alamat_ortu'] ?? '';

    // ANAK
    final ttlAnak = splitTempatTanggal(data['tempat_tanggal_lahir_anak']);
    _tempatLahirAnakController.text = ttlAnak[0];
    _tanggalLahirAnakController.text = ttlAnak[1];
    _namaAnakController.text = data['nama_anak'] ?? '';
    _alamatAnakController.text = data['alamat_anak'] ?? '';
    _keperluanController.text = data['keperluan'] ?? '';
  }

  //bapak
  final TextEditingController _namaOrtuController = TextEditingController();
  final TextEditingController _tempatLahirOrtuController =
      TextEditingController();
  final TextEditingController _tanggalLahirOrtuController =
      TextEditingController();
  final TextEditingController _pekerjaanOrtuController =
      TextEditingController();
  final TextEditingController _alamatOrtuController = TextEditingController();

  //anak
  final TextEditingController _namaAnakController = TextEditingController();
  final TextEditingController _tempatLahirAnakController =
      TextEditingController();
  final TextEditingController _tanggalLahirAnakController =
      TextEditingController();
  final TextEditingController _alamatAnakController = TextEditingController();
  final TextEditingController _keperluanController = TextEditingController();

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
                    "Surat Keterangan\nPenghasilan Orang Tua",
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
                  "Ajukan permohonan surat keterangan penghasilan orang tua untuk keperluan administrasi yang membutuhkan informasi besaran pendapatan keluarga, seperti pengajuan beasiswa, Kartu Indonesia Pintar (KIP), atau syarat pendaftaran sekolah dan perguruan tinggi.",
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
              const SizedBox(height: 20),

              //bapak
              const Text(
                "Orang Tua",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              FormWidgets.buildTextField(
                  label: "Nama Lengkap", controller: _namaOrtuController),
              FormWidgets.buildTextField(
                  label: "Tempat Lahir",
                  controller: _tempatLahirOrtuController),
              FormWidgets.buildDateField(
                  label: "Tanggal Lahir",
                  controller: _tanggalLahirOrtuController,
                  context: context),
              FormWidgets.buildTextField(
                  label: "Pekerjaan", controller: _pekerjaanOrtuController),
              FormWidgets.buildTextField(
                  label: "Alamat", controller: _alamatOrtuController),

              //anak
              const SizedBox(height: 20),
              const Text(
                "Anak",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              FormWidgets.buildTextField(
                  label: "Nama Lengkap", controller: _namaAnakController),
              FormWidgets.buildTextField(
                  label: "Tempat Lahir",
                  controller: _tempatLahirAnakController),
              FormWidgets.buildDateField(
                  label: "Tanggal Lahir",
                  controller: _tanggalLahirAnakController,
                  context: context),
              FormWidgets.buildTextField(
                  label: "Alamat", controller: _alamatAnakController),
              FormWidgets.buildTextField(
                  label: "Keperluan", controller: _keperluanController),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (
                      //ortu
                      _namaOrtuController.text.isEmpty ||
                          _tanggalLahirOrtuController.text.isEmpty ||
                          _tempatLahirOrtuController.text.isEmpty ||
                          _pekerjaanOrtuController.text.isEmpty ||
                          _alamatOrtuController.text.isEmpty ||

                          //anak
                          _namaAnakController.text.isEmpty ||
                          _tempatLahirAnakController.text.isEmpty ||
                          _tanggalLahirAnakController.text.isEmpty ||
                          _keperluanController.text.isEmpty ||
                          _alamatAnakController.text.isEmpty) {
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
                    final response = await editPenghasilanService.submitForm(
                      //bpk
                      namaOrtu: _namaOrtuController.text,
                      tempatLahirOrtu: _tempatLahirOrtuController.text,
                      tanggalLahirOrtu: _tanggalLahirOrtuController.text,
                      pekerjaanOrtu: _pekerjaanOrtuController.text,
                      alamatOrtu: _alamatOrtuController.text,

                      //anak
                      namaAnak: _namaAnakController.text,
                      tempatLahirAnak: _tempatLahirAnakController.text,
                      tanggalLahirAnak: _tanggalLahirAnakController.text,
                      alamatAnak: _alamatAnakController.text,
                      keperluan: _keperluanController.text,
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
