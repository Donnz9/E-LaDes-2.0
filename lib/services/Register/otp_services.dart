import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:elades20/Models/otp_response_model.dart';
import 'package:elades20/Services/config.dart';
import 'package:http/http.dart' as http;

class OtpServices {
  static Future<OtpResponse> sendOtp(String emailOrPhone) async {
    try {
      // Print debug information
      final url = Uri.parse("${AppConfig.baseUrl}/send_otp");
      print("Sending OTP request to: $url");
      print("With data: {'email_or_phone': $emailOrPhone}");

      // Send request with timeout
      final response = await http.post(
        url,
        body: {'email_or_phone': emailOrPhone},
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          print("Connection timeout after 15 seconds");
          throw TimeoutException("Request timeout");
        },
      );

      // Log response
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Check for HTTP errors
      if (response.statusCode != 200) {
        throw HttpException("Server returned ${response.statusCode}: ${response.body}");
      }

      // Parse response
      try {
        final data = jsonDecode(response.body);
        return OtpResponse.fromJson(data);
      } catch (e) {
        print("JSON parsing error: $e");
        print("Raw response: ${response.body}");
        throw FormatException("Invalid response format: $e");
      }
    } on SocketException catch (e) {
      // Network connectivity issues
      print("Network error: $e");
      throw Exception("Tidak dapat terhubung ke server. Periksa koneksi internet Anda.");
    } on TimeoutException catch (e) {
      // Request timeout
      print("Timeout error: $e");
      throw Exception("Server tidak merespon. Coba lagi nanti.");
    } on FormatException catch (e) {
      // JSON parsing error
      print("Format error: $e");
      throw Exception("Format respon server tidak valid.");
    } on HttpException catch (e) {
      // HTTP status error
      print("HTTP error: $e");
      throw Exception("Terjadi kesalahan pada server.");
    } catch (e) {
      // Other unknown errors
      print("Unknown error in OTP service: $e");
      throw Exception("Tidak dapat menghubungi server: $e");
    }
  }
}