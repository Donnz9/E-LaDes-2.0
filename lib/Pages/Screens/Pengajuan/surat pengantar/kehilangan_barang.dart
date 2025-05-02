import 'dart:io';

import 'package:elades20/Services/permission_services.dart';
import 'package:flutter/material.dart';
import 'package:elades20/Services/Pengajuan/media_picker_service.dart';
import 'package:permission_handler/permission_handler.dart';

class SuratPengantarKehilanganBarang extends StatefulWidget {
  const SuratPengantarKehilanganBarang({super.key});

  @override
  State<SuratPengantarKehilanganBarang> createState() =>
      _SuratPengantarKehilanganBarangState();
}

class _SuratPengantarKehilanganBarangState
    extends State<SuratPengantarKehilanganBarang> {
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

  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _tanggalHilangController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B9560),
        title: const Text('Surat Kehilangan Barang'),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Surat Kehilangan Barang",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B9560),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Ajukan permohonan surat kehilangan barang untuk keperluan administrasi pelaporan kehilangan di kepolisian.",
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
              _buildMedia(context),
              const SizedBox(height: 16),
              _buildTextField(label: "Nama Lengkap"),
              _buildTextField(label: "Tempat Lahir"),
              _buildDateField(label: "Tanggal Lahir", controller: _tanggalLahirController),
              _buildTextField(label: "Agama"),
              _buildDropdownField(label: "Jenis Kelamin"),
              _buildTextField(label: "Pekerjaan"),
              _buildTextField(label: "Alamat"),
              _buildTextField(label: "Barang yang Hilang"),
              _buildDateField(label: "Hilang Pada Tanggal", controller: _tanggalHilangController),
              _buildTextField(label: "Tempat Kehilangan"),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B9560),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Ajukan Permohonan"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({required String label, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            String formattedDate =
                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
            setState(() {
              controller.text = formattedDate;
            });
          }
        },
      ),
    );
  }

  Widget _buildDropdownField({required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        items: const [
          DropdownMenuItem(value: "Laki-laki", child: Text("Laki-laki")),
          DropdownMenuItem(value: "Perempuan", child: Text("Perempuan")),
        ],
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildMedia(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Media (Foto/File)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _mediaPaths.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == _mediaPaths.length) {
                return _buildAddMediaButton(context);
              }

              final path = _mediaPaths[index];
              final isImage = path.endsWith('.jpg') ||
                  path.endsWith('.png') ||
                  path.endsWith('.jpeg');

              return Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: isImage
                        ? Image.file(File(path), fit: BoxFit.cover)
                        : const Icon(Icons.insert_drive_file,
                            size: 40, color: Colors.grey),
                  ),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: IconButton(
                      icon:
                          const Icon(Icons.cancel, color: Colors.red, size: 20),
                      onPressed: () {
                        setState(() {
                          _mediaPaths.removeAt(index);
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddMediaButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MediaPickerService.showMediaPicker(
          context: context,
          onFilePicked: (paths) {
            debugPrint('Media dipilih: $paths');
            setState(() {
              _mediaPaths.addAll(paths);
            });
          },
        );
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.add, size: 30, color: Colors.black54),
      ),
    );
  }
}
