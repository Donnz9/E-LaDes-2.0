import 'package:flutter/material.dart';
import 'package:elades20/Pages/Screens/LupaPassword/ResetPassword3.dart';

class Resetpassword2 extends StatefulWidget {
  const Resetpassword2({super.key});

  @override
  State<Resetpassword2> createState() => _Resetpassword2State();
}

class _Resetpassword2State extends State<Resetpassword2> {
  final TextEditingController kodeOtpController = TextEditingController();
  // bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 200,
              ),
              const Text(
                'RESET PASSWORD',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A6A6A),
                ),
              ),
              const Text(
                'Silahkan Periksa Email/WhatsApp\nUntuk Memasukkan Kode OTP',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Email/No HP Field
              TextField(
                controller: kodeOtpController,
                decoration: InputDecoration(
                  labelText: 'Kode OTP',
                  hintText: 'Masukkan Kode OTP',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Kirim Kode OTP Lagi',
                  style: TextStyle(
                    color: Color(0xFF6A6A6A),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) => const ResestPassword3()
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A9E7A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'VERIFIKASI KODE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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