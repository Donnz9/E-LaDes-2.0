import 'dart:io';
import 'package:elades20/Models/user_model.dart';
import 'package:elades20/Pages/Screens/Profil/ganti_password.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
import 'package:elades20/Services/Profile/logout_service.dart';
import 'package:elades20/Services/Profile/profile_update_service.dart';
import 'package:elades20/Services/config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  final UserModel user;
  final Function(UserModel)
      onProfileUpdated; // Fungsi callback untuk memperbarui state parent

  const Profile({Key? key, required this.user, required this.onProfileUpdated})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController emailController;
  late TextEditingController nameController;
  bool isLoading = false;
  late UserModel currentUser;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? profileImageUrl;
  bool isImageLoading = false;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    emailController = TextEditingController(
        text: currentUser.email ?? currentUser.noHp ?? '');
    nameController = TextEditingController(text: currentUser.nama);
    profileImageUrl = currentUser.profileImage;

    // Debug logs
    debugPrint('User profile image: ${currentUser.profileImage}');
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70, // Kompresi kualitas gambar
        maxWidth: 600, // Batasi lebar gambar
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          debugPrint('Image picked: ${pickedFile.path}');
        });
      }
    } catch (e) {
      Snackbar.show(context, 'Error memilih gambar: ${e.toString()}', isError: true);
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Ambil foto dari kamera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari galeri'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    // Validasi input
    if (nameController.text.trim().isEmpty) {
      Snackbar.show(context, 'Nama tidak boleh kosong', isError: true);
      return;
    }

    if (emailController.text.trim().isEmpty) {
      Snackbar.show(context, 'Email/No HP tidak boleh kosong', isError: true);
      return;
    }

    // Mulai loading
    setState(() {
      isLoading = true;
    });

    try {
      final String newValue = emailController.text.trim();

      // Update profile menggunakan service
      final updatedUser = await ProfileUpdateService.updateProfile(
        context: context,
        user: currentUser,
        newName: nameController.text.trim(),
        newEmailOrPhone: newValue,
        imageFile: _imageFile,
      );

      if (updatedUser != null) {
        // Update local state
        setState(() {
          currentUser = updatedUser;
          // Reset image file since we've uploaded it
          _imageFile = null;
          // Update profile image URL
          profileImageUrl = updatedUser.profileImage;
        });

        // Update parent state melalui callback
        widget.onProfileUpdated(updatedUser);
      }
    } catch (e) {
      Snackbar.show(context, 'Gagal mengupdate profil: ${e.toString()}', isError: true);
    } finally {
      // Hentikan loading
      setState(() {
        isLoading = false;
      });
    }
  }

  String? _getFormattedProfileImageUrl() {
    if (profileImageUrl == null || profileImageUrl!.isEmpty) {
      return null;
    }

    // Ambil nama file terakhir
    String filename = profileImageUrl!.split('/').last;
    String encodedFilename = Uri.encodeComponent(filename);

    // Gunakan baseUrl dan path yang benar
    String formattedUrl =
        "${AppConfig.baseUrl}/profile/foto_profile/$encodedFilename";
    debugPrint('Forced profile image URL: $formattedUrl');
    return formattedUrl;
  }

  @override
  Widget build(BuildContext context) {
    String? formattedImageUrl = _getFormattedProfileImageUrl();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Edit Profil',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B9560),
                ),
              ),
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: _imageFile != null
                          ? Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            )
                          : (formattedImageUrl != null
                              ? FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/placeholder_profil.png',
                                  image: formattedImageUrl,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    debugPrint(
                                        'Error loading profile image: $error for URL: $formattedImageUrl');
                                    // Try to diagnose URI parsing issues
                                    debugPrint(
                                        'URI parsing test: ${Uri.parse(formattedImageUrl)}');
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey,
                                )),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: _showImageSourceOptions,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.photo_camera,
                          size: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email/No HP',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nama',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B9560),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: isLoading
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
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GantiPassword(user: currentUser),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B9560),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Ganti Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Logout.performLogout(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
}
