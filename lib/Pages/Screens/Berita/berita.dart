import 'package:flutter/material.dart';
import 'package:elades20/Models/dashboard/dashboard_model.dart';
import 'package:elades20/Pages/Widgets/dashboard/kabar_desa_card.dart';
import 'package:elades20/Services/Dashboard/KabarDesa_service.dart';

class Berita extends StatefulWidget {
  final void Function(int) onNavigate;
  final dynamic user;
  const Berita({super.key, required this.onNavigate, required this.user});

  @override
  State<Berita> createState() => _BeritaState();
}

class _BeritaState extends State<Berita> {
  List<KabarDesaModel> kabarDesaList = [];
  bool isLoadingKabarDesa = true;

  @override
  void initState() {
    super.initState();
    fetchKabarDesa();
  }

  Future<void> fetchKabarDesa() async {
    print("Berita: Starting fetchKabarDesa method");
    setState(() {
      isLoadingKabarDesa = true;
    });

    final service = KabarDesaService();
    try {
      print("Berita: Calling KabarDesaService.fetchKabarDesa()");
      final result = await service.fetchKabarDesa();

      print("Berita: Received result from service with ${result.length} items");

      setState(() {
        kabarDesaList = result;
        isLoadingKabarDesa = false;
        print(
            "Berita: Updated state with ${kabarDesaList.length} items, isLoadingKabarDesa=$isLoadingKabarDesa");
      });
    } catch (e) {
      print("Berita: Exception in fetchKabarDesa: $e");
      setState(() {
        isLoadingKabarDesa = false;
        print("Berita: Set isLoadingKabarDesa=false due to error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8), // Background abu-abu muda
      body: SafeArea(
        child: Column(
          children: [
            // Header tetap (fixed header)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Kabar Desa',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4B9560),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Informasi resmi seputar kegiatan dan pengumuman dari Pemerintah Desa',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF77A88B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            
            // Konten yang dapat di-scroll tanpa pembatas
            Expanded(
              child: isLoadingKabarDesa
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF4B9560),
                    ),
                  )
                : kabarDesaList.isEmpty
                  ? Center(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Belum ada kabar desa terbaru",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: fetchKabarDesa,
                      color: const Color(0xFF4B9560),
                      child: CustomScrollView(
                        physics: const ClampingScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return KabarDesaCard(
                                    kabarDesa: kabarDesaList[index],
                                  );
                                },
                                childCount: kabarDesaList.length,
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 20),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}