import 'package:elades20/Models/user_model.dart';
import 'package:elades20/Services/api_services.dart';

class UserService {
  // Fungsi untuk mengambil data pengguna berdasarkan email
  static Future<UserModel?> getUserByEmail(String email) async {
    try {
      // Ambil data pengguna dari API
      List<dynamic> users = await ApiService.fetchUsers();

      // Cari pengguna berdasarkan email
      for (var userData in users) {
        if (userData['email'] == email) {
          // Jika ditemukan, konversi data ke UserModel
          return UserModel.fromJson(userData);
        }
      }
    } catch (e) {
      print("Error fetching user by email: $e");
    }
    return null; // Jika tidak ditemukan
  }
}
