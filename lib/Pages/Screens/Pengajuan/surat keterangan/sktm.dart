import 'package:elades20/Models/user_model.dart';
import 'package:flutter/material.dart';

class SuratKeteranganTidakMampu extends StatelessWidget {
  final void Function(int) onNavigate;
  final UserModel user;
  const SuratKeteranganTidakMampu({super.key, required this.onNavigate, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surat Keterengan Tidak Mampu'),
      ),
      body: Center(
        child: const Text('Halaman Surat Keterengan Tidak Mampu'),
      ),
    );
  }
}