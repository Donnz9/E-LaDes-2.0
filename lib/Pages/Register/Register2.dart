import 'package:elades20/Pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
                    final response = await http.post(
                      Uri.parse('http://192.168.0.3/elades20_api/send_otp.php'),
                      body: {'email_or_phone': widget.email},
                    );
                    final data = jsonDecode(response.body);
                    if (data['success']) {
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
              // Login Button
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
                    String no_hp = '';

                    if (isEmail(widget.email)) {
                      email = widget.email;
                    } else {
                      no_hp = widget.email;
                    }

                    // Kirim data registrasi ke server
                    final respons = await http.post(
                      Uri.parse(
                          'http://192.168.0.3/elades20_api/register.php'), // ganti dengan URL API yang benar
                      body: {
                        'email': email,
                        'no_hp': no_hp,
                        'nama': widget.nama,
                        'password': widget.password,
                        'kode_otp': kodeOtpController.text,
                      },
                    );

                    final result = jsonDecode(respons.body);

                    // Jika sukses, tampilkan SnackBar dan navigasi ke halaman Login
                    if (result['success']) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Akun berhasil dibuat!')),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    } else {
                      // Jika gagal, tampilkan pesan error dari server
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal: ${result['error']}')),
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
