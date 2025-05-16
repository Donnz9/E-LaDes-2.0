import 'package:elades20/Pages/Widgets/form_widgets.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
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
  String? profileImageUrl;

  final TextEditingController passwordBaruController = TextEditingController();
  final TextEditingController konfirmasiPasswordBaruController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    // Initialize profileImageUrl from currentUser
    if (currentUser != null) {
      profileImageUrl = currentUser!.profileImage;
      debugPrint('GantiPassword - User profile image: $profileImageUrl');
    }
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
              const SizedBox(height: 40),

              // Show profile image if available
              _buildProfileImage(),
              const SizedBox(height: 32),

              Stack(
                alignment: Alignment.centerRight,
                children: [
                  FormWidgets.buildTextField(
                    label: 'Password Baru',
                    controller: passwordBaruController,
                    obscureText: _obscurePassword,
                    isPassword: true,
                  ),
                  Positioned(
                    right: 10,
                    child: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: const Color.fromARGB(255, 88, 88, 88),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  FormWidgets.buildTextField(
                    label: 'Konfirmasi Password Baru',
                    controller: konfirmasiPasswordBaruController,
                    obscureText: _obscureConfirm,
                    isPassword: true,
                  ),
                  Positioned(
                    right: 10,
                    child: IconButton(
                      icon: Icon(
                        _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                        color: const Color.fromARGB(255, 88, 88, 88),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirm = !_obscureConfirm;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _showConfirmationDialog,
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
      debugPrint('Formatted profile image URL for display: $formattedImageUrl');
      
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
                    debugPrint('Image loading error: $error for URL: $formattedImageUrl');
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

    // Gunakan AppConfig.uploads seperti di Profile.dart
    String formattedUrl = "${AppConfig.uploads}/uploads/foto_profile/$encodedFilename";
    debugPrint('Ganti Password Formatted profile image URL: $formattedUrl');
    return formattedUrl;
  }

  // Menampilkan dialog konfirmasi sebelum mengubah password
  Future<void> _showConfirmationDialog() async {
    // Validate inputs first before showing dialog
    final newPassword = passwordBaruController.text.trim();
    final confirmPassword = konfirmasiPasswordBaruController.text.trim();

    // Validate inputs
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Snackbar.show(context, 'Password tidak boleh kosong', isError: true);
      return;
    }

    if (newPassword != confirmPassword) {
      Snackbar.show(context, 'Password tidak cocok', isError: true);
      return;
    }

    // Show confirmation dialog
    final bool? shouldUpdate = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Konfirmasi Perubahan'),
        content: const Text('Apakah Anda yakin ingin mengubah password?'),
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
              'Simpan',
              style: TextStyle(color: Color(0xFF4B9560)),
            ),
          ),
        ],
      ),
    );

    // Continue with password update if user confirms
    if (shouldUpdate == true) {
      await _updatePassword();
    }
  }

  Future<void> _updatePassword() async {
    final newPassword = passwordBaruController.text.trim();

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
          Snackbar.show(context, 'User tidak ditemukan', isError: true);
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
        Snackbar.show(context, 'Gagal update password di server', isError: true);
        return;
      }

      // Update password in Firebase if user is using email/password auth
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null && 
          firebaseUser.providerData.any((p) => p.providerId == 'password')) {
        await firebaseUser.updatePassword(newPassword);
      }

      Snackbar.show(context, 'Password berhasil diperbarui');
      Navigator.pop(context);
    } catch (e) {
      Snackbar.show(context, 'Terjadi kesalahan: ${e.toString()}', isError: true);
    } finally {
      // Stop loading
      setState(() {
        _isLoading = false;
      });
    }
  }
}