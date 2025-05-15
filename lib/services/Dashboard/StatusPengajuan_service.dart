import 'dart:convert';
import 'package:elades20/Models/dashboard/dashboard_model.dart';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;

class StatusPengajuanService {
  Future<StatusPengajuan> fetchStatus(String username) async {
    try {
      print("Fetching status for user: $username");
      
      // Default values to return if anything fails
      final defaultStatus = StatusPengajuan(masuk: 0, selesai: 0, tolak: 0);
      
      // Create the request
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/status_pengajuan"),
        body: {'username': username},
      ).timeout(
        const Duration(seconds: 10), // Add timeout to prevent hanging
        onTimeout: () {
          print("Request timed out");
          return http.Response('{"timeout": true}', 408);
        },
      );

      // Log response information
      print("Response status code: ${response.statusCode}");
      print("Response headers: ${response.headers}");
      
      // Handle HTTP 500 server error
      if (response.statusCode == 500) {
        print("Server error (500): The server encountered an internal error");
        return defaultStatus;
      }
      
      // Handle other non-200 status codes
      if (response.statusCode != 200) {
        print("HTTP Error: ${response.statusCode}");
        return defaultStatus;
      }
      
      // Check response body
      print("Response body length: ${response.body.length}");
      if (response.body.isEmpty) {
        print("Empty response received");
        return defaultStatus;
      }
      
      // Print first few characters for debugging
      print("Response preview: ${response.body.substring(0, min(100, response.body.length))}");
      
      // Try to decode JSON
      try {
        final result = jsonDecode(response.body);
        print("Decoded JSON: $result");
        
        // Check if we have valid data
        if (result is Map<String, dynamic> && 
            result['kode'] == true && 
            result.containsKey('data') && 
            result['data'] is List && 
            result['data'].isNotEmpty) {
          return StatusPengajuan.fromJson(result['data'][0]);
        } else {
          print("Invalid JSON structure: $result");
          return defaultStatus;
        }
      } catch (e) {
        print("JSON parsing error: $e");
        
        // Try to clean the response and parse again
        try {
          String cleanedResponse = response.body.trim();
          if (cleanedResponse.isNotEmpty && !cleanedResponse.startsWith('{')) {
            int jsonStart = cleanedResponse.indexOf('{');
            if (jsonStart >= 0) {
              cleanedResponse = cleanedResponse.substring(jsonStart);
              print("Attempting to parse cleaned JSON: ${cleanedResponse.substring(0, min(50, cleanedResponse.length))}...");
              final result = jsonDecode(cleanedResponse);
              
              if (result is Map<String, dynamic> && 
                  result['kode'] == true && 
                  result.containsKey('data') && 
                  result['data'] is List && 
                  result['data'].isNotEmpty) {
                return StatusPengajuan.fromJson(result['data'][0]);
              }
            }
          }
        } catch (e) {
          print("Failed to parse cleaned JSON: $e");
        }
        
        return defaultStatus;
      }
    } catch (e) {
      print("General error in fetchStatus: $e");
      return StatusPengajuan(masuk: 0, selesai: 0, tolak: 0);
    }
  }
}

// Helper function to avoid importing dart:math
int min(int a, int b) => a < b ? a : b;