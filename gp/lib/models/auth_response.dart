class AuthResponse {
  static AuthResponse empty() => AuthResponse(success: false);
  final String? token;
  final String? message;
  final bool success;
  final Map<String, dynamic>? user;

  AuthResponse({
    this.token,
    this.message,
    required this.success,
    this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'message': message,
      'success': success,
      'user': user,
    };
  }

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      message: json['message'],
      success: json['success'] ?? false,
      user: json['user'],
    );
  }
}

class ErrorResponse {
  final String message;
  final bool success;

  ErrorResponse({
    required this.message,
    required this.success,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'] ?? 'Unknown error occurred',
      success: json['success'] ?? false,
    );
  }
}
