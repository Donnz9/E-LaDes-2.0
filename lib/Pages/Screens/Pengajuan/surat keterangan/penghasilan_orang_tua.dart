import 'package:elades20/Models/user_model.dart';
import 'package:flutter/material.dart';

class SuratKeteranganPenghasilanOrangTua extends StatelessWidget {
  final void Function(int) onNavigate;
  final UserModel user;
  const SuratKeteranganPenghasilanOrangTua({super.key, required this.onNavigate, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surat Penghasilan Orang Tua'),
      ),
      body: Center(
        child: const Text('Halaman Surat Keterangan Penghasilan Orang Tua'),
      ),
    );
  }
}