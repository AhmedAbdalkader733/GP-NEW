import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/api_response.dart';
import '../models/auth_response.dart';

class ApiService {
  // Use 10.0.2.2 for Android emulator to connect to host machine's localhost
  static const String baseUrl = 'http://10.0.2.2:3000';
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      contentType: 'application/json',
      validateStatus: (status) => status! < 500,
    ));

    // Add logging interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint('🌐 REQUEST[${options.method}] => PATH: ${options.path}');
        debugPrint('Headers:');
        options.headers.forEach((key, value) {
          debugPrint('$key: $value');
        });
        debugPrint('QueryParameters:');
        options.queryParameters.forEach((key, value) {
          debugPrint('$key: $value');
        });
        debugPrint('Body: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint(
          '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
        );
        debugPrint('Response: ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        debugPrint(
          '❌ ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
        );
        debugPrint('Error: ${error.response?.data}');
        debugPrint('Stack Trace: ${error.stackTrace}');
        return handler.next(error);
      },
    ));
  }

  // Authentication APIs
  Future<ApiResponse<AuthResponse>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return ApiResponse.fromJson(
        response.data,
        (json) => AuthResponse.fromJson(json),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error('Connection timeout. Please check your internet connection.');
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'An error occurred during login',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<AuthResponse>> registerUsher(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/auth/register/usher', data: data);
      return ApiResponse.fromJson(
        response.data,
        (json) => AuthResponse.fromJson(json),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error('Connection timeout. Please check your internet connection.');
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Registration failed',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred during registration');
    }
  }

  Future<ApiResponse<AuthResponse>> registerCompany(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/auth/register/company', data: data);
      return ApiResponse.fromJson(
        response.data,
        (json) => AuthResponse.fromJson(json),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error('Connection timeout. Please check your internet connection.');
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Company registration failed',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred during registration');
    }
  }

  Future<ApiResponse<AuthResponse>> registerCreator(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/auth/register/content-creator', data: data);
      return ApiResponse.fromJson(
        response.data,
        (json) => AuthResponse.fromJson(json),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error('Connection timeout. Please check your internet connection.');
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Content creator registration failed',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred during registration');
    }
  }

  Future<ApiResponse<void>> forgotPassword(String email) async {
    try {
      final response = await _dio.post('/auth/forgot-password', data: {
        'email': email,
      });
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error('Connection timeout. Please check your internet connection.');
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Failed to process password reset request',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<void>> verifyOtp(String email, String otp) async {
    try {
      final response = await _dio.post('/auth/verify-otp', data: {
        'email': email,
        'otp': otp,
      });
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error('Connection timeout. Please check your internet connection.');
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'OTP verification failed',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<void>> resetPassword(String email, String newPassword) async {
    try {
      final response = await _dio.post('/auth/reset-password', data: {
        'email': email,
        'newPassword': newPassword,
      });
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error('Connection timeout. Please check your internet connection.');
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Password reset failed',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<void>> verifyEmail(String token) async {
    try {
      final response = await _dio.post('/auth/verify-email', data: {
        'token': token,
      });
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error('Connection timeout. Please check your internet connection.');
      }
      return ApiResponse.error(
        e.response?.data?['message'] ?? 'Email verification failed',
        errorCode: e.response?.data?['errorCode'],
      );
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }
}
