import 'package:elades20/Pages/Register/Register.dart';
import 'package:elades20/Pages/LupaPassword/ResetPassword.dart';
import 'package:elades20/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
              // const SizedBox(height: 10),
              Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 200,
              ),
              const Text(
                'SELAMAT DATANG',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A6A6A),
                ),
              ),
              const Text(
                'Silahkan Login',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              // Email/No HP Field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email/No Hp',
                  hintText: 'Masukkan Email/Nomor Hp',
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
                  hintText: 'Masukkan Password',
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) => const Resetpassword()
                      ),
                    );
                  },
                  child: const Text('Lupa Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
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
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();

                    try{
                      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      //berhasil login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainNavigation()),
                      );
                    } on FirebaseAuthException catch (e) {
                      String errorMessage = 'Terjadi kesalahan.';
                      if (e.code == 'user-not-found') {
                        errorMessage = 'Email tidak ditemukan.';
                      } else if (e.code == 'wrong-password') {
                        errorMessage = 'Password salah.';
                      }
                      //error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(errorMessage)),
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
                    'LOGIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Google Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () { },  //diisi halaman dashboard
                  icon: Image.asset(
                    'assets/images/google.png',
                    width: 25, 
                    height: 25,
                  ),
                  label: const Text(
                    'Login dengan Akun Google',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      ),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Belum Punya Akun?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => const Register()
                        ),
                      );
                    },//diisi halaman register
                    child: const Text(
                      'Daftar Sekarang',
                      style: TextStyle(
                        color: Color(0xFF6A6A6A),
                        fontSize: 15,
                        ),
                      ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
