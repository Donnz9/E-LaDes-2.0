import 'package:elades20/Pages/Screens/Pengaduan/infrastruktur/infrastruktur.dart';
import 'package:elades20/Pages/Screens/Pengaduan/keamanan/keamanan.dart';
import 'package:elades20/Pages/Screens/Pengaduan/saran/saran.dart';
import 'package:flutter/material.dart';

class Pengaduan extends StatelessWidget {
  final void Function(int) onNavigate;
  final dynamic user;
  const Pengaduan({super.key, required this.onNavigate, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Center(
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
              const SizedBox(height: 40),
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
                        onTap: PengaduanInfrastruktur(
                          user: user,
                          onNavigate: onNavigate,
                        ),
                      ),
                      KategoriPengaduan(
                        icon: Icons.shield_outlined,
                        label: "Keamanan",
                        onTap: PengaduanKeamanan(
                          user: user,
                          onNavigate: onNavigate,
                        ),
                      ),
                      KategoriPengaduan(
                        icon: Icons.campaign,
                        label: "Saran",
                        onTap: PengaduanSaran(
                          user: user,
                          onNavigate: onNavigate,
                        ),
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
  final Widget onTap;

  const KategoriPengaduan({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => onTap),
          );
        },
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.green.shade300,
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
