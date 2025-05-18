import 'package:elades20/Pages/Screens/Riwayat/riwayat_detail.dart';
import 'package:elades20/Pages/Screens/Riwayat/riwayat_item.dart';
import 'package:elades20/Services/Riwayat/riwayat_service.dart';
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
  bool isLoading = false;
  List<dynamic> riwayatData = [];
  List<dynamic> filteredData = []; // Data yang sudah difilter berdasarkan status
  String errorMessage = '';
  String selectedStatus = 'Semua'; // Default filter status

  // Daftar pilihan status untuk dropdown
  final List<String> statusOptions = ['Semua', 'Masuk', 'Selesai', 'Tolak'];

  @override
  void initState() {
    super.initState();
    _fetchRiwayatData();
  }

  // Sekarang memanggil Service terpisah
  Future<void> _fetchRiwayatData() async {
    final result = await RiwayatService.fetchRiwayatData(
      username: widget.user.nama,
      isPengajuan: isPengajuan,
      setLoading: (value) => setState(() => isLoading = value),
      setErrorMessage: (value) => setState(() => errorMessage = value),
    );

    if (result['success']) {
      setState(() {
        riwayatData = result['data'];
        _applyStatusFilter(); // Terapkan filter status
      });
      print("Data berhasil dimuat dan diurutkan: ${result['data'].length} item");
    } else {
      setState(() {
        riwayatData = [];
        filteredData = [];
      });
      print("Gagal ambil data: ${result['message']}");
    }
  }

  // Fungsi untuk menerapkan filter status
  void _applyStatusFilter() {
    if (selectedStatus == 'Semua') {
      // Tampilkan semua data
      filteredData = List.from(riwayatData);
    } else {
      // Filter berdasarkan status yang dipilih
      filteredData = riwayatData.where((item) {
        return (item['status'] ?? '').toLowerCase() ==
            selectedStatus.toLowerCase();
      }).toList();
    }
  }

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
                            selectedStatus =
                                'Semua'; // Reset filter saat ganti tab
                          });
                          _fetchRiwayatData();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.green.shade300;
                            }
                            return isPengajuan
                                ? const Color(0xFF4B9560)
                                : Colors.green.shade300;
                          }),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          shape: MaterialStateProperty.all(
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
                            selectedStatus =
                                'Semua'; // Reset filter saat ganti tab
                          });
                          _fetchRiwayatData();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.green.shade300;
                            }
                            return !isPengajuan
                                ? const Color(0xFF4B9560)
                                : Colors.green.shade300;
                          }),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          shape: MaterialStateProperty.all(
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
                  const SizedBox(height: 5),

                  // Tombol dropdown filter status
                  Container(
                    width: double.infinity, // Mengatur lebar sesuai parent
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 110,
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF4B9560)),
                            color: Colors.white,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedStatus,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Color(0xFF4B9560)),
                              items: statusOptions.map((String status) {
                                return DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: status == selectedStatus
                                          ? const Color(0xFF4B9560)
                                          : Colors.black,
                                      fontWeight: status == selectedStatus
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedStatus = newValue;
                                    _applyStatusFilter();
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            // Konten ScrollView dengan data dari API
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF4B9560),
                      ),
                    )
                  : filteredData.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                errorMessage.isEmpty
                                    ? selectedStatus == 'Semua'
                                        ? 'Belum ada riwayat ${isPengajuan ? 'pengajuan' : 'pengaduan'}'
                                        : 'Tidak ada ${isPengajuan ? 'pengajuan' : 'pengaduan'} dengan status "$selectedStatus"'
                                    : errorMessage,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            final item = filteredData[index];
                            return RiwayatItem(
                              noPengajuan: item['no_pengajuan'] ?? '-',
                              kodeSurat: item['kode_surat'] ?? '-',
                              nama: item['nama'] ?? 'Tidak ada nama',
                              tanggal: RiwayatDetailHelper.formatDate(item['tanggal'] ?? ''),
                              status: item['status'] ?? 'Tidak diketahui',
                              isPengajuan: isPengajuan,
                              onTap: () => RiwayatDetailHelper.viewDetail(context, item, isPengajuan),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}