import 'package:elades20/Models/user_model.dart';
import 'package:flutter/material.dart';

class SuratPengantarSkck extends StatelessWidget {
  final void Function(int) onNavigate;
  final UserModel user;
  const SuratPengantarSkck({super.key, required this.onNavigate, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SKCK'),
      ),
      body: Center(
        child: const Text('Halaman Surat Pengangtar SKCK'),
      ),
    );
  }
}