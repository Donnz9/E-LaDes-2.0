import 'package:elades20/Pages/Pengaduan/pengaduan.dart';
import 'package:elades20/Pages/Profil/profile.dart';
import 'package:elades20/Pages/dashboard.dart';
import 'package:elades20/Pages/Pengajuan/pengajuan.dart';
import 'package:flutter/material.dart';
import 'package:elades20/Pages/SplashScreen.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 3;

  final List<Widget> _pages = [
    const Pengajuan(), //0
    const Center(child: Text("Riwayat Surat")), //1
    const Pengaduan(), //2
    const Dashboard(), //3
    const Center(child: Text("Berita")), //4
    const Center(child: Text("Notifikasi")), //5
    const Profile(), //6
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildTopBar(),
            Expanded(child: _pages[_selectedIndex]),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () => _onItemTapped(3),
          backgroundColor: const Color.fromARGB(255, 106, 159, 115),
          shape: const CircleBorder(), // <-- memastikan bentuk bulat
          elevation: 10,
          child: const Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ), // kecilin icon dikit biar proporsional
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          // color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // warna bayangan
              offset: const Offset(0, -2), // bayangan ke atas
              blurRadius: 8, // sebaran bayangan
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          elevation: 0, // matikan elevation bawaan
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // kiri home
                Expanded(
                  child: navItem(
                    icon: Icons.file_copy,
                    label: 'Pengajuan',
                    index: 0,
                  ),
                ),
                Expanded(
                  child: navItem(
                    icon: Icons.history,
                    label: 'Riwayat',
                    index: 1,
                  ),
                ),

                const SizedBox(width: 40), // Space for FAB

                // kanan home
                Expanded(
                  child: navItem(
                    icon: Icons.report,
                    label: 'Pengaduan',
                    index: 2,
                  ),
                ),
                Expanded(
                  child: navItem(
                    icon: Icons.article,
                    label: 'Berita',
                    index: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.grey,
            ),
            const SizedBox(
              height: 1,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Kiri: Profile icon + sapaan
          Row(
            children: [
              GestureDetector(
                onTap: () => _onItemTapped(6), // Index ke-6 = Profil,
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFF7A9E7A),
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hai!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "Doni Hermawan",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Kanan: Notifikasi
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => _onItemTapped(5), // Index ke-5 = Notifikasi
          ),
        ],
      ),
    );
  }
}
