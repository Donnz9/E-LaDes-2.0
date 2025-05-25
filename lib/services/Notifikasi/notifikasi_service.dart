import 'dart:convert';
import 'package:elades20/Models/notifikasi/notifikasi_model.dart';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;

class NotifikasiService {
  static final String baseUrl = AppConfig.baseUrl;
  
  static Future<List<NotifikasiModel>> getUnreadNotifications(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notification/unread?username=$username'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => NotifikasiModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading notifications: $e');
      return [];
    }
  }

  static Future<int> getUnreadCount(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notification/count?username=$username'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['count'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error getting notification count: $e');
      return 0;
    }
  }

  static Future<bool> markAsRead(int notificationId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notification/mark-read'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'notif_id': notificationId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }

  // Method tambahan untuk Laravel API
  static Future<bool> markAllAsRead(String username) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notification/mark-all-read'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'username': username}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print('Error marking all notifications as read: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getNotificationStats(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notification/stats?username=$username'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting notification stats: $e');
      return null;
    }
  }
}