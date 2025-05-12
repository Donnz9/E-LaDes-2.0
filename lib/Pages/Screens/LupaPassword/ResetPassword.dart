import 'package:elades20/Pages/Screens/Login/Login.dart';
import 'package:elades20/Pages/Screens/LupaPassword/ResetPassword2.dart';
import 'package:elades20/Pages/Widgets/form_widgets.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
import 'package:elades20/Services/LupaPassword/kirimotp_services.dart';
import 'package:flutter/material.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({super.key});

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

  // Handle OTP sending process
  Future<void> _handleSendOtp() async {
    setState(() => _isLoading = true);

    try {
      String emailOrPhone = emailController.text.trim();

      if (emailOrPhone.isEmpty) {
        Snackbar.show(context, "Email atau No HP tidak boleh kosong", isError: true);
        return;
      }

      final response = await KirimOtpService.sendOtp(emailOrPhone);

      if (response.success) {
        Snackbar.show(context, "OTP telah dikirim. Cek email/no hp kamu");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Resetpassword2(emailOrPhone: emailController.text),
          ),
        );
      } else {
        Snackbar.show(context, response.message, isError: true);
      }
    } catch (e) {
      print('ERROR SEND OTP RESET: $e');
      Snackbar.show(context, "Terjadi kesalahan. Coba lagi nanti.", isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
                        MaterialPageRoute(builder: (context) => const Login()),
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
                'Masukkan Email/No Hp\nUntuk Merubah Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              FormWidgets.buildTextField(
                label: 'Email/No Hp',
                controller: emailController,
              ),
              const SizedBox(height: 30),
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A9E7A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'KIRIM KODE OTP',
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