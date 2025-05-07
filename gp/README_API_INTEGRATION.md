# API Integration Guide for Flutter Frontend & Node.js Backend

## Overview

This document provides a comprehensive guide for integrating the Flutter frontend with the Node.js backend using the Dio package. It includes all available API endpoints, implementation patterns, and fixes for common issues.

## Backend API Endpoints

### Authentication APIs

| Endpoint | Method | Description | Request Body | Response |
|----------|--------|-------------|--------------|----------|
| `/auth/login` | POST | User login | `{ email: string, password: string }` | `ApiResponse<AuthResponse>` |
| `/auth/register/usher` | POST | Register usher | `{ firstName, lastName, email, password, phone, birthdate, gender }` | `ApiResponse<AuthResponse>` |
| `/auth/register/company` | POST | Register company | `{ name, email, password, phone, address }` | `ApiResponse<AuthResponse>` |
| `/auth/register/content-creator` | POST | Register content creator | `{ firstName, lastName, email, password, phone, birthdate, gender, fieldOfWork }` | `ApiResponse<AuthResponse>` |
| `/auth/forgot-password` | POST | Request password reset | `{ email: string }` | `ApiResponse<void>` |
| `/auth/verify-otp` | POST | Verify OTP code | `{ email: string, otp: string }` | `ApiResponse<void>` |
| `/auth/reset-password` | POST | Reset password | `{ email: string, newPassword: string }` | `ApiResponse<void>` |
| `/auth/verify-email` | POST | Verify email | `{ token: string }` | `ApiResponse<void>` |

### Usher APIs

| Endpoint | Method | Description | Request Body | Response |
|----------|--------|-------------|--------------|----------|
| `/usher/profile` | GET | Get usher profile | - | `ApiResponse<Map<String, dynamic>>` |
| `/usher/profile` | PATCH | Update usher profile | Profile data | `ApiResponse<void>` |
| `/usher/complete-profile` | POST | Complete usher profile | Profile data | `ApiResponse<void>` |
| `/usher/profile/upload-picture` | PATCH | Upload profile picture | FormData with image | `ApiResponse<void>` |

### Company APIs

| Endpoint | Method | Description | Request Body | Response |
|----------|--------|-------------|--------------|----------|
| `/company/profile` | GET | Get company profile | - | `ApiResponse<Map<String, dynamic>>` |
| `/company/profile` | PATCH | Update company profile | Profile data | `ApiResponse<void>` |

### Content Creator APIs

| Endpoint | Method | Description | Request Body | Response |
|----------|--------|-------------|--------------|----------|
| `/content-creator/profile` | GET | Get profile | - | `ApiResponse<Map<String, dynamic>>` |
| `/content-creator/profile` | PATCH | Update profile | Profile data | `ApiResponse<void>` |
| `/content-creator/profile/upload-picture` | PATCH | Upload profile picture | FormData with image | `ApiResponse<void>` |

### Job APIs

| Endpoint | Method | Description | Request Body | Response |
|----------|--------|-------------|--------------|----------|
| `/jobs` | POST | Create job | Job data | `ApiResponse<Job>` |
| `/jobs` | GET | Get all jobs | - | `ApiResponse<List<Job>>` |

## API Integration Issues & Fixes

### 1. Proper ApiResponse Handling

**Issue**: Some screens assume `response.data` is a `Map<String, dynamic>`, but the backend returns an `ApiResponse<AuthResponse>`.

**Correct Implementation**:

```dart
final response = await _apiService.registerUsher(data);
if (response.success) {
  final authResponse = response.data;
  // Continue with next steps
  
  // Show success message using response.message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(response.message),
      backgroundColor: Colors.green,
    ),
  );
  
  // Navigate to next screen if needed
  if (context.mounted) {
    Navigator.pushReplacementNamed(context, '/login');
  }
} else {
  // Show error message
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

### 2. Base URL Issue on Emulator

**Issue**: `http://localhost:3000` doesn't work on Android Emulator.

**Fix**: The API service already has the correct configuration:

```dart
static const String baseUrl = 'http://10.0.2.2:3000';
```

This correctly redirects to the host machine's localhost from the Android emulator.

### 3. Context.mounted Checks

**Issue**: Missing context.mounted checks before using context after async operations.

**Fix**: Always use context.mounted check after awaiting API calls:

```dart
try {
  final response = await _apiService.someApiCall();
  
  if (!context.mounted) return;
  
  // Now you can safely use context
  Navigator.push(...);
  ScaffoldMessenger.of(context).showSnackBar(...);
} catch (e) {
  if (!context.mounted) return;
  // Error handling
}
```

### 4. Proper Loading State Management

**Issue**: Loading state not properly managed.

**Fix**: Set loading state in try/finally blocks:

```dart
setState(() => _isLoading = true);
try {
  // API call and processing
} catch (e) {
  // Error handling
} finally {
  if (context.mounted) {
    setState(() => _isLoading = false);
  }
}
```

### 5. Error Display and Logging

**Issue**: Errors not consistently shown to users or logged.

**Fix**: Implement consistent error handling:

```dart
try {
  // API call
} on DioException catch (e) {
  debugPrint('DioException: ${e.toString()}');
  debugPrint('Error response: ${e.response?.data}');
  
  if (!context.mounted) return;
  
  String errorMessage;
  if (e.type == DioExceptionType.connectionTimeout || 
      e.type == DioExceptionType.receiveTimeout) {
    errorMessage = 'Connection timeout. Please check your internet connection.';
  } else {
    errorMessage = e.response?.data?['message'] ?? 'An error occurred';
  }
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errorMessage),
      backgroundColor: Colors.red,
    ),
  );
} catch (e, stackTrace) {
  debugPrint('Unexpected error: ${e.toString()}');
  debugPrint('Stack trace: ${stackTrace.toString()}');
  
  if (!context.mounted) return;
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('An unexpected error occurred'),
      backgroundColor: Colors.red,
    ),
  );
}
```

### 6. Trimming Input Fields

**Issue**: Input data not consistently trimmed.

**Fix**: Always trim input fields before sending:

```dart
final data = {
  'email': emailController.text.trim(),
  'password': passwordController.text,
  'firstName': firstNameController.text.trim(),
  'lastName': lastNameController.text.trim(),
  'phone': phoneController.text.trim(),
  // Other fields
};
```

### 7. Proper API Success Message Handling

**Issue**: Success messages from API not shown to users.

**Fix**: Always show the API's success message:

```dart
if (response.success) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        backgroundColor: Colors.green,
      ),
    );
    
    // Then navigate if appropriate
    Navigator.of(context).pushReplacementNamed('/next-page');
  }
}
```

## Enhanced API Service Implementation

The project already has a well-structured ApiService class using Dio. Here's how to properly use it:

1. **Making API calls**:

```dart
// Import the service
import '../services/api_service.dart';

// Create an instance
final _apiService = ApiService();

// Use the service
Future<void> loginUser() async {
  setState(() => _isLoading = true);
  
  try {
    final response = await _apiService.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    
    if (!context.mounted) return;
    
    if (response.success) {
      // Handle success
      final authResponse = response.data;
      // Store token, navigate, etc.
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    // Handle exceptions
  } finally {
    if (context.mounted) {
      setState(() => _isLoading = false);
    }
  }
}
```

2. **Authentication flow**:

After successful login or registration, store the auth token:

```dart
if (response.success && response.data != null) {
  // Store token for authenticated requests
  _apiService.setAuthToken(response.data!.token!);
  
  // Navigation based on user role
  if (response.data!.user?['role'] == 'usher') {
    Navigator.pushReplacementNamed(context, '/usher-dashboard');
  } else if (response.data!.user?['role'] == 'company') {
    Navigator.pushReplacementNamed(context, '/company-dashboard');
  } else if (response.data!.user?['role'] == 'content-creator') {
    Navigator.pushReplacementNamed(context, '/creator-dashboard');
  }
}
```

## Usher Registration Specific Fixes

For the usher registration form, make these specific changes:

1. Make sure the birthdate field is formatted correctly for the API
2. Ensure proper navigation after successful registration
3. Display success messages from the API

Implement following the standard pattern:

```dart
try {
  final response = await _apiService.registerUsher({
    'firstName': _firstNameController.text.trim(),
    'lastName': _lastNameController.text.trim(),
    'email': _emailController.text.trim(),
    'password': _passwordController.text,
    'phone': _phoneController.text.trim(),
    'birthdate': _birthDateController.text, // Ensure YYYY-MM-DD format
    'gender': _selectedGender,
  });
  
  if (!context.mounted) return;
  
  if (response.success) {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        backgroundColor: Colors.green,
      ),
    );
    
    // Navigate after success
    await Future.delayed(const Duration(seconds: 2));
    if (!context.mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  } else {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        backgroundColor: Colors.red,
      ),
    );
  }
} finally {
  if (context.mounted) {
    setState(() => _isLoading = false);
  }
}
```

## Dio Request/Response Logging

The project already includes Dio interceptors for logging requests and responses. This is useful for debugging API calls:

```dart
_dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      debugPrint('🌐 REQUEST[${options.method}] => PATH: ${options.path}');
      // Request logging
      return handler.next(options);
    },
    onResponse: (response, handler) {
      debugPrint('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
      // Response logging
      return handler.next(response);
    },
    onError: (error, handler) {
      debugPrint('❌ ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
      // Error logging
      return handler.next(error);
    },
  ),
);
```

This comprehensive API integration guide should help resolve all the issues in connecting the Flutter frontend to the Node.js backend.