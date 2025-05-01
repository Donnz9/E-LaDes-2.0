import 'package:flutter/material.dart';

class SuratKeteranganTidakMampu extends StatelessWidget {
  const SuratKeteranganTidakMampu({super.key});

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