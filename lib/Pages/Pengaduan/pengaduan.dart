import 'package:flutter/material.dart';

class Pengaduan extends StatelessWidget {
  const Pengaduan({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F6F8),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Layanan Pengaduan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B9560),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Pilih pengaduan yang ingin\nkamu ajukan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF77A88B),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Expanded(
                child: Center(
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      KategoriPengaduan(
                        icon: Icons.engineering,
                        label: "Infrastruktur",
                      ),
                      KategoriPengaduan(
                        icon: Icons.shield_outlined,
                        label: "Keamanan",
                      ),
                      KategoriPengaduan(
                        icon: Icons.campaign,
                        label: "Saran",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KategoriPengaduan extends StatelessWidget {
  final IconData icon;
  final String label;

  const KategoriPengaduan({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Aksi ketika kategori diklik
        },
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFF4B9560),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 36),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
