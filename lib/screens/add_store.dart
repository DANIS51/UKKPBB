import 'package:flutter/material.dart';
import 'package:ukk_danis/service/LoginService.dart';

class AddStorePage extends StatefulWidget {
  final String token;

  const AddStorePage({super.key, required this.token});

  @override
  State<AddStorePage> createState() => _AddStorePageState();
}

class _AddStorePageState extends State<AddStorePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController namaTokoController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController kontakController = TextEditingController();

  bool loadingSubmit = false;

  Future<void> simpanToko() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loadingSubmit = true);

    try {
      await LoginService().createToko(
        widget.token,
        namaToko: namaTokoController.text.trim(),
        deskripsi: deskripsiController.text.trim(),
        alamat: alamatController.text.trim(),
        kontak: kontakController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Toko berhasil dibuat!")),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal buat toko: $e")),
      );
    }

    if (mounted) setState(() => loadingSubmit = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419), // Background gelap
      appBar: AppBar(
        title: const Text("Tambah Toko"),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: namaTokoController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Nama Toko",
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF1E88E5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF42A5F5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: const Color(0xFF1E2A38),
                  filled: true,
                ),
                validator: (v) => v == null || v.isEmpty
                    ? "Nama toko tidak boleh kosong"
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: deskripsiController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Deskripsi",
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF1E88E5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF42A5F5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: const Color(0xFF1E2A38),
                  filled: true,
                ),
                validator: (v) => v == null || v.isEmpty
                    ? "Deskripsi tidak boleh kosong"
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: alamatController,
                maxLines: 2,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Alamat",
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF1E88E5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF42A5F5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: const Color(0xFF1E2A38),
                  filled: true,
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Alamat tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: kontakController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Kontak",
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF1E88E5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF42A5F5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: const Color(0xFF1E2A38),
                  filled: true,
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Kontak tidak boleh kosong" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: loadingSubmit ? null : simpanToko,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: loadingSubmit
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Buat Toko"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
