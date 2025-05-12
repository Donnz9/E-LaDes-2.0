import 'package:elades20/Pages/Screens/Login/Login.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
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
}