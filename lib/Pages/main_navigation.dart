import 'package:elades20/Models/user_model.dart';
import 'package:elades20/Pages/Screens/Berita/berita.dart';
import 'package:elades20/Pages/Screens/Dashboard/dashboard.dart';
import 'package:elades20/Pages/Screens/Notifikasi/notifikasi.dart';
import 'package:elades20/Pages/Screens/Pengaduan/infrastruktur/infrastruktur.dart';
import 'package:elades20/Pages/Screens/Pengaduan/keamanan/keamanan.dart';
import 'package:elades20/Pages/Screens/Pengaduan/pengaduan.dart';
import 'package:elades20/Pages/Screens/Pengaduan/saran/saran.dart';
import 'package:elades20/Pages/Screens/Pengajuan/pengajuan.dart';
import 'package:elades20/Pages/Screens/Pengajuan/surat%20izin/keramaian.dart';
import 'package:elades20/Pages/Screens/Pengajuan/surat%20izin/tidak_masuk_kerja.dart';
import 'package:elades20/Pages/Screens/Pengajuan/surat%20keterangan/penghasilan_orang_tua.dart';
import 'package:elades20/Pages/Screens/Pengajuan/surat%20keterangan/sktm.dart';
import 'package:elades20/Pages/Screens/Pengajuan/surat%20pengantar/kehilangan_barang.dart';
import 'package:elades20/Pages/Screens/Pengajuan/surat%20pengantar/skck.dart';
import 'package:elades20/Pages/Screens/Profil/profile.dart';
import 'package:elades20/Pages/Screens/Riwayat/riwayat.dart';
import 'package:elades20/Pages/Widgets/nav_item.dart';
import 'package:elades20/Pages/Widgets/top_bar.dart';
import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  final UserModel user;
  const MainNavigation({super.key, required this.user});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 3;
  late UserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  // Fungsi untuk memperbarui UserModel saat profil diubah
  void _updateUserModel(UserModel updatedUser) {
    setState(() {
      currentUser = updatedUser;
    });
    print(
        "User model diperbarui: ${updatedUser.nama}, ${updatedUser.email ?? updatedUser.noHp}");
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      Pengajuan(
        onNavigate: _onItemTapped,
        user: currentUser,
      ),
      Riwayat(
        onNavigate: _onItemTapped,
        user: currentUser,
      ),
      Pengaduan(
        onNavigate: _onItemTapped,
        user: currentUser,
      ),
      Dashboard(
        onNavigate: _onItemTapped,
        user: currentUser,
      ),
      Berita(
        onNavigate: _onItemTapped,
        user: currentUser,
      ),
      const Notifikasi(),
      Profile(
        user: currentUser,
        onProfileUpdated: _updateUserModel,
      ),
      SuratPengantarSkck(user: currentUser, onNavigate: _onItemTapped),
      SuratPengantarKehilanganBarang(
          user: currentUser, onNavigate: _onItemTapped),
      SuratKeteranganTidakMampu(user: currentUser, onNavigate: _onItemTapped),
      SuratKeteranganPenghasilanOrangTua(
          user: currentUser, onNavigate: _onItemTapped),
      SuratIzinTidakMasukKerja(user: currentUser, onNavigate: _onItemTapped),
      SuratIzinKeramaian(user: currentUser, onNavigate: _onItemTapped),
      PengaduanInfrastruktur(user: currentUser, onNavigate: _onItemTapped),
      PengaduanKeamanan(user: currentUser, onNavigate: _onItemTapped),
      PengaduanSaran(user: currentUser, onNavigate: _onItemTapped),
      //nek pengin nambahne tambahne ng ngisore ae, mergo kudu urut index
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              onProfileTap: () => _onItemTapped(6),
              onNotifTap: () => _onItemTapped(5),
              user: currentUser,
            ),
            Expanded(child: _pages[_selectedIndex]),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () => _onItemTapped(3),
          backgroundColor: const Color(0xFF6A9F73),
          shape: const CircleBorder(),
          elevation: 10,
          child: const Icon(Icons.home, size: 30, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ShadowedBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        shadowColor: Colors.black26, // Sesuaikan warna bayangan
        shadowElevation: 8.0, // Sesuaikan ketebalan bayangan
      ),
    );
  }
}
