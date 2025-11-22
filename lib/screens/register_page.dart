import 'package:flutter/material.dart';
import '../service/login_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginService loginService = LoginService();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController kontakController = TextEditingController();
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
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                          child: Icon(Icons.person_add, color: Colors.white, size: 40),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        "Daftar Akun Baru",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        "Lengkapi data diri anda",
                        style: TextStyle(color: Colors.blue[200]),
                      ),
                      const SizedBox(height: 28),

                      // NAMA
                      TextFormField(
                        controller: namaController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Nama Lengkap',
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

                      // USERNAME
                      TextFormField(
                        controller: usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.blue[200]),
                          prefixIcon: Icon(Icons.account_circle_outlined, color: Colors.blue[300]),
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

                      // KONTAK
                      TextFormField(
                        controller: kontakController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Nomor Kontak',
                          labelStyle: TextStyle(color: Colors.blue[200]),
                          prefixIcon: Icon(Icons.phone_android, color: Colors.blue[300]),
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
                        validator: (v) {
                          if (v!.isEmpty) return 'Tidak boleh kosong';
                          if (int.tryParse(v) == null) return 'Harus berupa angka';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // PASSWORD
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
                              setState(() => _isPasswordVisible = !_isPasswordVisible);
                            },
                          ),
                        ),
                        validator: (v) => v!.isEmpty ? 'Tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 28),

                      // REGISTER BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E88E5),
                            foregroundColor: Colors.white,
                            elevation: 6,
                            shadowColor: Colors.blue.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => _isLoading = true);

                                    try {
                                      await loginService.register(
                                        namaController.text.trim(),
                                        usernameController.text.trim(),
                                        int.parse(kontakController.text.trim()),
                                        passwordController.text.trim(),
                                      );

                                      if (!mounted) return;

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Registrasi berhasil! Silakan login.'),
                                          backgroundColor: Colors.green[600],
                                        ),
                                      );

                                      Navigator.pop(context);
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
                                  'Daftar',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Sudah punya akun? Masuk",
                          style: TextStyle(
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
      ),
    );
  }
}