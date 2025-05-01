import 'package:elades20/Services/Login/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final int id;
  final String nama;
  final String? email;
  final String? noHp;

  UserModel({
    required this.id,
    required this.nama,
    this.email,
    this.noHp,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.parse(json['id_user'].toString()),
      nama: json['nama'],
      email: json['email'],
      noHp: json['no_hp'],
    );
  }

  static Future<UserModel> fromFirebaseUser(User user) async {
    // if (user.email != null) {
    //   // Jika user.email tidak null, ambil data dari database
    //   final userData = await UserService.getUserByEmail(user.email!);

    //   // Jika data ditemukan, gunakan nama dan ID dari database, jika tidak gunakan displayName
    //   return UserModel(
    //     id: userData?.id ?? int.tryParse(user.uid) ?? 0, // Ambil ID dari database, jika tidak ada gunakan UID dari Firebase
    //     nama: userData?.nama ?? user.displayName ?? 'Unknown', // Ambil nama dari database, jika tidak ada gunakan displayName
    //     email: user.email, // Email tetap nullable
    //   );
    // } else {
    //   // Jika email null, langsung buat UserModel tanpa data dari database
    //   return UserModel(
    //     id: int.tryParse(user.uid) ?? 0, // Gunakan UID dari Firebase untuk ID
    //     nama: user.displayName ?? 'Unknown', // Gunakan displayName atau 'Unknown'
    //     email: null, // Tidak ada email jika tidak tersedia
    //   );
    // }

    UserModel? userData;

  if (user.email != null) {
    // Login via email
    userData = await UserService.getUserByEmail(user.email!);
  } else {
    // Login via nomor HP
    userData = await UserService.getUserByUid(user.uid);
  }

  return UserModel(
    id: userData?.id ?? int.tryParse(user.uid) ?? 0,
    nama: userData?.nama ?? user.displayName ?? 'Unknown',
    email: userData?.email,
    noHp: userData?.noHp,
  );
  }
}
