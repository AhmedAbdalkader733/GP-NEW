import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/api_service.dart';
import 'dart:developer' as developer;

class VerificationCodePage extends StatefulWidget {
  final String email;
  const VerificationCodePage({super.key, required this.email});

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final TextEditingController _codeController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;
  bool _verificationSuccess = false;

  @override
  void initState() {
    super.initState();
    developer.log(
      'Verification page opened with email: ${widget.email}',
      name: 'verification_page',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD5B977), Color(0xFF181511)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withAlpha(38),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: mainColor,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Image.network(
                      'https://cdn-icons-png.flaticon.com/512/3845/3845819.png',
                      height: 70,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _verificationSuccess
                          ? "Email Verified Successfully!"
                          : "Check your Email",
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        letterSpacing: .1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _verificationSuccess
                          ? "You can now log in to your account"
                          : "A verification code has been sent to:",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    Text(
                      widget.email,
                      style: const TextStyle(
                        fontSize: 15,
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!_verificationSuccess) ...[
                      const SizedBox(height: 16),
                      const Text(
                        "Please check your inbox (and spam folder) for an email with a 6-digit verification code.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      const SizedBox(height: 22),
                      TextField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        style: const TextStyle(fontSize: 19, letterSpacing: 7),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: "Enter the 6-digit code",
                          hintStyle: TextStyle(
                            fontSize: 17,
                            color: Colors.grey.shade500,
                          ),
                          errorText: _errorMessage,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: mainColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _verifyCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
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
                                    "Verify",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 9),
                      TextButton(
                        onPressed: _isLoading ? null : _resendCode,
                        child: const Text(
                          "Resend Code",
                          style: TextStyle(
                            color: mainColor,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              () => Navigator.of(
                                context,
                              ).pushReplacementNamed('/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Go to Login",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _verifyCode() async {
    if (_codeController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please enter the verification code";
      });
      return;
    }

    if (_codeController.text.length < 6) {
      setState(() {
        _errorMessage = "Code must be 6 digits";
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      developer.log(
        'Verifying code: ${_codeController.text} for email: ${widget.email}',
        name: 'verification_page',
      );

      final response = await _apiService.verifyEmail(
        widget.email,
        _codeController.text,
      );

      if (!mounted) return;

      if (response.success) {
        developer.log(
          'Verification successful: ${response.message}',
          name: 'verification_page',
        );

        setState(() {
          _verificationSuccess = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        developer.log(
          'Verification failed: ${response.message}',
          name: 'verification_page',
        );

        setState(() {
          _errorMessage = response.message;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      developer.log(
        'Error during verification: $e',
        name: 'verification_page',
        error: e,
      );

      if (!mounted) return;

      setState(() {
        _errorMessage = "Verification failed. Please try again.";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Verification failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendCode() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      developer.log(
        'Requesting new verification code for: ${widget.email}',
        name: 'verification_page',
      );

      // Use the forgot password endpoint to get a new OTP
      // This is a workaround since there's no specific endpoint for resending verification code
      final response = await _apiService.forgotPassword(widget.email);

      if (!mounted) return;

      if (response.success) {
        developer.log(
          'Code resent successfully: ${response.message}',
          name: 'verification_page',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "A new verification code has been sent to your email",
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Clear the old code
        _codeController.clear();
      } else {
        developer.log(
          'Code resend failed: ${response.message}',
          name: 'verification_page',
        );

        setState(() {
          _errorMessage = "Failed to resend code";
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      developer.log(
        'Error resending code: $e',
        name: 'verification_page',
        error: e,
      );

      if (!mounted) return;

      setState(() {
        _errorMessage = "Failed to resend code";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to resend code: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
