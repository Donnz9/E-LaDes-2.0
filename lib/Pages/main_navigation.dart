import 'package:elades20/Models/user_model.dart';
import 'package:elades20/Pages/Screens/Berita/berita.dart';
import 'package:elades20/Pages/Screens/Dashboard/dashboard.dart';
import 'package:elades20/Pages/Screens/Notifikasi/notifikasi.dart';
import 'package:elades20/Pages/Screens/Pengaduan/pengaduan.dart';
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

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      Pengajuan(onNavigate: _onItemTapped, user: widget.user,),
      const Riwayat(),
      const Pengaduan(),
      Dashboard(onNavigate: _onItemTapped, user: widget.user,),
      const Berita(),
      const Notifikasi(),
      Profile(user: widget.user),
      SuratPengantarSkck(user: widget.user, onNavigate: _onItemTapped),
      SuratPengantarKehilanganBarang(user: widget.user, onNavigate: _onItemTapped),
      SuratKeteranganTidakMampu(user: widget.user, onNavigate: _onItemTapped),
      SuratKeteranganPenghasilanOrangTua(user: widget.user, onNavigate: _onItemTapped),
      SuratIzinTidakMasukKerja(user: widget.user, onNavigate: _onItemTapped),
      SuratIzinKeramaian(user: widget.user, onNavigate: _onItemTapped),
      //nek pengin nambahne tambahne ng ngisore ae, mergo kudu urut index
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              onProfileTap: () => _onItemTapped(6),
              onNotifTap: () => _onItemTapped(5),
              user: widget.user,
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        elevation: 0,
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: NavItem(
                      icon: Icons.file_copy,
                      label: 'Pengajuan',
                      index: 0,
                      selectedIndex: _selectedIndex,
                      onTap: _onItemTapped)),
              Expanded(
                  child: NavItem(
                      icon: Icons.history,
                      label: 'Riwayat',
                      index: 1,
                      selectedIndex: _selectedIndex,
                      onTap: _onItemTapped)),
              const SizedBox(width: 40),
              Expanded(
                  child: NavItem(
                      icon: Icons.report,
                      label: 'Pengaduan',
                      index: 2,
                      selectedIndex: _selectedIndex,
                      onTap: _onItemTapped)),
              Expanded(
                  child: NavItem(
                      icon: Icons.article,
                      label: 'Berita',
                      index: 4,
                      selectedIndex: _selectedIndex,
                      onTap: _onItemTapped)),
            ],
          ),
        ),
      ),
    );
  }
}
