import 'package:elades20/Models/user_model.dart';
import 'package:elades20/Pages/Screens/Login/Login.dart';
import 'package:elades20/Pages/Screens/Register/Register2.dart';
import 'package:elades20/Pages/Widgets/form_widgets.dart';
import 'package:elades20/Services/Register/otp_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';

class Register extends StatefulWidget {
  final UserModel? googleUser;
  final User? firebaseUser;
  const Register({Key? key, this.googleUser, this.firebaseUser})
      : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController konfirmasipasswordController =
      TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.googleUser != null) {
      namaController.text = widget.googleUser!.nama;
      emailController.text = widget.googleUser!.email ?? '';
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
                    icon:
                        const Icon(Icons.arrow_back, color: Color(0xFF4B9560)),
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
              const SizedBox(height: 30),
              Image.asset(
                'assets/images/LogoApp.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 15),
              const Text(
                'DAFTAR AKUN',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A6A6A),
                ),
              ),
              const SizedBox(height: 30),
              // Email/No HP Field
              FormWidgets.buildTextField(
                label: 'Email/No Hp',
                controller: emailController,
              ),
              //nama lengkap
              FormWidgets.buildTextField(
                label: 'Nama Lengkap',
                controller: namaController,
              ),
              // Password Field
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
              // konfirmasi Password Field
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
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() => _isLoading = true);

                          try {
                            String emailOrPhone = emailController.text.trim();
                            String nama = namaController.text.trim();
                            String password = passwordController.text;
                            String konfirmasiPassword =
                                konfirmasipasswordController.text;

                            bool isEmail(String input) {
                              return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(input);
                            }

                            bool isPhoneNumber(String input) {
                              return RegExp(r'^08\d{8,12}$')
                                  .hasMatch(input); // Indo number
                            }

                            if (emailOrPhone.isEmpty ||
                                nama.isEmpty ||
                                password.isEmpty ||
                                konfirmasiPassword.isEmpty) {
                              Snackbar.show(context, 'Semua field harus diisi', isError: true);
                              return;
                            }

                            if (!(isEmail(emailOrPhone) ||
                                isPhoneNumber(emailOrPhone))) {
                              Snackbar.show(context, 
                                  'Masukkan email atau no HP yang valid', isError: true);
                              return;
                            }

                            if (password.length < 8) {
                              Snackbar.show(context, 'Password minimal 8 karakter', isError: true);
                              return;
                            }

                            if (password != konfirmasiPassword) {
                              Snackbar.show(context, 
                                  'Password dan konfirmasi tidak sama', isError: true);
                              return;
                            }

                            bool confirmed = await _showConfirmationDialog();
                            if (!confirmed) {
                              setState(() => _isLoading = false);
                              return;
                            }

                            final otpResponse =
                                await OtpServices.sendOtp(emailOrPhone);
                            if (otpResponse.success) {
                              print("OTP dikirim: ${otpResponse.message}");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Register2(
                                    email: emailOrPhone,
                                    nama: nama,
                                    password: password,
                                  ),
                                ),
                              );
                            } else {
                              Snackbar.show(context, 'Gagal kirim OTP', isError: true);
                            }
                          } catch (e) {
                            print('Error: $e');
                            Snackbar.show(context, 'Tidak dapat menghubungi server', isError: true);
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

  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi Data'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Email/No HP: ${emailController.text.trim()}'),
                Text('Nama Lengkap: ${namaController.text.trim()}'),
                const SizedBox(height: 10),
                const Text(
                  'Apakah data Anda sudah benar?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Tidak', style: TextStyle(color: Colors.black),),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A9E7A),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Ya, Lanjutkan'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
