import 'package:elades20/Models/dashboard/dashboard_model.dart';
import 'package:elades20/Models/user_model.dart';
import 'package:elades20/Pages/Screens/Pengaduan/pengaduan.dart';
import 'package:elades20/Pages/Screens/Pengajuan/pengajuan.dart';
import 'package:elades20/Pages/Widgets/dashboard/kabar_desa_card.dart';
import 'package:elades20/Pages/Widgets/dashboard/layanan_desa.dart';
import 'package:elades20/Pages/Widgets/dashboard/status_pengajuan_surat.dart';
import 'package:elades20/Services/Dashboard/KabarDesa_service.dart';
import 'package:elades20/Services/Dashboard/StatusPengajuan_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Dashboard extends StatefulWidget {
  final Function(int) onNavigate;
  final UserModel user;
  const Dashboard({super.key, required this.onNavigate, required this.user});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  StatusPengajuan? statusPengajuan;
  List<KabarDesaModel> kabarDesaList = []; // List untuk menyimpan data kabar desa
  bool isLoadingKabarDesa = true;

  @override
  void initState() {
    super.initState();
    fetchStatusPengajuan();
    fetchKabarDesa(); 
  }

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
      backgroundColor: const Color(0xFFF5F6F8), // Background abu-abu muda
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
                  children: [
                    StatusPengajuanSuratCard(
                      title: "Masuk",
                      count: statusPengajuan?.masuk.toString() ?? "0",
                    ),
                    StatusPengajuanSuratCard(
                      title: "Selesai",
                      count: statusPengajuan?.selesai.toString() ?? "0",
                    ),
                    StatusPengajuanSuratCard(
                      title: "Tolak",
                      count: statusPengajuan?.tolak.toString() ?? "0",
                    ),
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

                isLoadingKabarDesa
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : kabarDesaList.isEmpty
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Belum ada kabar desa terbaru",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Column(
                            children: kabarDesaList
                                .map((kabar) => KabarDesaCard(kabarDesa: kabar))
                                .toList(),
                          ),
                          
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchStatusPengajuan() async {
    final service = StatusPengajuanService();
    try {
      final result = await service.fetchStatus(widget.user.nama);

      if (result != null) {
        setState(() {
          statusPengajuan = result;
        });
      } else {
        print("Gagal ambil data status pengajuan");
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
    }
  }

  Future<void> fetchKabarDesa() async {
    print("Dashboard: Starting fetchKabarDesa method");
  setState(() {
    isLoadingKabarDesa = true;
  });

    final service = KabarDesaService();
    try {
      print("Dashboard: Calling KabarDesaService.fetchKabarDesa()");
      final result = await service.fetchKabarDesa();

      print("Dashboard: Received result from service with ${result.length} items");
      
      setState(() {
        kabarDesaList = result;
        isLoadingKabarDesa = false;
        print("Dashboard: Updated state with ${kabarDesaList.length} items, isLoadingKabarDesa=$isLoadingKabarDesa");
      });
    } catch (e) {
      print("Dashboard: Exception in fetchKabarDesa: $e");
      setState(() {
        isLoadingKabarDesa = false;
        print("Dashboard: Set isLoadingKabarDesa=false due to error");
      });
    }
  }
}
