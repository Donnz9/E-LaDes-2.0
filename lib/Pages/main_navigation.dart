import 'package:elades20/Pages/Screens/Dashboard/dashboard.dart';
import 'package:elades20/Pages/Screens/Pengaduan/pengaduan.dart';
import 'package:elades20/Pages/Screens/Pengajuan/pengajuan.dart';
import 'package:elades20/Pages/Screens/Profil/profile.dart';
import 'package:elades20/Pages/Widgets/nav_item.dart';
import 'package:elades20/Pages/Widgets/top_bar.dart';
import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 3;

  final List<Widget> _pages = [
    const Pengajuan(),
    const Center(child: Text("Riwayat Surat")),
    const Pengaduan(),
    const Dashboard(),
    const Center(child: Text("Berita")),
    const Center(child: Text("Notifikasi")),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
                onProfileTap: () => _onItemTapped(6),
                onNotifTap: () => _onItemTapped(5)),
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
