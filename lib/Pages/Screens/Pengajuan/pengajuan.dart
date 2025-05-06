import 'package:elades20/Pages/Screens/Pengajuan/surat%20izin/keramaian.dart';
import 'package:elades20/Pages/Screens/Pengajuan/surat%20izin/tidak_masuk_kerja.dart';
import 'package:elades20/Pages/Screens/Pengajuan/surat%20keterangan/penghasilan_orang_tua.dart';
import 'package:elades20/Pages/Screens/Pengajuan/surat%20keterangan/sktm.dart';
import 'package:elades20/Pages/Screens/Pengajuan/surat%20pengantar/kehilangan_barang.dart';
import 'package:elades20/Pages/Screens/Pengajuan/surat%20pengantar/skck.dart';
import 'package:flutter/material.dart';

class Pengajuan extends StatelessWidget {
  final void Function(int) onNavigate;
  const Pengajuan({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8), // Background abu-abu muda
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Layanan Pengajuan Surat',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B9560),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Pilih surat yang ingin\nkamu ajukan',
                      textAlign:
                          TextAlign.center, // <-- biar teksnya rata tengah
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF77A88B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    SuratKategori(
                      title: "Surat Pengantar",
                      items: [
                        SuratItem(
                            icon: Icons.shield, text: "Surat Pengantar SKCK", 
                            onTap: () => onNavigate(7),
                            ),
                        SuratItem(
                            icon: Icons.search,
                            text: "Surat Pengantar Kehilangan Barang", 
                            onTap: () => onNavigate(8),
                            ),
                      ],
                    ),
                    SuratKategori(
                      title: "Surat Keterangan",
                      items: [
                        SuratItem(
                            icon: Icons.attach_money,
                            text: "Surat Keterangan Tidak Mampu (SKTM)", 
                            onTap: () => onNavigate(9),
                            ),
                        SuratItem(
                            icon: Icons.family_restroom,
                            text: "Surat Keterangan Penghasilan Orang Tua", 
                            onTap: () => onNavigate(10),
                            ),
                      ],
                    ),
                    SuratKategori(
                      title: "Surat Izin",
                      items: [
                        SuratItem(
                            icon: Icons.work_off,
                            text: "Surat Izin Tidak Masuk Kerja", 
                            onTap: () => onNavigate(11),
                            ),
                        SuratItem(
                            icon: Icons.celebration,
                            text: "Surat Izin Keramaian", 
                            onTap: () => onNavigate(12),
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SuratKategori extends StatelessWidget {
  final String title;
  final List<SuratItem> items;

  const SuratKategori({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF4B9560),
            ),
          ),
          const Divider(color: Colors.grey),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: item,
              )),
        ],
      ),
    );
  }
}

class SuratItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const SuratItem({super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell( // Membuat item bisa ditekan
      onTap: onTap, // Menambahkan fungsi saat item ditekan
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF4B9560),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
