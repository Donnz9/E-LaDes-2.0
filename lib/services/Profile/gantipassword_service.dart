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
    int? userId;
    
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
    
    if (userId == null) {
      print('Failed to determine user ID');
      return false;
    }

    // Send request to API
    final url = Uri.parse("${AppConfig.baseUrl}/profile/update_password.php");
    
    // Create request body
    final requestBody = {
      'id_user': userId.toString(),
      'password': newPassword,
    };
    
    print('Sending password update request: $requestBody to $url');
    
    final response = await http.post(
      url,
      body: requestBody,
    );

    // Check response
    print('Server response status: ${response.statusCode}');
    print('Server response body: ${response.body}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      if (data['success'] == true) {
        print('Password updated successfully on server');
        return true;
      } else {
        print('Server returned error: ${data['message']}');
        return false;
      }
    } else {
      print('Error: Server responded with status code ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error updating password: $e');
    return false;
  }
}