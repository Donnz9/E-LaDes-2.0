import 'package:elades20/Pages/Screens/LupaPassword/ResetPassword.dart';
import 'package:elades20/Pages/Widgets/form_widgets.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
import 'package:elades20/Services/LupaPassword/kirimotp_services.dart';
import 'package:flutter/material.dart';
import 'package:elades20/Pages/Screens/LupaPassword/ResetPassword3.dart';

class Resetpassword2 extends StatefulWidget {
  final String emailOrPhone;
  const Resetpassword2({super.key, required this.emailOrPhone});

  @override
  State<Resetpassword2> createState() => _Resetpassword2State();
}

class _Resetpassword2State extends State<Resetpassword2> {
  final TextEditingController kodeOtpController = TextEditingController();
  bool _isLoading = false;

  void _kirimUlangOtp() async {
    setState(() => _isLoading = true);

    try {
      final response = await KirimOtpService.sendOtp(widget.emailOrPhone);
      if (response.success) {
        Snackbar.show(context, "Kode OTP berhasil dikirim ulang");
      } else {
        Snackbar.show(context, "Gagal kirim OTP: ${response.message}", isError: true);
      }
    } catch (e) {
      Snackbar.show(context, "Terjadi kesalahan: $e", isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifikasiKodeOtp() async {
    final otp = kodeOtpController.text.trim();

    if (otp.isEmpty) {
      Snackbar.show(context, "Kode OTP tidak boleh kosong", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await KirimOtpService.verifikasiOtp(widget.emailOrPhone, otp);

      if (response.success) {
        Snackbar.show(context, "OTP berhasil diverifikasi");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResestPassword3(emailOrPhone: widget.emailOrPhone),
          ),
        );
      } else {
        Snackbar.show(context, "Verifikasi gagal: ${response.message}", isError: true);
      }
    } catch (e) {
      print('ERROR verifikasi kode: $e');
      Snackbar.show(context, "Terjadi kesalahan: $e", isError: true);
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
              FormWidgets.buildTextField(
                label: 'Kode OTP',
                controller: kodeOtpController,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: _isLoading ? null : _kirimUlangOtp,
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
              // Verifikasi Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifikasiKodeOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A9E7A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
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