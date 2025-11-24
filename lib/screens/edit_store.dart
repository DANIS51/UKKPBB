import 'package:flutter/material.dart';
import 'package:ukk_danis/service/login_service.dart';

class EditStorePage extends StatefulWidget {
  final String token;
  final Map<String, dynamic> store;

  const EditStorePage({super.key, required this.token, required this.store});

  @override
  State<EditStorePage> createState() => _EditStorePageState();
}

class _EditStorePageState extends State<EditStorePage> {
  final LoginService loginService = LoginService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameC, _alamatC, _kontakC, _deskripsiC;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController(
        text: widget.store['nama_toko'] ?? widget.store['name'] ?? '');
    _alamatC = TextEditingController(text: widget.store['alamat'] ?? '');
    _kontakC = TextEditingController(
        text: widget.store['kontak'] ?? widget.store['telp'] ?? '');
    _deskripsiC = TextEditingController(text: widget.store['deskripsi'] ?? '');
  }

  @override
  void dispose() {
    _nameC.dispose();
    _alamatC.dispose();
    _kontakC.dispose();
    _deskripsiC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isSaving = true);
    try {
      final storeId = int.tryParse(widget.store['id_toko']?.toString() ??
              widget.store['id']?.toString() ??
              '') ??
          0;
      await loginService.updateStore(
        widget.token,
        storeId: storeId,
        namaToko: _nameC.text.trim(),
        alamat: _alamatC.text.trim(),
        kontak: _kontakC.text.trim(),
        deskripsi: _deskripsiC.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Toko berhasil diupdate'),
            backgroundColor: Color(0xFF1E88E5)),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error update toko: $e'),
            backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Edit Toko'),
          backgroundColor: const Color(0xFF1E88E5)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameC,
                decoration: const InputDecoration(labelText: 'Nama Toko'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Nama toko wajib diisi'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _alamatC,
                decoration: const InputDecoration(labelText: 'Alamat'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _kontakC,
                decoration: const InputDecoration(labelText: 'Kontak'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _deskripsiC,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5)),
                child: isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
