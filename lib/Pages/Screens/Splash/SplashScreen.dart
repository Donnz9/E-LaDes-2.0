import 'package:elades20/Models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:elades20/Pages/Screens/Login/Login.dart';
import 'package:elades20/Pages/main_navigation.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Delay untuk menampilkan splash screen
    await Future.delayed(const Duration(seconds: 3));

    try {
      // Periksa apakah user sudah login di Firebase
      final currentUser = FirebaseAuth.instance.currentUser;
      
      if (currentUser != null) {
        // Jika sudah login di Firebase, coba ambil data dari database
        // Import UserModel dan gunakan fromFirebaseUser
        final user = await UserModel.fromFirebaseUser(currentUser);
        
        if (user != null) {
          // Navigasi ke halaman utama dengan data user
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainNavigation(user: user)),
          );
          return;
        }
      }
      
      // Jika tidak ada user atau data tidak valid, arahkan ke login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } catch (e) {
      debugPrint("Error saat check login: $e");
      // Jika terjadi error, arahkan ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),

              // Bagian Utama (Logo dan Teks)
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/logo_nama.png',
                      width: size.width * 0.7, // Lebih fleksibel
                      height: size.height * 0.25,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'LAYANAN PENGAJUAN SURAT\nKELURAHAN KAUMAN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Color(0xFF6A6A6A),
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),

              // Bagian Versi di Bawah
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.02),
                child: const Text(
                  'VERSI 2.0',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Color(0xFF1E2021),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
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