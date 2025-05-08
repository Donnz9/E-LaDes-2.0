import 'package:elades20/Services/Login/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final int id;
  final String nama;
  final String? email;

  UserModel({
    required this.id,
    required this.nama,
    this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.parse(json['id_user'].toString()),
      nama: json['nama'],
      email: json['email'],
    );
  }

  static Future<UserModel> fromFirebaseUser(User user) async {
    if (user.email != null) {
<<<<<<< Updated upstream
      // Jika user.email tidak null, ambil data dari database
      final userData = await UserService.getUserByEmail(user.email!);
=======
      // Login via email
      userData = (await UserService.getUserByEmail(user.email!)) as UserModel?;
    } else {
      // Login via nomor HP
      userData = (await UserService.getUserByUid(user.uid)) as UserModel?;
    }
    return userData ??
        UserModel(
          id: int.tryParse(user.uid.substring(0, 9)) ?? 0, // Better id handling
          nama: user.displayName ?? 'Unknown',
          email: user.email,
          noHp: user.phoneNumber,
          profileImage: user.photoURL,
        );
  }
  Map<String, dynamic> toJson() {
    return {
      'id_user': id,
      'nama': nama,
      'email': email,
      'no_hp': noHp,
      'profile_image': profileImage,
    };
  }
>>>>>>> Stashed changes

      // Jika data ditemukan, gunakan nama dan ID dari database, jika tidak gunakan displayName
      return UserModel(
        id: userData?.id ?? int.tryParse(user.uid) ?? 0, // Ambil ID dari database, jika tidak ada gunakan UID dari Firebase
        nama: userData?.nama ?? user.displayName ?? 'Unknown', // Ambil nama dari database, jika tidak ada gunakan displayName
        email: user.email, // Email tetap nullable
      );
    } else {
      // Jika email null, langsung buat UserModel tanpa data dari database
      return UserModel(
        id: int.tryParse(user.uid) ?? 0, // Gunakan UID dari Firebase untuk ID
        nama: user.displayName ?? 'Unknown', // Gunakan displayName atau 'Unknown'
        email: null, // Tidak ada email jika tidak tersedia
      );
    }
  }
}
