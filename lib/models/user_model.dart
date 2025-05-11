import 'package:elades20/Services/Login/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final int id;
  final String nama;
  final String? email;
  final String? noHp;
  final String? profileImage;
  final String? firebaseUid; // Tambahkan firebaseUid untuk referensi

  UserModel({
    required this.id,
    required this.nama,
    this.email,
    this.noHp,
    this.profileImage,
    this.firebaseUid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.parse(json['id_user'].toString()),
      nama: json['nama'],
      email: json['email'],
      noHp: json['no_hp'],
      profileImage: json['profile_image'],
      firebaseUid: json['firebase_uid'],
    );
  }

  static Future<UserModel?> fromFirebaseUser(User user) async {
    UserModel? userData;

    if (user.email != null) {
      // Login via email
      userData = await UserService.getUserByEmail(user.email!);
    } else {
      // Login via nomor HP
      userData = await UserService.getUserByUid(user.uid);
    }
    
    if (userData == null) {
      return null;
    }
    
    return userData;
  }
  
  static UserModel fromGoogleAccount(User user) {
    return UserModel(
      id: 0, // ID sementara, akan diganti setelah pendaftaran
      nama: user.displayName ?? 'Unknown',
      email: user.email,
      noHp: user.phoneNumber,
      profileImage: user.photoURL,
      firebaseUid: user.uid,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': id,
      'nama': nama,
      'email': email,
      'no_hp': noHp,
      'profile_image': profileImage,
      'firebase_uid': firebaseUid,
    };
  }

  UserModel copyWith({
    int? id,
    String? nama,
    String? email,
    String? noHp,
    String? profileImage,
    String? firebaseUid,
  }) {
    return UserModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      noHp: noHp ?? this.noHp,
      profileImage: profileImage ?? this.profileImage,
      firebaseUid: firebaseUid ?? this.firebaseUid,
    );
  }
}