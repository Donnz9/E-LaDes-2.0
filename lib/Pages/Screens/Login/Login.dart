import 'package:elades20/Models/user_model.dart';
import 'package:elades20/Pages/Screens/Register/Register.dart';
import 'package:elades20/Pages/Screens/LupaPassword/ResetPassword.dart';
import 'package:elades20/Pages/main_navigation.dart';
import 'package:elades20/Services/Login/login_services.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Resetpassword()),
                    );
                  },
                  child: const Text(
                    'Lupa Password',
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
                    String login =
                        emailController.text.trim(); // bisa email atau no_hp
                    String password = passwordController.text.trim();

                    final result = await LoginService.login(login, password);
                    if (result['success']) {
                      UserModel? user = result['user'];
                      if (user != null) {
                        print("Welcome ${user.nama}");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainNavigation(user: user),
                          ),
                        );
                      } else {
                        // Jika user null, beri pesan bahwa login gagal

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Login gagal: Pengguna tidak ditemukan")),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(result['message'] ?? 'Login failed')),
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
                  onPressed: () async {
                    // Melakukan login dengan Google
                    User? user = await signInWithGoogle();

                    if (user != null) {
                      UserModel userModel = await UserModel.fromFirebaseUser(user);

                      // login berhasil
                      print("Welcome ${userModel.nama}");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainNavigation(user:userModel), // Ganti dengan halaman navigasi utama
                        ),
                      );
                    } else {
                      // login gagal
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login gagal dengan Google')),
                      );
                    }
                  },
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
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()),
                      );
                    }, //diisi halaman register
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      // Memulai proses login Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Jika pengguna memilih akun Google
      if (googleUser == null) {
        return null; // Pengguna membatalkan login
      }

      // Mengambil otentikasi Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Membuat kredensial Firebase dari token yang didapat dari Google
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Menggunakan kredensial untuk sign-in ke Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Mengembalikan user Firebase
      return userCredential.user;
    } catch (e) {
      print("Error during Google sign-in: $e");
      return null;
    }
  }
}
