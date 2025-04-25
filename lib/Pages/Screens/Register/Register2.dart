import 'package:elades20/Pages/Screens/Login/Login.dart';
import 'package:elades20/Services/Register/firebase_auth.dart';
import 'package:elades20/Services/Register/otp_services.dart';
import 'package:elades20/Services/Register/register.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

bool isEmail(String input) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(input);
}

bool isPhoneNumber(String input) {
  return RegExp(r'^08\d{8,12}$').hasMatch(input);
}

class Register2 extends StatefulWidget {
  final String email;
  final String nama;
  final String password;

  const Register2({
    super.key,
    required this.email,
    required this.nama,
    required this.password,
  });

  @override
  State<Register2> createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  final TextEditingController kodeOtpController = TextEditingController();

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
                'DAFTAR AKUN',
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
                  onPressed: () async {
                    final otpResponse = await OtpServices.sendOtp(widget.email);
                    if (otpResponse.success) {
                      print("OTP dikirim: ${otpResponse.message}");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Kode OTP telah dikirim ulang')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal mengirim ulang OTP')),
                      );
                    }
                  },
                  child: const Text(
                    'Kirim Kode OTP Lagi',
                    style: TextStyle(
                      color: Color(0xFF6A6A6A),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // regis Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    // Cek apakah kode OTP kosong
                    if (kodeOtpController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Kode OTP harus diisi')),
                      );
                      return; // Menghentikan proses jika OTP kosong
                    }

                    String email = '';
                    String noHp = '';

                    if (isEmail(widget.email)) {
                      email = widget.email;
                    } else {
                      noHp = widget.email;
                    }

                    final result = await RegisterService.registerWithOtp(
                      email: email,
                      noHp: noHp,
                      nama: widget.nama,
                      password: widget.password,
                      kodeOtp: kodeOtpController.text,
                    );

                    // Jika sukses
                    bool firebaseSuccess = true;
                    if (result.success) {
                      if (isEmail(widget.email)) {
                        try {
                          firebaseSuccess = await registerWithFirebase(widget.email, widget.password);
                          print("Akun terdaftar di Firebase Auth");
                        } catch (e) {
                          print("Firebase Auth Error: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Gagal register ke Firebase: $e')),
                          );
                          return;
                        }
                      }
                      if (!firebaseSuccess) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Akun berhasil dibuat!')),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    } else {
                      // Jika gagal
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal: ${result.message}')),
                      );
                    }
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
