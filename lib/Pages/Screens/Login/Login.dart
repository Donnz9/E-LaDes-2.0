import 'package:elades20/Models/user_model.dart';
import 'package:elades20/Pages/Screens/Register/Register.dart';
import 'package:elades20/Pages/Screens/LupaPassword/ResetPassword.dart';
import 'package:elades20/Pages/Widgets/form_widgets.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
import 'package:elades20/Pages/main_navigation.dart';
import 'package:elades20/Services/Login/login_services.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  bool _isLoading = false;

  // Firebase services
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
  }

  // Regular email/phone login
  Future<void> _handleRegularLogin() async {
    setState(() => _isLoading = true);

    try {
      String login = emailController.text.trim();
      String password = passwordController.text.trim();

      if (login.isEmpty || password.isEmpty) {
        Snackbar.show(context, "Email/No HP dan password harus diisi", isError: true);
        return;
      }

      final result = await LoginService.login(login, password);

      if (result['success']) {
        UserModel? user = result['user'];
        if (user != null) {
          Snackbar.show(context, "Login berhasil");

          // Navigate to main page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainNavigation(user: user),
            ),
          );
        } else {
          Snackbar.show(context, "Login gagal: Data pengguna tidak valid", isError: true);
        }
      } else {
        Snackbar.show(context, result['message'] ?? 'Login gagal', isError: true);
      }
    } catch (e) {
      Snackbar.show(context, "Error: $e", isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Google sign-in
  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      // Start Google sign-in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If user cancels
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Cek apakah pengguna ada di database kita
        final UserModel? existingUser =
            await UserModel.fromFirebaseUser(firebaseUser);

        if (existingUser == null) {
          // Pengguna tidak ditemukan di database kita, buat model sementara untuk dibawa ke halaman Register
          final UserModel tempUserModel =
              UserModel.fromGoogleAccount(firebaseUser);

          // Arahkan ke halaman register
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Register(
                googleUser: tempUserModel,
                firebaseUser:
                    firebaseUser, // Mengirim data firebaseUser untuk referensi
              ),
            ),
          );
        } else {
          // Pengguna sudah terdaftar, lanjutkan proses login
          await LoginService.saveGoogleUser(existingUser);
          Snackbar.show(context, "Login berhasil dengan akun Google");

          // Navigate to main page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainNavigation(user: existingUser),
            ),
          );
        }
      } else {
        Snackbar.show(context, 'Login gagal dengan Google', isError: true);
      }
    } catch (e) {
      Snackbar.show(context, "Error during Google sign-in: $e", isError: true);
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
              const SizedBox(height: 30),
              Image.asset(
                'assets/images/LogoApp.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 30),
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

              // Email/No HP Field using FormWidgets
              FormWidgets.buildTextField(
                label: 'Email/No Hp',
                controller: emailController,
              ),
              const SizedBox(height: 15),

              // Custom Password Field 
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

              // Lupa Password
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
                  onPressed: _isLoading ? null : _handleRegularLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A9E7A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
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
                  onPressed: _isLoading ? null : _handleGoogleSignIn,
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

              // Register Link
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
                    },
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