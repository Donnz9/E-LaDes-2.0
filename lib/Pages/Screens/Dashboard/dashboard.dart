import 'package:elades20/Models/user_model.dart';
import 'package:elades20/Pages/Screens/Pengaduan/pengaduan.dart';
import 'package:elades20/Pages/Screens/Pengajuan/pengajuan.dart';
import 'package:elades20/Pages/Widgets/layanan_desa.dart';
import 'package:elades20/Pages/Widgets/status_pengajuan_surat.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Dashboard extends StatefulWidget {
  final Function(int) onNavigate;
  const Dashboard({super.key, required this.onNavigate});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 155,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        children: [
                          // Slide A custom
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Atur vertikal alignment
                              children: [
                                // Teks sebelah kiri
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Selamat Datang!",
                                        style: GoogleFonts.inter(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Pengajuan Surat kini semakin mudah! \nCoba sekarang!",
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 16),
                                // Gambar sebelah kanan, kecil dan turun dikit
                                Align(
                                  alignment: Alignment
                                      .centerRight, // Bisa jadi centerRight, topRight, dsb.
                                  child: SizedBox(
                                    height: 100, // atur tinggi sesuka hati
                                    width: 100, // atur lebar sesuka hati
                                    child: Image.asset(
                                      "assets/images/header/output1.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Slide B
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              "assets/images/header/output2.png",
                              fit: BoxFit.cover, // nge-full-in container
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),

                          // Slide C
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              "assets/images/header/output3.jpg",
                              fit: BoxFit.cover, // nge-full-in container
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Indikator dots
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 3,
                        effect: WormEffect(
                          dotHeight: 10,
                          dotWidth: 10,
                          activeDotColor: Colors.green.shade700,
                          dotColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Layanan Desa
                Text(
                  "Layanan Desa",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LayananDesaCard(
                      title: "Pengajuan Surat",
                      icon: Icons.file_copy,
                      onTap: () => widget.onNavigate(0),
                    ),
                    LayananDesaCard(
                      title: "Riwayat Surat",
                      icon: Icons.history,
                      onTap: () => widget.onNavigate(1),
                    ),
                    LayananDesaCard(
                      title: "Pengaduan",
                      icon: Icons.report,
                      onTap: () => widget.onNavigate(2),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Status Pengajuan Surat
                Text(
                  "Status Pengajuan Surat",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    StatusPengajuanSuratCard(title: "Masuk", count: "2"),
                    StatusPengajuanSuratCard(title: "Selesai", count: "1"),
                    StatusPengajuanSuratCard(title: "Tolak", count: "1"),
                  ],
                ),

                const SizedBox(height: 16),

                // Kabar Desa
                Text(
                  "Kabar Desa",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "SUDAHKAH KALIAN MENGETAHUI KEPALA DESA KAUMAN?",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
