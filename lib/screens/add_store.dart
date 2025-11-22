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
      appBar: AppBar(title: const Text("Tambah Toko")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // =============================
              // NAMA TOKO
              // =============================
              TextFormField(
                controller: namaTokoController,
                decoration: const InputDecoration(
                  labelText: "Nama Toko",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Nama toko tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),

              // =============================
              // DESKRIPSI
              // =============================
              TextFormField(
                controller: deskripsiController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Deskripsi tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),

              // =============================
              // ALAMAT
              // =============================
              TextFormField(
                controller: alamatController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Alamat",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Alamat tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),

              // =============================
              // KONTAK
              // =============================
              TextFormField(
                controller: kontakController,
                decoration: const InputDecoration(
                  labelText: "Kontak",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v == null || v.isEmpty ? "Kontak tidak boleh kosong" : null,
              ),
              const SizedBox(height: 24),

              // =============================
              // SUBMIT BUTTON
              // =============================
              ElevatedButton(
                onPressed: loadingSubmit ? null : simpanToko,
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
