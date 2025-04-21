import 'dart:convert';
import 'package:elades20/Pages/Screens/Register/Register2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

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
              const SizedBox(height: 30),
              // Email/No HP Field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email atau No Hp',
                  hintText: 'Masukkan Email atau Nomor Hp',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              //nama lengkap
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Masukkan Nama Lengkap',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Semua field harus diisi')),
                      );
                      return;
                    }

                    if (!(isEmail(emailOrPhone) ||
                        isPhoneNumber(emailOrPhone))) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Masukkan email atau no HP yang valid')),
                      );
                      return;
                    }

                    if (password.length < 8) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Password minimal 8 karakter')),
                      );
                      return;
                    }

                    if (password != konfirmasiPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Password dan konfirmasi tidak sama')),
                      );
                      return;
                    }

                    try {
                      final response = await http.post(
                        Uri.parse(
                            'http://192.168.0.3/elades20_api/send_otp.php'),
                        body: {'email_or_phone': emailOrPhone},
                      );

                      final data = jsonDecode(response.body);
                      if (data['success']) {
                        // Simpan kode_otp sementara untuk dibandingin nanti
                        print(
                            'OTP: ${data['kode_otp']}'); // Hapus ini di production
                        // Jika OTP berhasil, lanjutkan ke Register2
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
                        print('Gagal kirim OTP: ${data['error']}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gagal kirim OTP')),
                        );
                      }
                    } catch (e) {
                      print('Error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Tidak dapat menghubungi server')),
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
}

/// Register Screen - register_screen.dart
// import 'package:elades20/Pages/Widgets/custom_textfield.dart';
// import 'package:elades20/Utils/validators.dart';
// import 'package:flutter/material.dart';
// import 'package:elades20/Services/auth_services.dart';
// import 'package:elades20/Pages/Screens/Register/Register2.dart';

// class Register extends StatefulWidget {
//   const Register({super.key});

//   @override
//   State<Register> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<Register> {
//   final emailController = TextEditingController();
//   final namaController = TextEditingController();
//   final passwordController = TextEditingController();
//   final konfirmasiPasswordController = TextEditingController();
//   bool _obscureText = true;

//   void _handleRegister() async {
//     final emailOrPhone = emailController.text.trim();
//     final nama = namaController.text.trim();
//     final password = passwordController.text;
//     final konfirmasiPassword = konfirmasiPasswordController.text;

//     if ([emailOrPhone, nama, password, konfirmasiPassword].any((e) => e.isEmpty)) {
//       _showSnackBar('Semua field harus diisi');
//       return;
//     }

//     if (!isValidEmail(emailOrPhone) && !isValidPhone(emailOrPhone)) {
//       _showSnackBar('Masukkan email atau no HP yang valid');
//       return;
//     }

//     if (password.length < 8) {
//       _showSnackBar('Password minimal 8 karakter');
//       return;
//     }

//     if (password != konfirmasiPassword) {
//       _showSnackBar('Password dan konfirmasi tidak sama');
//       return;
//     }

//     final success = await AuthService.sendOtp(emailOrPhone);
//     if (success) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => Register2(
//             email: emailOrPhone,
//             nama: nama,
//             password: password,
//           ),
//         ),
//       );
//     } else {
//       _showSnackBar('Gagal mengirim OTP');
//     }
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(25),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Image.asset('assets/images/logo.png', width: 200, height: 200),
//               const Text(
//                 'DAFTAR AKUN',
//                 style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Color(0xFF6A6A6A)),
//               ),
//               const SizedBox(height: 30),
//               CustomTextField(controller: emailController, label: 'Email atau No Hp', hint: 'Masukkan Email atau Nomor Hp'),
//               const SizedBox(height: 15),
//               CustomTextField(controller: namaController, label: 'Nama Lengkap', hint: 'Masukkan Nama Lengkap'),
//               const SizedBox(height: 15),
//               CustomTextField(
//                 controller: passwordController,
//                 label: 'Password',
//                 hint: 'Password Minimal 8 Karakter',
//                 obscureText: _obscureText,
//                 toggleVisibility: () => setState(() => _obscureText = !_obscureText),
//               ),
//               const SizedBox(height: 15),
//               CustomTextField(
//                 controller: konfirmasiPasswordController,
//                 label: 'Konfirmasi Password',
//                 hint: 'Masukkan Password Sekali Lagi',
//                 obscureText: _obscureText,
//                 toggleVisibility: () => setState(() => _obscureText = !_obscureText),
//               ),
//               const SizedBox(height: 25),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _handleRegister,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF7A9E7A),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   child: const Text(
//                     'LANJUT',
//                     style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
