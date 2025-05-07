import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/api_service.dart';
import 'package:dio/dio.dart' show DioException, DioExceptionType;

class ContentCreatorRegisterPage extends StatefulWidget {
  const ContentCreatorRegisterPage({super.key});

  @override
  State<ContentCreatorRegisterPage> createState() =>
      _ContentCreatorRegisterPageState();
}

class _ContentCreatorRegisterPageState
    extends State<ContentCreatorRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();

  String? _selectedField;
  String? _selectedGender;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  final _apiService = ApiService();

  // Field values must match backend enum exactly
  final List<String> _fields = [
    'photography',
    'design',
    'music',
    'writing',
    'editing',
    'other',
  ];
  // Gender values must match backend enum exactly
  final List<String> _genders = ['male', 'female', 'other'];
  final ValueNotifier<String?> _errorMessage = ValueNotifier<String?>(null);

  @override
  void dispose() {
    _errorMessage.dispose();
    super.dispose();
  }

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
                  Color(0xFFFAF7ED),
                  Color(0xFFF8E8BF),
                  Color(0xFFE5D8BB),
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
                          color: Colors.black.withAlpha(23), // 0.09 * 255
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
                          "And share your art",
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
                        // First and Last name side by side
                        Row(
                          children: [
                            Expanded(
                              child: _buildField(
                                controller: _firstNameController,
                                hint: "First",
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _buildField(
                                controller: _lastNameController,
                                hint: "Last",
                              ),
                            ),
                          ],
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 13),
                          child: DropdownButtonFormField<String>(
                            decoration: _dropdownDecoration("Field"),
                            value: _selectedField,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: mainColor,
                            ),
                            items:
                                _fields.map((field) {
                                  return DropdownMenuItem<String>(
                                    value: field,
                                    child: Text(field),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedField = value;
                              });
                            },
                            validator:
                                (value) =>
                                    value == null
                                        ? "Please select a field"
                                        : null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 13),
                          child: DropdownButtonFormField<String>(
                            decoration: _dropdownDecoration("Gender"),
                            value: _selectedGender,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: mainColor,
                            ),
                            items:
                                _genders.map((gender) {
                                  return DropdownMenuItem<String>(
                                    value: gender,
                                    child: Text(gender),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                            validator:
                                (value) =>
                                    value == null
                                        ? "Please select a gender"
                                        : null,
                          ),
                        ),
                        _buildField(
                          controller: _phoneController,
                          hint: "Phone Number",
                        ),
                        _buildField(
                          controller: _birthDateController,
                          hint: "Birth Date",
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

                                        if (_selectedGender == null) {
                                          debugPrint(
                                            'ERROR: Gender selection is missing',
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Please select your gender',
                                              ),
                                              backgroundColor: Colors.red,
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
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

                                        if (_selectedField == null) {
                                          debugPrint(
                                            'ERROR: Field of work selection is missing',
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Please select your field of work',
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
                                          'firstName':
                                              _firstNameController.text.trim(),
                                          'lastName':
                                              _lastNameController.text.trim(),
                                          'email': _emailController.text.trim(),
                                          'password': _passwordController.text,
                                          'phone': _phoneController.text.trim(),
                                          'birthdate':
                                              _birthDateController.text,
                                          'gender': _selectedGender,
                                          'fieldOfWork': _selectedField,
                                        };

                                        debugPrint(
                                          'SENDING REGISTRATION DATA: $data',
                                        );

                                        final response = await _apiService
                                            .registerCreator(data);

                                        if (!mounted) return;

                                        if (!response.success) {
                                          debugPrint(
                                            'REGISTRATION ERROR: ${response.message}',
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
                                          'REGISTRATION SUCCESS: ${response.message}',
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
                                          'ERROR during content creator registration: $e',
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

  InputDecoration _dropdownDecoration(String hint) => InputDecoration(
    filled: true,
    fillColor: const Color(0xFFEAEAEA),
    hintText: hint,
    hintStyle: const TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.normal,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
      borderSide: const BorderSide(color: mainColor, width: 1.9),
    ),
  );
}
