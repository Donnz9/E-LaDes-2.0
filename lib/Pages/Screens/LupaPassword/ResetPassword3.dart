import 'package:elades20/Pages/Screens/Login/Login.dart';
import 'package:elades20/Pages/Screens/LupaPassword/ResetPassword.dart';
import 'package:elades20/Pages/Widgets/form_widgets.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
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
  bool _isLoading = false;

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
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF4B9560)),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Resetpassword()),
                      );
                    },
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 50),
              Image.asset(
                'assets/images/LogoApp.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 30),
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
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  FormWidgets.buildTextField(
                    label: 'Password',
                    controller: passwordController,
                    obscureText: _obscureText,
                    isPassword: true,
                  ),
                  Positioned(
                    right: 10,
                    child: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: const Color.fromARGB(255, 88, 88, 88),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),              
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  FormWidgets.buildTextField(
                    label: 'Konfirmasi Password',
                    controller: konfirmasipasswordController,
                    obscureText: _obscureText,
                    isPassword: true,
                  ),
                  Positioned(
                    right: 10,
                    child: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: const Color.fromARGB(255, 88, 88, 88),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              // Lanjut Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:  _isLoading ? null : _ubahPassword,
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
    setState(() => _isLoading = true);

    String password = passwordController.text.trim();
    String konfirmasiPassword = konfirmasipasswordController.text.trim();

    if (password.isEmpty || konfirmasiPassword.isEmpty) {
      Snackbar.show(context, "Password dan Konfirmasi wajib diisi", isError: true);
      setState(() => _isLoading = false);
      return;
    }

    if (password != konfirmasiPassword) {
      Snackbar.show(context, "Password dan Konfirmasi tidak sama", isError: true);
      setState(() => _isLoading = false);
      return;
    }

    if (password.length < 8) {
      Snackbar.show(context, "Password minimal 8 karakter", isError: true);
      setState(() => _isLoading = false);
      return;
    }

    try {
      final response =
          await UbahPasswordService.ubahPassword(widget.emailOrPhone, password);

      if (response['success']) {
        Snackbar.show(context, "Password berhasil diubah");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
        );
      } else {
        Snackbar.show(context, "Gagal mengubah password: ${response['message']}", isError: true);
      }
    } catch (e) {
      print('ERROR ubah password : $e');
      Snackbar.show(context, "Terjadi kesalahan: $e", isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}