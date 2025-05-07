import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/api_response.dart';
import '../models/auth_response.dart';
import '../models/job_model.dart';

class ApiService {
  // Use 10.0.2.2 for Android emulator to connect to host machine's localhost
  static const String baseUrl = 'http://10.0.2.2:3000';
  late final Dio _dio;
  String? _authToken;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
        validateStatus: (status) => status! < 500,
      ),
    );

    // Enhanced logging interceptor with clearer formatting
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint(
            '\n🌐 REQUEST[${options.method}] => PATH: ${options.path}',
          );
          debugPrint('Headers:');
          options.headers.forEach((key, value) {
            debugPrint('$key: $value');
          });
          if (options.queryParameters.isNotEmpty) {
            debugPrint('QueryParameters:');
            options.queryParameters.forEach((key, value) {
              debugPrint('$key: $value');
            });
          }
          if (options.data != null) {
            debugPrint('Body: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint(
            '\n✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          debugPrint('Response: ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          debugPrint(
            '\n❌ ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
          );
          debugPrint('Error Type: ${error.type}');
          debugPrint('Error Message: ${error.message}');
          if (error.response != null) {
            debugPrint('Error Response Data: ${error.response?.data}');
          }
          debugPrint('Stack Trace: ${error.stackTrace}');
          return handler.next(error);
        },
      ),
    );
  }

  // Authentication APIs
  Future<ApiResponse<AuthResponse>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'emailOrPhoneOrUsername': email, 'password': password},
      );
      return ApiResponse.fromJson(
        response.data,
        (json) => AuthResponse.fromJson(json),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'An error occurred during login',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<AuthResponse>> registerUsher(
    Map<String, dynamic> data,
  ) async {
    try {
      debugPrint('Attempting to register usher with data: ${data.toString()}');
      final response = await _dio.post('/auth/register/usher', data: data);
      debugPrint('Registration response: ${response.data}');
      return ApiResponse.fromJson(
        response.data,
        (json) => AuthResponse.fromJson(json),
      );
    } on DioException catch (e) {
      debugPrint('DioException during usher registration: ${e.toString()}');
      debugPrint('Error type: ${e.type}');
      debugPrint('Error response: ${e.response?.data}');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection and try again.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        return ApiResponse.error(
          'Connection error. Please check if the server is running and your internet connection is stable.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Registration failed: ${e.message}',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e, stackTrace) {
      debugPrint('Unexpected error during usher registration: ${e.toString()}');
      debugPrint('Stack trace: ${stackTrace.toString()}');
      return ApiResponse.error(
        'An unexpected error occurred during registration. Please try again later.',
      );
    }
  }

  Future<ApiResponse<AuthResponse>> registerCompany(
    Map<String, dynamic> data,
  ) async {
    try {
      debugPrint(
        'Attempting to register company with data: ${data.toString()}',
      );
      final response = await _dio.post('/auth/register/company', data: data);
      debugPrint('Registration response: ${response.data}');
      return ApiResponse.fromJson(
        response.data,
        (json) => AuthResponse.fromJson(json),
      );
    } on DioException catch (e) {
      debugPrint('DioException during company registration: ${e.toString()}');
      debugPrint('Error type: ${e.type}');
      debugPrint('Error response: ${e.response?.data}');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection and try again.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        return ApiResponse.error(
          'Connection error. Please check if the server is running and your internet connection is stable.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ??
            'Company registration failed: ${e.message}',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e, stackTrace) {
      debugPrint(
        'Unexpected error during company registration: ${e.toString()}',
      );
      debugPrint('Stack trace: ${stackTrace.toString()}');
      return ApiResponse.error(
        'An unexpected error occurred during registration. Please try again later.',
      );
    }
  }

  Future<ApiResponse<AuthResponse>> registerCreator(
    Map<String, dynamic> data,
  ) async {
    try {
      debugPrint(
        'Attempting to register content creator with data: ${data.toString()}',
      );
      final response = await _dio.post(
        '/auth/register/content-creator',
        data: data,
      );
      debugPrint('Registration response: ${response.data}');
      return ApiResponse.fromJson(
        response.data,
        (json) => AuthResponse.fromJson(json),
      );
    } on DioException catch (e) {
      debugPrint(
        'DioException during content creator registration: ${e.toString()}',
      );
      debugPrint('Error type: ${e.type}');
      debugPrint('Error response: ${e.response?.data}');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection and try again.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        return ApiResponse.error(
          'Connection error. Please check if the server is running and your internet connection is stable.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ??
            'Content creator registration failed: ${e.message}',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e, stackTrace) {
      debugPrint(
        'Unexpected error during content creator registration: ${e.toString()}',
      );
      debugPrint('Stack trace: ${stackTrace.toString()}');
      return ApiResponse.error(
        'An unexpected error occurred during registration. Please try again later.',
      );
    }
  }

  Future<ApiResponse<void>> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ??
            'Failed to process password reset request',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<void>> verifyOtp(String email, String otp) async {
    try {
      final response = await _dio.post(
        '/auth/verify-otp',
        data: {'email': email, 'otp': otp},
      );
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'OTP verification failed',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<void>> resetPassword(
    String email,
    String newPassword,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/reset-password',
        data: {'email': email, 'newPassword': newPassword},
      );
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Password reset failed',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<void>> verifyEmail(
    String email,
    String verificationCode,
  ) async {
    try {
      debugPrint(
        'Attempting to verify email with code: $verificationCode for: $email',
      );
      final response = await _dio.post(
        '/auth/verify-email',
        data: {'email': email, 'verificationCode': verificationCode},
      );
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Email verification failed',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      debugPrint('Unexpected error during email verification: $e');
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // Set auth token for authenticated requests
  void setAuthToken(String token) {
    _authToken = token;
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _authToken = null;
    _dio.options.headers.remove('Authorization');
  }

  // Usher APIs
  Future<ApiResponse<Map<String, dynamic>>> getUsherProfile() async {
    try {
      final response = await _dio.get('/usher/profile');
      return ApiResponse.fromJson(
        response.data,
        (json) => json,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Failed to get usher profile',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<void>> updateUsherProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.patch('/usher/profile', data: data);
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Failed to update usher profile',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<void>> completeUsherProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post('/usher/complete-profile', data: data);
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Failed to complete usher profile',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<void>> uploadUsherProfilePicture(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'profilePicture': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.patch(
        '/usher/profile/upload-picture',
        data: formData,
      );
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Failed to upload profile picture',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // Company APIs
  Future<ApiResponse<Map<String, dynamic>>> getCompanyProfile() async {
    try {
      final response = await _dio.get('/company/profile');
      return ApiResponse.fromJson(
        response.data,
        (json) => json,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Failed to get company profile',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<void>> updateCompanyProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.patch('/company/profile', data: data);
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Failed to update company profile',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // Content Creator APIs
  Future<ApiResponse<Map<String, dynamic>>> getContentCreatorProfile() async {
    try {
      final response = await _dio.get('/content-creator/profile');
      return ApiResponse.fromJson(
        response.data,
        (json) => json,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Failed to get content creator profile',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<void>> updateContentCreatorProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.patch('/content-creator/profile', data: data);
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ??
            'Failed to update content creator profile',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<void>> uploadContentCreatorProfilePicture(
    String filePath,
  ) async {
    try {
      final formData = FormData.fromMap({
        'profilePicture': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.patch(
        '/content-creator/profile/upload-picture',
        data: formData,
      );
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Failed to upload profile picture',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // Job APIs
  Future<ApiResponse<Job>> createJob(Job job) async {
    try {
      final response = await _dio.post('/jobs', data: job.toJson());
      return ApiResponse.fromJson(response.data, (json) => Job.fromJson(json));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Failed to create job',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // Get jobs - assuming the API might have this endpoint based on standard RESTful practices
  Future<ApiResponse<List<Job>>> getJobs() async {
    try {
      final response = await _dio.get('/jobs');
      return ApiResponse.fromJson(
        response.data,
        (json) => (json as List).map((item) => Job.fromJson(item)).toList(),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection.',
        );
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Failed to get jobs',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }
}
