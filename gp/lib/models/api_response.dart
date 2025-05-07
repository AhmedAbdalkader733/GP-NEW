class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final String? errorCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errorCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    // Backend not consistently returning success field - assume success if we got a response with message
    // and no explicit errorCode
    bool isSuccess =
        json.containsKey('success')
            ? json['success'] as bool
            : !json.containsKey('errorCode') || json['errorCode'] == null;

    return ApiResponse(
      success: isSuccess,
      message: json['message'] as String,
      data:
          json['data'] != null && fromJson != null
              ? fromJson(json['data'])
              : null,
      errorCode: json['errorCode'] as String?,
    );
  }

  factory ApiResponse.error(String message, {String? errorCode}) {
    return ApiResponse(success: false, message: message, errorCode: errorCode);
  }
}
