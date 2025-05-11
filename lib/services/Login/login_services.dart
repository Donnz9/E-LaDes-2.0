import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:elades20/Models/user_model.dart';
import 'package:elades20/Services/config.dart';

class LoginService {
  static Future<Map<String, dynamic>> login(
      String login, String password) async {
    try {
      final url = Uri.parse("${AppConfig.baseUrl}/login.php");
      
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "login": login,
          "password": password,
        }),
      );
      
      // Handle HTTP errors
      if (response.statusCode != 200) {
        return {
          'success': false, 
          'message': 'Server error: ${response.statusCode}',
          'user': null
        };
      }

      // Parse response
      final result = jsonDecode(response.body);
      final rawUser = result['user']; 

      if (result['success'] && rawUser != null) {
        try {
          result['user'] = UserModel.fromJson(rawUser);
        } catch (e) {
          print("Error parsing UserModel: $e");
          return {
            'success': false,
            'message': 'Error processing user data',
            'user': null
          };
        }
      } else {
        result['user'] = null;
      }
      return result;
    } catch (e) {
      // Catch network errors
      print("Network or other error: $e");
      return {
        'success': false,
        'message': 'Connection error. Please check your internet connection.',
        'user': null
      };
    }
  }
  
  // Add method for Google login to save user to database if needed
  static Future<Map<String, dynamic>> saveGoogleUser(UserModel user) async {
    try {
      final url = Uri.parse("${AppConfig.baseUrl}/save_google_user.php");
      
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );
      
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result;
      } else {
        return {'success': false, 'message': 'Server error'};
      }
    } catch (e) {
      print("Error saving Google user: $e");
      return {'success': false, 'message': 'Connection error'};
    }
  }
}