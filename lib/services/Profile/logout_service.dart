import 'package:elades20/Pages/Screens/Login/Login.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Logout {
  static Future<void> performLogout(BuildContext context) async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Logout',
              style: TextStyle(color: const Color.fromARGB(255, 193, 13, 0)),
            ),
          ),
        ],
      ),
    );

    // Proses logout jika user mengkonfirmasi
    if (shouldLogout == true) {
      _showLoadingDialog(context);

      try {
        await FirebaseAuth.instance.signOut();
        _clearFirebaseHistory();

        Navigator.of(context).pop();

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false,
        );

        Snackbar.show(context, 'Logout berhasil', isError: false);
      } catch (e) {
        // Log error untuk debugging
        debugPrint("Logout error: $e");

        // Tutup dialog loading
        Navigator.of(context).pop();

        // Tampilkan notifikasi error
        Snackbar.show(context, 'Gagal logout. Coba lagi.', isError: true);
      }
    }
  }

  static void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Memproses logout..."),
            ],
          ),
        );
      },
    );
  }

  static void _clearFirebaseHistory() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
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
}
