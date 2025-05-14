import 'package:elades20/Pages/Screens/Pengajuan/surat%20izin/keramaian.dart';
import 'package:elades20/Pages/Screens/Pengajuan/surat%20izin/tidak_masuk_kerja.dart';
import 'package:elades20/Pages/Screens/Pengajuan/surat%20keterangan/penghasilan_orang_tua.dart';
import 'package:elades20/Pages/Screens/Pengajuan/surat%20keterangan/sktm.dart';
import 'package:elades20/Pages/Screens/Pengajuan/surat%20pengantar/kehilangan_barang.dart';
import 'package:elades20/Pages/Screens/Pengajuan/surat%20pengantar/skck.dart';
import 'package:flutter/material.dart';

class Riwayat extends StatefulWidget {
  final void Function(int) onNavigate;
  final dynamic user;

  const Riwayat({super.key, required this.onNavigate, required this.user});

  @override
  State<Riwayat> createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  bool isPengajuan = true; // Default ke pengajuan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'Riwayat',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4B9560),
                          ),
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isPengajuan = true;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.green.shade300;
                            }
                            return isPengajuan
                                ? const Color(0xFF4B9560)
                                : Colors.green.shade300;
                          }),
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        child: const Text(
                          'PENGAJUAN',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isPengajuan = false;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.green.shade300;
                            }
                            return !isPengajuan
                                ? const Color(0xFF4B9560)
                                : Colors.green.shade300;
                          }),
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        child: const Text(
                          'PENGADUAN',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Konten ScrollView
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        if (isPengajuan) ...[
                          SuratKategori(
                            title: "Surat Pengantar",
                            items: [
                              SuratItem(
                                icon: Icons.shield,
                                text: "Surat Pengantar SKCK",
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SuratPengantarSkck(
                                      user: widget.user,
                                      onNavigate: widget.onNavigate,
                                    ),
                                  ),
                                ),
                              ),
                              SuratItem(
                                icon: Icons.search,
                                text: "Surat Pengantar Kehilangan Barang",
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SuratPengantarKehilanganBarang(
                                      user: widget.user,
                                      onNavigate: widget.onNavigate,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SuratKategori(
                            title: "Surat Izin",
                            items: [
                              SuratItem(
                                icon: Icons.work_off,
                                text: "Surat Izin Tidak Masuk Kerja",
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SuratIzinTidakMasukKerja(
                                      user: widget.user,
                                      onNavigate: widget.onNavigate,
                                    ),
                                  ),
                                ),
                              ),
                              SuratItem(
                                icon: Icons.celebration,
                                text: "Surat Izin Keramaian",
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SuratIzinKeramaian(
                                      user: widget.user,
                                      onNavigate: widget.onNavigate,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          SuratKategori(
                            title: "Surat Keterangan",
                            items: [
                              SuratItem(
                                icon: Icons.attach_money,
                                text: "Surat Keterangan Tidak Mampu (SKTM)",
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SuratKeteranganTidakMampu(
                                      user: widget.user,
                                      onNavigate: widget.onNavigate,
                                    ),
                                  ),
                                ),
                              ),
                              SuratItem(
                                icon: Icons.family_restroom,
                                text: "Surat Keterangan Penghasilan Orang Tua",
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SuratKeteranganPenghasilanOrangTua(
                                      user: widget.user,
                                      onNavigate: widget.onNavigate,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 20),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SuratKategori dan SuratItem tetap sama
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

  const SuratItem(
      {super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
