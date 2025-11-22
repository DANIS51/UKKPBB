import 'package:flutter/material.dart';
import 'login_service.dart';
import 'package:ukk_danis/screens/home.dart';
import 'package:ukk_danis/screens/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginService loginService = LoginService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F1419), Color(0xFF1A2332)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 20,
            shadowColor: Colors.blue.withOpacity(0.3),
            color: const Color(0xFF1E2A38),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            child: Container(
              padding: const EdgeInsets.all(32),
              width: 360,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // LOGO
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFF1E88E5),
                        child: Icon(Icons.store, color: Colors.white, size: 40),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      "Selamat Datang!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      "Masuk untuk melanjutkan",
                      style: TextStyle(color: Colors.blue[200]),
                    ),
                    const SizedBox(height: 30),

                    // EMAIL / USERNAME INPUT
                    TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email / Username',
                        labelStyle: TextStyle(color: Colors.blue[200]),
                        prefixIcon: Icon(Icons.person_outline, color: Colors.blue[300]),
                        filled: true,
                        fillColor: const Color(0xFF2A3F5F),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF1E88E5), width: 2),
                        ),
                      ),
                      validator: (v) => v!.isEmpty ? 'Tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),

                    // PASSWORD INPUT
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Kata Sandi',
                        labelStyle: TextStyle(color: Colors.blue[200]),
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.blue[300]),
                        filled: true,
                        fillColor: const Color(0xFF2A3F5F),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF1E88E5), width: 2),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.blue[300],
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (v) => v!.isEmpty ? 'Tidak boleh kosong' : null,
                    ),

                    const SizedBox(height: 24),

                    // LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E88E5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 6,
                          shadowColor: Colors.blue.withOpacity(0.5),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => _isLoading = true);

                                  try {
                                    final result = await loginService.login(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                    );

                                    String token = result['token'];
                                    String userId = result['userId'];

                                    if (!mounted) return;

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => HomePage(
                                          token: token,
                                          userId: int.parse(userId),
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.toString()),
                                        backgroundColor: Colors.red[400],
                                      ),
                                    );
                                  } finally {
                                    setState(() => _isLoading = false);
                                  }
                                }
                              },
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Masuk',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // REGISTER TEXT BUTTON
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterPage()),
                        );
                      },
                      child: Text(
                        'Belum punya akun? Daftar',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[300],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}