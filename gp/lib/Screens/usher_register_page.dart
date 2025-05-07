import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';
import '../constants.dart';

class UsherRegisterPage extends StatefulWidget {
  const UsherRegisterPage({super.key});

  @override
  State<UsherRegisterPage> createState() => _UsherRegisterPageState();
}

class _UsherRegisterPageState extends State<UsherRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedGender;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  final _apiService = ApiService();

  // Gender values must match backend enum exactly
  final List<String> _genders = ['male', 'female', 'other'];

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
                          "And make events more easier",
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
                          child: TextFormField(
                            controller: _birthDateController,
                            readOnly: true,
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now().subtract(
                                  const Duration(days: 365 * 18),
                                ),
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now(),
                                builder:
                                    (context, child) => Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: mainColor,
                                        ),
                                      ),
                                      child: child!,
                                    ),
                              );
                              if (date != null) {
                                _birthDateController.text =
                                    "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                              }
                            },
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? "Please select your birth date"
                                        : null,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFEAEAEA),
                              hintText: "Usher BirthDate",
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
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 1.2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: const BorderSide(
                                  color: mainColor,
                                  width: 1.9,
                                ),
                              ),
                              suffixIcon: const Icon(
                                Icons.calendar_today,
                                color: mainColor,
                              ),
                            ),
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
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              minimumSize: const Size(200, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    try {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }

                                      if (_selectedGender == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Please select your gender'),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                        return;
                                      }

                                      if (_passwordController.text != _confirmPasswordController.text) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Passwords do not match'),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                        return;
                                      }

                                      setState(() => _isLoading = true);

                                      final response = await _apiService.registerUsher({
                                        'firstName': _firstNameController.text.trim(),
                                        'lastName': _lastNameController.text.trim(),
                                        'email': _emailController.text.trim(),
                                        'password': _passwordController.text,
                                        'phone': _phoneController.text.trim(),
                                        'birthdate': _birthDateController.text,
                                        'gender': _selectedGender,
                                      });

                                      if (!mounted) return;

                                      if (!response.success) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(response.message),
                                            backgroundColor: Colors.red,
                                            duration: const Duration(seconds: 3),
                                          ),
                                        );
                                        return;
                                      }

                                      // Show success message first
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(response.message),
                                          backgroundColor: Colors.green,
                                          duration: const Duration(seconds: 3),
                                        ),
                                      );

                                      // Wait for snackbar to be visible
                                      await Future.delayed(const Duration(milliseconds: 500));

                                      if (!mounted) return;

                                      // Navigate to login page
                                      Navigator.of(context).pushReplacementNamed('/login');
                                    } on DioException catch (e) {
                                      if (!mounted) return;

                                      String errorMessage;
                                      if (e.type == DioExceptionType.connectionTimeout || 
                                          e.type == DioExceptionType.receiveTimeout) {
                                        errorMessage = 'Connection timeout. Please check your internet connection.';
                                      } else {
                                        errorMessage = e.response?.data?['message'] ?? 'Registration failed';
                                      }

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(errorMessage),
                                          backgroundColor: Colors.red,
                                          duration: const Duration(seconds: 3),
                                        ),
                                      );
                                    } catch (e, stackTrace) {
                                      print('Error during usher registration: $e');
                                      print('Stack trace: $stackTrace');

                                      if (!mounted) return;

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('An unexpected error occurred during registration'),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    } finally {
                                      if (mounted) {
                                        setState(() => _isLoading = false);
                                      }
                                    }
                                  },
                            child: _isLoading
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
