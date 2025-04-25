import 'package:firebase_auth/firebase_auth.dart';

Future<bool> registerWithFirebase(String email, String password) async {
  try {
    // Mendaftarkan user dengan email dan password ke Firebase Authentication
    final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Akun berhasil dibuat di Firebase Authentication, userCredential berisi data user
    print("Akun berhasil dibuat di Firebase Authentication: ${userCredential.user?.email}");
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      print("Email sudah digunakan");
    } else if (e.code == 'invalid-email') {
      print("Format email tidak valid");
    } else if (e.code == 'weak-password') {
      print("Password terlalu lemah");
    } else {
      print("Firebase error: ${e.message}");
    }
    return false;
  } catch (e) {
    print('Terjadi error saat membuat akun: $e');
    return false;
  }
}
