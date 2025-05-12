import 'package:elades20/Pages/Screens/Login/Login.dart';
import 'package:elades20/Pages/Screens/Register/Register.dart';
import 'package:elades20/Pages/Widgets/form_widgets.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
import 'package:elades20/Services/Register/firebase_auth.dart';
import 'package:elades20/Services/Register/otp_services.dart';
import 'package:elades20/Services/Register/register_service.dart';
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
                    icon:
                        const Icon(Icons.arrow_back, color: Color(0xFF4B9560)),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()),
                      );
                    },
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 30),
              Image.asset(
                'assets/images/LogoApp.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 30),
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
              FormWidgets.buildTextField(
                label: 'Kode OTP',
                controller: kodeOtpController,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() => _isLoading = true);
                          try {
                            final otpResponse =
                                await OtpServices.sendOtp(widget.email);
                            if (otpResponse.success) {
                              print("OTP dikirim: ${otpResponse.message}");
                              Snackbar.show(context, 
                                  'Kode OTP telah dikirim ulang');
                            } else {
                              Snackbar.show(context, 'Gagal mengirim ulang OTP', isError: true);
                            }
                          } catch (e) {
                            Snackbar.show(context, 
                                'Terjadi kesalahan saat mengirim OTP', isError: true);
                          } finally {
                            setState(() => _isLoading = false);
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
                  onPressed: _isLoading
                      ? null
                      : () async {
                          // Cek apakah kode OTP kosong
                          if (kodeOtpController.text.trim().isEmpty) {
                            Snackbar.show(context, 'Kode OTP harus diisi', isError: true);
                            return; // Menghentikan proses jika OTP kosong
                          }

                          setState(() => _isLoading = true);

                          try {
                            String email = '';
                            String noHp = '';

                            if (isEmail(widget.email)) {
                              email = widget.email;
                            } else {
                              noHp = widget.email;
                            }

                            final result =
                                await RegisterService.registerWithOtp(
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
                                  firebaseSuccess = await registerWithFirebase(
                                      widget.email, widget.password);
                                  Snackbar.show(context, 'Akun berhasil dibuat!');
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()),
                                  );
                                  print("Akun terdaftar di Firebase Auth");
                                  
                                } catch (e) {
                                  print("Firebase Auth Error: $e");
                                  Snackbar.show(context, 
                                      'Gagal register ke Firebase: $e', isError: true);
                                  return;
                                }
                              }
                              if (!firebaseSuccess) return;

                              Snackbar.show(context, 'Akun berhasil dibuat!');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                              );
                            } else {
                              // Jika gagal
                              Snackbar.show(context, 'Gagal: ${result.message}', isError: true);
                            }
                          } catch (e) {
                            Snackbar.show(context, 'Terjadi kesalahan: $e', isError: true);
                          } finally {
                            setState(() => _isLoading = false);
                          }
                        },
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
