import 'package:elades20/Services/Profile/gantipassword_service.dart';
import 'package:elades20/Models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:elades20/Services/config.dart';

class GantiPassword extends StatefulWidget {
  final UserModel? user; // Make user optional but preferred

  const GantiPassword({super.key, this.user});

  @override
  State<GantiPassword> createState() => _GantiPasswordState();
}

class _GantiPasswordState extends State<GantiPassword> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  late UserModel? currentUser;

  final TextEditingController passwordBaruController = TextEditingController();
  final TextEditingController konfirmasiPasswordBaruController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Tombol kembali
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF4B9560)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Ganti Password",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B9560),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 24),
              // Show profile image if available
              _buildProfileImage(),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password Baru',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordBaruController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Masukkan Password Baru',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Konfirmasi Password Baru',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: konfirmasiPasswordBaruController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  hintText: 'Masukkan Konfirmasi Password Baru',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updatePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B9560),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading 
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProfileImage() {
    // If we have a user with a profile image
    if (currentUser != null && currentUser!.profileImage != null && currentUser!.profileImage!.isNotEmpty) {
      String? formattedImageUrl = _getFormattedProfileImageUrl();
      
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey,
        child: ClipOval(
          child: formattedImageUrl != null
              ? FadeInImage.assetNetwork(
                  placeholder: 'assets/images/placeholder_profil.png',
                  image: formattedImageUrl,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person, size: 50, color: Colors.white);
                  },
                )
              : const Icon(Icons.person, size: 50, color: Colors.white),
        ),
      );
    }
    
    // Default avatar
    return const CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey,
      child: Icon(Icons.person, size: 50, color: Colors.white),
    );
  }
  
  String? _getFormattedProfileImageUrl() {
    if (currentUser?.profileImage == null || currentUser!.profileImage!.isEmpty) {
      return null;
    }

    // Ambil nama file terakhir
    String filename = currentUser!.profileImage!.split('/').last;
    String encodedFilename = Uri.encodeComponent(filename);

    // Gunakan baseUrl dari AppConfig
    String formattedUrl =
        "${AppConfig.baseUrl}/profile/foto_profile/$encodedFilename";
    return formattedUrl;
  }

  Future<void> _updatePassword() async {
    final newPassword = passwordBaruController.text.trim();
    final confirmPassword = konfirmasiPasswordBaruController.text.trim();

    // Validate inputs
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Password tidak boleh kosong');
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage('Password tidak cocok');
      return;
    }

    // Start loading
    setState(() {
      _isLoading = true;
    });

    try {
      String userId;
      
      // Use the user ID from UserModel if available
      if (currentUser != null) {
        userId = currentUser!.id.toString();
      } else {
        // Fallback to Firebase user
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          _showMessage('User tidak ditemukan');
          setState(() {
            _isLoading = false;
          });
          return;
        }
        userId = user.uid;
      }

      // Use the user's ID to update password in our database
      final success = await update_password(userId, newPassword);
      
      if (!success) {
        _showMessage('Gagal update password di server');
        return;
      }

      // Update password in Firebase if user is using email/password auth
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null && 
          firebaseUser.providerData.any((p) => p.providerId == 'password')) {
        await firebaseUser.updatePassword(newPassword);
      }

      _showMessage('Password berhasil diperbarui');
      Navigator.pop(context);
    } catch (e) {
      _showMessage('Terjadi kesalahan: ${e.toString()}');
    } finally {
      // Stop loading
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}