import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/api_service.dart';
import 'package:dio/dio.dart' show DioException, DioExceptionType;

class CompanyRegisterPage extends StatefulWidget {
  const CompanyRegisterPage({super.key});

  @override
  State<CompanyRegisterPage> createState() => _CompanyRegisterPageState();
}

class _CompanyRegisterPageState extends State<CompanyRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  final _apiService = ApiService();
  final ValueNotifier<String?> _errorMessage = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: mainColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFBF7EC),
                  Color(0xFFE7D7B6),
                  Color(0xFFF7E3BB),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 18,
                ),
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(209), // 0.82 * 255
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(28), // 0.11 * 255
                          blurRadius: 13,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        const Text(
                          "Register Now",
                          style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            letterSpacing: .2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Grow your Business",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            letterSpacing: .1,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Text(
                              "Already have an account ? ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        _buildField(
                          controller: _companyNameController,
                          hint: "Company Name",
                        ),
                        _buildField(
                          controller: _emailController,
                          hint: "Email",
                        ),
                        _buildField(
                          controller: _passwordController,
                          hint: "Password",
                          obscure: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey.shade700,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        _buildField(
                          controller: _confirmPasswordController,
                          hint: "Confirm Password",
                          obscure: _obscureConfirm,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey.shade700,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirm = !_obscureConfirm;
                              });
                            },
                          ),
                        ),
                        _buildField(
                          controller: _addressController,
                          hint: "Address",
                        ),
                        _buildField(
                          controller: _phoneController,
                          hint: "Phone Number",
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed:
                                _isLoading
                                    ? null
                                    : () async {
                                      try {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }

                                        if (_passwordController.text !=
                                            _confirmPasswordController.text) {
                                          debugPrint(
                                            'ERROR: Passwords do not match',
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Passwords do not match',
                                              ),
                                              backgroundColor: Colors.red,
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                          return;
                                        }

                                        setState(() => _isLoading = true);

                                        // Log the data being sent to the API
                                        final data = {
                                          'name':
                                              _companyNameController.text
                                                  .trim(),
                                          'email': _emailController.text.trim(),
                                          'password': _passwordController.text,
                                          'phone': _phoneController.text.trim(),
                                          'address':
                                              _addressController.text.trim(),
                                        };

                                        debugPrint(
                                          'SENDING COMPANY REGISTRATION DATA: $data',
                                        );

                                        final response = await _apiService
                                            .registerCompany(data);

                                        if (!mounted) return;

                                        if (!response.success) {
                                          debugPrint(
                                            'COMPANY REGISTRATION ERROR: ${response.message}',
                                          );
                                          debugPrint(
                                            'ERROR CODE: ${response.errorCode}',
                                          );

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(response.message),
                                              backgroundColor: Colors.red,
                                              duration: const Duration(
                                                seconds: 3,
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        // Show success message
                                        debugPrint(
                                          'COMPANY REGISTRATION SUCCESS: ${response.message}',
                                        );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(response.message),
                                            backgroundColor: Colors.green,
                                            duration: const Duration(
                                              seconds: 3,
                                            ),
                                          ),
                                        );

                                        // Wait for snackbar to be visible
                                        await Future.delayed(
                                          const Duration(milliseconds: 500),
                                        );

                                        if (!mounted) return;

                                        // Navigate to verification page
                                        debugPrint(
                                          'Navigating to verification page with email: ${_emailController.text.trim()}',
                                        );
                                        Navigator.of(context).pushNamed(
                                          '/verification',
                                          arguments:
                                              _emailController.text.trim(),
                                        );
                                      } on DioException catch (e) {
                                        if (!mounted) return;

                                        String errorMessage;
                                        if (e.type ==
                                                DioExceptionType
                                                    .connectionTimeout ||
                                            e.type ==
                                                DioExceptionType
                                                    .receiveTimeout) {
                                          errorMessage =
                                              'Connection timeout. Please check your internet connection.';
                                        } else {
                                          errorMessage =
                                              e.response?.data?['message'] ??
                                              'Registration failed';
                                        }

                                        debugPrint('DIO ERROR: $errorMessage');
                                        debugPrint('Error Type: ${e.type}');
                                        debugPrint(
                                          'Error Response: ${e.response?.data}',
                                        );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(errorMessage),
                                            backgroundColor: Colors.red,
                                            duration: const Duration(
                                              seconds: 3,
                                            ),
                                          ),
                                        );
                                      } catch (e, stackTrace) {
                                        debugPrint(
                                          'ERROR during company registration: $e',
                                        );
                                        debugPrint('Stack trace: $stackTrace');

                                        if (!mounted) return;

                                        // Set error message for the persistent banner
                                        _errorMessage.value =
                                            'Registration failed: ${e.toString()}';

                                        // Also show a snackbar for immediate feedback
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              'Registration failed. See details at bottom of screen.',
                                            ),
                                            backgroundColor: Colors.red,
                                            duration: const Duration(
                                              seconds: 3,
                                            ),
                                            action: SnackBarAction(
                                              label: 'Dismiss',
                                              textColor: Colors.white,
                                              onPressed: () {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).hideCurrentSnackBar();
                                              },
                                            ),
                                          ),
                                        );
                                      } finally {
                                        if (mounted) {
                                          setState(() => _isLoading = false);
                                        }
                                      }
                                    },
                            child:
                                _isLoading
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text(
                                      "Create Account",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        validator:
            (value) => value!.isEmpty ? "This field can't be empty" : null,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFEAEAEA),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.normal,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 15,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: mainColor, width: 1.9),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
