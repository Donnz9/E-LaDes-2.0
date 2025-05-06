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
