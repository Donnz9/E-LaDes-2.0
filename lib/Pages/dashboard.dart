import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
                                    mainAxisAlignment: 
                                      MainAxisAlignment.center,
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
                                  child: Container(
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
                    _LayananDesaCard("Pengajuan Surat", Icons.file_copy),
                    _LayananDesaCard("Riwayat Surat", Icons.history),
                    _LayananDesaCard("Pengaduan", Icons.report),
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
                  children: [
                    _StatusPengajuanSuratCard("Masuk", "2"),
                    _StatusPengajuanSuratCard("Selesai", "1"),
                    _StatusPengajuanSuratCard("Tolak", "1"),
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

  // Widget untuk membuat kartu layanan desa
  // ignore: non_constant_identifier_names
  Widget _LayananDesaCard(String title, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        constraints:
            const BoxConstraints(minHeight: 111), 
        decoration: BoxDecoration(
          color: Colors.green.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // biar icon & teks tengah
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat kartu status pengajuan surat
  // ignore: non_constant_identifier_names
  Widget _StatusPengajuanSuratCard(String title, String count) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        constraints:
            const BoxConstraints(minHeight: 90), 
        decoration: BoxDecoration(
          color: Colors.green.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
