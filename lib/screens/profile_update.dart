import 'package:flutter/material.dart';
import 'package:ukk_danis/service/login_service.dart';

class ProfileUpdatePage extends StatefulWidget {
  final String token;
  final Map<String, dynamic> currentProfile;

  const ProfileUpdatePage({
    super.key,
    required this.token,
    required this.currentProfile,
  });

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final LoginService loginService = LoginService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _usernameController;
  late TextEditingController _kontakController;

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: widget.currentProfile['nama'] ?? '',
    );
    _usernameController = TextEditingController(
      text: widget.currentProfile['username'] ?? '',
    );
    _kontakController = TextEditingController(
      text: widget.currentProfile['kontak']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    _kontakController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
      successMessage = null;
    });

    try {
      await loginService.updateProfile(
        widget.token,
        nama: _namaController.text.trim(),
        username: _usernameController.text.trim(),
        kontak: _kontakController.text.trim(),
      );

      setState(() {
        isLoading = false;
        successMessage = 'Profil berhasil diperbarui!';
      });

      // Kembali ke halaman sebelumnya setelah 2 detik
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context, true); // Return true untuk refresh profile
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Background gelap sesuai tema
      backgroundColor: const Color(0xFF0F1419),
      
      // 2. AppBar dengan tema gelap
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1E2A38),
        centerTitle: true,
        title: const Text(
          "Update Profil",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // Ikon di AppBar dibuat putih agar kontras
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1E88E5),
                      Color(0xFF1565C0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E88E5).withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.edit,
                      size: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Update Profil",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Perbarui informasi profil Anda",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Form container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2A38),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pesan Error
                    if (errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Pesan Sukses
                    if (successMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                successMessage!,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Field Nama
                    const Text(
                      "Nama Lengkap",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _namaController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Masukkan nama lengkap",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: const Color(0xFF0F1419),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF1E88E5)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        errorStyle: const TextStyle(color: Colors.red),
                        prefixIcon: const Icon(Icons.person, color: Color(0xFF1E88E5)),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Field Username
                    const Text(
                      "Username",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Masukkan username",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: const Color(0xFF0F1419),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF1E88E5)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        errorStyle: const TextStyle(color: Colors.red),
                        prefixIcon: const Icon(Icons.account_circle, color: Color(0xFF1E88E5)),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Username tidak boleh kosong';
                        }
                        if (value.length < 3) {
                          return 'Username minimal 3 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Field Kontak
                    const Text(
                      "Kontak",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _kontakController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Masukkan nomor kontak",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: const Color(0xFF0F1419),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF1E88E5)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        errorStyle: const TextStyle(color: Colors.red),
                        prefixIcon: const Icon(Icons.phone, color: Color(0xFF1E88E5)),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Kontak tidak boleh kosong';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Kontak harus berupa angka';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tombol Update
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 16),
                            Text("Memperbarui..."),
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            SizedBox(width: 8),
                            Text("Update Profil"),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
