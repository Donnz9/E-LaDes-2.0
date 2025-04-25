class RegisterResponse {
  final bool success;
  final String message;

  RegisterResponse({
    required this.success,
    required this.message,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    print('REGISTER RESPONSE: $json'); // <--- Tambahkan ini
    return RegisterResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
