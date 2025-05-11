import 'package:elades20/Models/user_model.dart';
import 'package:elades20/Pages/Screens/Register/Register.dart';
import 'package:elades20/Pages/Screens/LupaPassword/ResetPassword.dart';
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
    // Menghapus riwayat Firebase dan Google Sign-In saat halaman Login dimuat
    _clearFirebaseHistory();
  }

  // Method untuk menghapus riwayat Firebase dan memaksa pemilihan akun Google
  Future<void> _clearFirebaseHistory() async {
    try {
      // Sign out dari Firebase Auth jika ada sesi yang aktif
      if (_auth.currentUser != null) {
        await _auth.signOut();
      }
      
      // Sign out dari Google Sign In
      final isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        await _googleSignIn.signOut();
      }
      
      // Disconnect dari Google untuk menghapus semua jejak
      await _googleSignIn.disconnect();
      
      debugPrint("Berhasil menghapus riwayat Firebase dan Google Sign-In");
    } catch (e) {
      debugPrint("Error saat menghapus riwayat Firebase: $e");
    }
  }

  // Show error message
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Show success message
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Regular email/phone login
  Future<void> _handleRegularLogin() async {
    setState(() => _isLoading = true);

    try {
      String login = emailController.text.trim();
      String password = passwordController.text.trim();

      if (login.isEmpty || password.isEmpty) {
        _showErrorMessage("Email/No HP dan password harus diisi");
        return;
      }

      final result = await LoginService.login(login, password);

      if (result['success']) {
        UserModel? user = result['user'];
        if (user != null) {
          _showSuccessMessage("Login berhasil");

          // Navigate to main page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainNavigation(user: user),
            ),
          );
        } else {
          _showErrorMessage("Login gagal: Data pengguna tidak valid");
        }
      } else {
        _showErrorMessage(result['message'] ?? 'Login gagal');
      }
    } catch (e) {
      _showErrorMessage("Error: $e");
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
          _showSuccessMessage("Login berhasil dengan akun Google");

          // Navigate to main page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainNavigation(user: existingUser),
            ),
          );
        }
      } else {
        _showErrorMessage('Login gagal dengan Google');
      }
    } catch (e) {
      _showErrorMessage("Error during Google sign-in: $e");
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

              // Email/No HP Field
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email/No Hp',
                  hintText: 'Masukkan Email/Nomor Hp',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // prefixIcon: Icon(Icons.email),
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
                  // prefixIcon: Icon(Icons.lock),
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
                      ? CircularProgressIndicator(color: Colors.white)
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
