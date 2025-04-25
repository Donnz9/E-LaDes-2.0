class OtpResponse {
  final bool success;
  final String message;
  final String? otpId; // opsional, kalau server kirim otp_id

  OtpResponse({
    required this.success,
    required this.message,
    this.otpId,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      otpId: json['otp_id'], // bisa null
    );
  }
}
