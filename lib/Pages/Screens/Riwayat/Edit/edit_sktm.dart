import 'package:elades20/Pages/Widgets/form_widgets.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
import 'package:elades20/Services/Riwayat/editPengajuan_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class EditSktm extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(int)? onNavigate;
  const EditSktm({super.key, required this.data, this.onNavigate,});

  @override
  State<EditSktm> createState() =>
      _EditSktmState();
}

class _EditSktmState extends State<EditSktm> {
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

  //bapak
  final TextEditingController _namaBpkController = TextEditingController();
  final TextEditingController _tempatLahirBpkController =
      TextEditingController();
  final TextEditingController _tanggalLahirBpkController =
      TextEditingController();
  final TextEditingController _pekerjaanBpkController = TextEditingController();
  final TextEditingController _alamatBpkController = TextEditingController();

  //ibu
  final TextEditingController _namaIbuController = TextEditingController();
  final TextEditingController _tempatLahirIbuController =
      TextEditingController();
  final TextEditingController _tanggalLahirIbuController =
      TextEditingController();
  final TextEditingController _pekerjaanIbuController = TextEditingController();
  final TextEditingController _alamatIbuController = TextEditingController();

  //anak
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  String? _selectedGender;
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _keperluanController = TextEditingController();

  void fillFormFromData(Map<String, dynamic> data) {
    List<String> splitTempatTanggal(String? value) {
      if (value == null || !value.contains(',')) return ['', ''];
      final parts = value.split(',');
      return [parts[0].trim(), parts[1].trim()];
    }
    //bapak
    final ttlBpk = splitTempatTanggal(data['tempat_tanggal_lahir_bapak']);
    _namaBpkController.text = data['nama_bapak'] ?? '';
    _tempatLahirBpkController.text = ttlBpk[0];
    _tanggalLahirBpkController.text = ttlBpk[1];
    _pekerjaanBpkController.text = data['pekerjaan_bapak'] ?? '';
    _alamatBpkController.text = data['alamat_bapak'] ?? '';
    //ibu
    final ttlIbu = splitTempatTanggal(data['tempat_tanggal_lahir_ibu']);
    _namaIbuController.text = data['nama_ibu'] ?? '';
    _tempatLahirIbuController.text = ttlIbu[0];
    _tanggalLahirIbuController.text = ttlIbu[1];
    _pekerjaanIbuController.text = data['pekerjaan_ibu'] ?? '';
    _alamatIbuController.text = data['alamat_ibu'] ?? '';
    //anak
    final ttlAnak = splitTempatTanggal(data['tempat_tanggal_lahir_ibu']);
    _namaController.text = data['nama'] ?? '';
    _nikController.text = data['nik'] ?? '';
    _tempatLahirController.text = ttlAnak[0];
    _tanggalLahirController.text = ttlAnak[1];
    _selectedGender = data['jenis_kelamin_anak'];
    _alamatController.text = data['alamat'] ?? '';
    _keperluanController.text = data['keperluan'] ?? '';
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
                    "Surat Keterangan SKTM",
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
                  "Cek data laporan pengajuan permohonan surat keterangan tidak mampu (SKTM) anda.",
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

              //bapak
              const Text(
                "Bapak",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              FormWidgets.buildTextField(
                  label: "Nama Lengkap", controller: _namaBpkController),
              FormWidgets.buildTextField(
                  label: "Tempat Lahir", controller: _tempatLahirBpkController),
              FormWidgets.buildDateField(
                  label: "Tanggal Lahir",
                  controller: _tanggalLahirBpkController,
                  context: context),
              FormWidgets.buildTextField(
                  label: "Pekerjaan", controller: _pekerjaanBpkController),
              FormWidgets.buildTextField(
                  label: "Alamat", controller: _alamatBpkController),

              //ibu
              const SizedBox(height: 20),
              const Text(
                "Ibu",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              FormWidgets.buildTextField(
                  label: "Nama Lengkap", controller: _namaIbuController),
              FormWidgets.buildTextField(
                  label: "Tempat Lahir", controller: _tempatLahirIbuController),
              FormWidgets.buildDateField(
                  label: "Tanggal Lahir",
                  controller: _tanggalLahirIbuController,
                  context: context),
              FormWidgets.buildTextField(
                  label: "Pekerjaan", controller: _pekerjaanIbuController),
              FormWidgets.buildTextField(
                  label: "Alamat", controller: _alamatIbuController),

              //anak
              const SizedBox(height: 20),
              const Text(
                "Yang Bersangkutan (anak)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
                  label: "Alamat", controller: _alamatController),
              FormWidgets.buildTextField(
                  label: "Keperluan", controller: _keperluanController),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (
                      //bpk
                      _namaBpkController.text.isEmpty ||
                          _tanggalLahirBpkController.text.isEmpty ||
                          _tempatLahirBpkController.text.isEmpty ||
                          _pekerjaanBpkController.text.isEmpty ||
                          _alamatBpkController.text.isEmpty ||

                          //ibu
                          _namaIbuController.text.isEmpty ||
                          _tanggalLahirIbuController.text.isEmpty ||
                          _tempatLahirIbuController.text.isEmpty ||
                          _pekerjaanIbuController.text.isEmpty ||
                          _alamatIbuController.text.isEmpty ||

                          //anak
                          _namaController.text.isEmpty ||
                          _nikController.text.isEmpty ||
                          _tempatLahirController.text.isEmpty ||
                          _tanggalLahirController.text.isEmpty ||
                          _selectedGender == null ||
                          _keperluanController.text.isEmpty ||
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
                    final response = await editSKTMService.submitForm(
                      //bpk
                      namaBpk: _namaBpkController.text,
                      tempatLahirBpk: _tempatLahirBpkController.text,
                      tanggalLahirBpk: _tanggalLahirBpkController.text,
                      pekerjaanBpk: _pekerjaanBpkController.text,
                      alamatBpk: _alamatController.text,

                      //ibu
                      namaIbu: _namaIbuController.text,
                      tempatLahirIbu: _tempatLahirIbuController.text,
                      tanggalLahirIbu: _tanggalLahirIbuController.text,
                      pekerjaanIbu: _pekerjaanIbuController.text,
                      alamatIbu: _alamatController.text,

                      //anak
                      nama: _namaController.text,
                      nik: _nikController.text,
                      tempatLahir: _tempatLahirController.text,
                      tanggalLahir: _tanggalLahirController.text,
                      jenisKelamin: _selectedGender!,
                      alamat: _alamatController.text,
                      keperluan: _keperluanController.text,
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
