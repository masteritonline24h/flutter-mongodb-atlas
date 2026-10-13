import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/custom_text_field.dart';
import '../../main.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  bool _isObscure = true;

  void _submitLogin() async {
    if (!_formKey.currentState!.validate()) return;

    // Trigger UI ឱ្យបង្ហាញ Loading Indicator
    setState(() {});

    await _authController.handleLogin(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      onError: (errorMsg) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      },
      onSuccess: (successMsg) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMsg),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        // ប្ដូរទៅកាន់ MainPage (និងលុប LoginScreen ចោលពី Navigation Stack)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      },
    );

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icon Logo
                  const Icon(
                    Icons.lock_person,
                    size: 80,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 16),

                  // Title
                  const Text(
                    'ចូលប្រព័ន្ធ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'សូមបញ្ចូល អ៊ីមែល និងពាក្យសម្ងាត់របស់អ្នក',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 32),

                  // Email Input Field
                  CustomTextField(
                    controller: _emailController,
                    label: 'អ៊ីមែល',
                    hint: 'example@gmail.com',
                    prefixIcon: Icons.email_outlined,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'សូមបញ្ចូលអ៊ីមែលរបស់អ្នក';
                      }
                      // ✅ Regex ត្រឹមត្រូវ (គ្មាន \ នៅមុខ $)
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val.trim())) {
                        return 'ទម្រង់អ៊ីមែលមិនត្រឹមត្រូវទេ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Input Field
                  CustomTextField(
                    controller: _passwordController,
                    label: 'ពាក្យសម្ងាត់',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    isObscure: _isObscure,
                    onToggleVisibility: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'សូមបញ្ចូលពាក្យសម្ងាត់';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  ElevatedButton(
                    onPressed: _authController.isLoading ? null : _submitLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _authController.isLoading
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                        : const Text(
                      'ចូលប្រព័ន្ធ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Link ផ្លាស់ប្ដូរទៅ Register Screen
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('មិនទាន់មានគណនីមែនទេ? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'ចុះឈ្មោះ',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}