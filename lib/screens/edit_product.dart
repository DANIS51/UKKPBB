import 'package:flutter/material.dart';
import 'package:ukk_danis/service/produk_service.dart';
import 'package:ukk_danis/service/LoginService.dart';

class EditProductPage extends StatefulWidget {
  final String token;
  final Map<String, dynamic> product;

  const EditProductPage({
    super.key,
    required this.token,
    required this.product,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final ProdukService produkService = ProdukService();
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _namaController;
  late final TextEditingController _hargaController;
  late final TextEditingController _deskripsiController;
  late final TextEditingController _stokController;
  late final TextEditingController _imagesController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: widget.product['nama_produk'] ?? '',
    );
    _hargaController = TextEditingController(
      text: widget.product['harga']?.toString() ?? '',
    );
    _deskripsiController = TextEditingController(
      text: widget.product['deskripsi'] ?? '',
    );
    _stokController = TextEditingController(
      text: widget.product['stok']?.toString() ?? '',
    );
    final images = widget.product['images'] as List<dynamic>? ?? [];
    _imagesController = TextEditingController(
      text: images.map((e) => e['url']).join(', '),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _deskripsiController.dispose();
    _stokController.dispose();
    _imagesController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<String> images = [];
      if (_imagesController.text.isNotEmpty) {
        images = _imagesController.text
            .split(',')
            .map((e) => e.trim())
            .toList();
      }

      await produkService.updateProduct(
        widget.token,
        int.parse(widget.product['id_produk'].toString()),
        namaProduk: _namaController.text,
        harga: int.parse(_hargaController.text),
        deskripsi: _deskripsiController.text,
        stok: int.parse(_stokController.text),
        images: images,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Produk berhasil diupdate')));

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Produk'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama produk tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harga harus angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stokController,
                decoration: const InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Stok harus angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imagesController,
                decoration: const InputDecoration(
                  labelText: 'URL Gambar (pisahkan dengan koma)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Update Produk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
