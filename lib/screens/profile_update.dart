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
      appBar: AppBar(
        title: const Text("Update Profil"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Pesan Error
              if (errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
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
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          successMessage!,
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),

              // Field Nama
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
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
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_circle),
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
              TextFormField(
                controller: _kontakController,
                decoration: const InputDecoration(
                  labelText: 'Kontak',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
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
              const SizedBox(height: 32),

              // Tombol Update
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Update Profil',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
