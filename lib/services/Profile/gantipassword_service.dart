import 'dart:convert';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elades20/Models/user_model.dart';
import 'package:elades20/Services/Login/user_service.dart';

/// Service for updating user password
Future<bool> update_password(String idUser, String newPassword) async {
  try {
    // Convert Firebase UID to application user ID if needed
    int userId;
    
    // Check if the provided ID is numeric (from UserModel) or a Firebase UID
    if (int.tryParse(idUser) != null) {
      // Already a numeric ID
      userId = int.parse(idUser);
    } else {
      // It's a Firebase UID, need to get the actual user ID
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        print('No Firebase user found');
        return false;
      }

      // Get current user data from service
      UserModel? userModel;
      if (firebaseUser.email != null) {
        userModel = await UserService.getUserByEmail(firebaseUser.email!);
      } else if (firebaseUser.phoneNumber != null) {
        userModel = await UserService.getUserByUid(firebaseUser.uid);
      }

      if (userModel == null) {
        print('Could not find user in database');
        return false;
      }
      
      userId = userModel.id;
    }

    // Send request to API
    final url = Uri.parse("${AppConfig.baseUrl}/profile/update_password.php");
    final response = await http.post(
      url,
      body: {
        'id_user': userId.toString(),
        'password': newPassword,
      },
    );

    // Check response
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // Debug response
      print('Password update response: ${response.body}');
      
      return data['success'] == true;
    } else {
      print('Error: Server responded with status code ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error updating password: $e');
    return false;
  }
}