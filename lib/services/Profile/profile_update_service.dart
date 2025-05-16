import 'dart:convert';
import 'dart:io';
import 'package:elades20/Models/user_model.dart';
import 'package:elades20/Services/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileUpdateService {
  static Future<UserModel?> updateProfile({
    required BuildContext context,
    required UserModel user,
    required String newName,
    required String newEmailOrPhone,
    File? imageFile,
  }) async {
    try {
      // Tentukan apakah input adalah email atau nomor HP
      bool isEmail = newEmailOrPhone.contains('@');

      // 1. Upload gambar jika ada
      String? profileImageUrl = user.profileImage;
      if (imageFile != null) {
        final imageUploadResult = await _uploadProfileImage(
          userId: user.id.toString(),
          imageFile: imageFile,
        );

        if (imageUploadResult != null) {
          profileImageUrl = imageUploadResult;
        } else {
          // Jika upload gambar gagal, tetap lanjutkan update profil lainnya
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Gagal mengupload gambar profil, tetapi akan melanjutkan update data lainnya'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }

      // Buat UserModel yang sudah diupdate
      UserModel updatedUser = UserModel(
        id: user.id,
        nama: newName,
        email: isEmail ? newEmailOrPhone : user.email,
        noHp: !isEmail ? newEmailOrPhone : user.noHp,
        profileImage: profileImageUrl,
        // Salin nilai lain dari user yang tidak diubah
      );

      // 2. Update di database MySQL
      final dbUpdateSuccess = await _updateProfileInDatabase(
        userId: user.id.toString(),
        name: newName,
        email: isEmail ? newEmailOrPhone : user.email,
        phone: !isEmail ? newEmailOrPhone : user.noHp,
        profileImage: profileImageUrl,
      );

      if (!dbUpdateSuccess) {
        throw Exception('Gagal mengupdate database');
      }

      // 3. Update di Firebase jika diperlukan
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? currentUser = auth.currentUser;

      if (currentUser != null) {
        // Update display name
        await currentUser.updateDisplayName(newName);

        // Update email jika ada perubahan dan input adalah email
        if (isEmail && currentUser.email != newEmailOrPhone) {
          try {
            // Solusi sementara: Coba update email tanpa re-authentication
            // Ini akan berhasil jika user baru login (token masih fresh)
            await currentUser.updateEmail(newEmailOrPhone);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Email berhasil diperbarui di Firebase'),
                backgroundColor: Color(0xFF4B9560),
              ),
            );
          } catch (firebaseError) {
            if (firebaseError is FirebaseAuthException) {
              if (firebaseError.code == 'requires-recent-login') {
                // Jika perlu re-authentication, informasikan user
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Perubahan email di Firebase memerlukan login ulang. '
                      'Email telah disimpan di database, silakan logout dan login kembali '
                      'untuk memperbarui email di Firebase.',
                    ),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 5),
                  ),
                );
              } else {
                // Error lainnya
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Firebase error: ${firebaseError.message}'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Firebase error: ${firebaseError.toString()}'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          }
        }
      }
      return updatedUser;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> _uploadProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    try {
      // URL untuk API upload gambar
      final url = Uri.parse("${AppConfig.baseUrl}/upload_profile_image");

      // Buat request multipart untuk upload file
      var request = http.MultipartRequest('POST', url);

      // Tambahkan field-field yang diperlukan
      request.fields['id_user'] = userId;

      // Get file extension
      String fileName = imageFile.path.split('/').last;
      String extension = fileName.split('.').last.toLowerCase();

      // Ensure extension is valid
      if (extension != 'jpg' && extension != 'jpeg' && extension != 'png') {
        print('Invalid file extension: $extension');
        return null;
      }

      // Tambahkan file gambar
      var fileStream = http.ByteStream(imageFile.openRead());
      var fileLength = await imageFile.length();

      print('Uploading image with extension: $extension');
      print('File size: $fileLength bytes');

      var multipartFile = http.MultipartFile(
        'profile_image', // nama field untuk file di server
        fileStream,
        fileLength,
        filename:
            'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}.$extension',
      );

      request.files.add(multipartFile);

      // Log request for debugging
      print('Sending request to: ${url.toString()}');

      // Kirim request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Upload response status code: ${response.statusCode}');
      print('Upload response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final result = jsonDecode(response.body);

          if (result['status'] == 'success') {
            // Kembalikan URL gambar yang baru
            return result['image_url'];
          } else {
            print('Upload image failed: ${result['message']}');
            return null;
          }
        } catch (e) {
          print('Error parsing response: $e');
          return null;
        }
      } else {
        print('Upload image failed: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  static Future<bool> _updateProfileInDatabase({
    required String userId,
    required String name,
    String? email,
    String? phone,
    String? profileImage,
  }) async {
    // Sesuaikan path URL ke API update profile
    final url = Uri.parse("${AppConfig.baseUrl}/update_profile");

    final Map<String, String> requestBody = {
      'id_user': userId,
      'nama': name,
    };

    // Tambahkan email atau no_hp ke request body jika ada
    if (email != null) {
      requestBody['email'] = email;
    }

    if (phone != null) {
      requestBody['no_hp'] = phone;
    }

    // Tambahkan profile_image ke request body jika ada
    if (profileImage != null) {
      requestBody['profile_image'] = profileImage;
    }

    final response = await http.post(
      url,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print('Update profile response: ${response.body}');
      return result['status'] == 'success';
    } else {
      print('Update profile failed: ${response.statusCode} ${response.body}');
      return false;
    }
  }
}
