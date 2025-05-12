// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:elades20/Models/user_model.dart';
// import 'dart:convert';

// class AuthService {
//   static const String _userKey = 'logged_in_user';
//   static const String _isLoggedInKey = 'is_logged_in';

//   // Menyimpan user setelah login
//   static Future<void> saveUser(UserModel user) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_isLoggedInKey, true);
//     await prefs.setString(_userKey, json.encode(user.toJson()));
//   }

//   // Mendapatkan user yang tersimpan
//   static Future<UserModel?> getLoggedInUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    
//     if (!isLoggedIn) return null;

//     final userJson = prefs.getString(_userKey);
//     if (userJson == null) return null;

//     return UserModel.fromJson(json.decode(userJson));
//   }

//   // Logout
//   static Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_isLoggedInKey);
//     await prefs.remove(_userKey);
//   }

//   // Memeriksa status login
//   static Future<bool> isLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(_isLoggedInKey) ?? false;
//   }
// }