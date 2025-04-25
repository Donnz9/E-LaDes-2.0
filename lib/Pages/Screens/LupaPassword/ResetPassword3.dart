import 'package:elades20/Pages/Screens/Login/Login.dart';
import 'package:elades20/Services/LupaPassword/GantiPassword_Services.dart';
import 'package:flutter/material.dart';

class ResestPassword3 extends StatefulWidget {
  final String emailOrPhone;
  const ResestPassword3({super.key, required this.emailOrPhone});

  @override
  State<ResestPassword3> createState() => _ResestPassword3State();
}

class _ResestPassword3State extends State<ResestPassword3> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController konfirmasipasswordController =
      TextEditingController();
  bool _obscureText = true;

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
              const SizedBox(height: 15),
              // Password Field
              TextField(
                controller: passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Password Minimal 8 Karakter',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // konfifrmasiPassword Field
              TextField(
                controller: konfirmasipasswordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                  hintText: 'Masukkan Password Sekali Lagi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Lanjut Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _ubahPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A9E7A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'LANJUT',
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

  Future<void> _ubahPassword() async {
    String password = passwordController.text.trim();
    String konfirmasiPassword = konfirmasipasswordController.text.trim();

    if (password.isEmpty || konfirmasiPassword.isEmpty) {
      _showSnackBar("Password dan Konfirmasi wajib diisi");
      return;
    }

    if (password != konfirmasiPassword) {
      _showSnackBar("Password dan Konfirmasi tidak sama");
      return;
    }

    if (password.length < 8) {
      _showSnackBar("Password minimal 8 karakter");
      return;
    }

    try {
      final response =
          await UbahPasswordService.ubahPassword(widget.emailOrPhone, password);

      if (response['success']) {
        _showSnackBar("Password berhasil diubah");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
        );
      } else {
        _showSnackBar("Gagal mengubah password: ${response['message']}");
      }
    } catch (e) {
      print('ERROR ubah password : $e');
      _showSnackBar("Terjadi kesalahan: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
