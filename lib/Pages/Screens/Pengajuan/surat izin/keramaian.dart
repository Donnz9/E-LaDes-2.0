import 'package:elades20/Models/user_model.dart';
import 'package:flutter/material.dart';

class SuratIzinKeramaian extends StatelessWidget {
  final void Function(int) onNavigate;
  final UserModel user;
  const SuratIzinKeramaian({super.key, required this.onNavigate, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surat Izin Keramaian'),
      ),
      body: Center(
        child: const Text('Halaman Surat Izin Keramaian'),
      ),
    );
  }
}