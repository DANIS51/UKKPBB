import 'package:flutter/material.dart';
import 'package:ukk_danis/service/produk_service.dart';

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

    final images = widget.product['images'] as List<dynamic>? ?? [];

    _namaController =
        TextEditingController(text: widget.product['nama_produk'] ?? '');
    _hargaController =
        TextEditingController(text: widget.product['harga']?.toString() ?? '');
    _deskripsiController =
        TextEditingController(text: widget.product['deskripsi'] ?? '');
    _stokController =
        TextEditingController(text: widget.product['stok']?.toString() ?? '');
    _imagesController = TextEditingController(
      text: images.isNotEmpty
          ? images.map((e) => e['url']).join(', ')
          : "",
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

    setState(() => _isLoading = true);

    try {
      // PARSE IMAGES → list string
      List<String> images = [];
      if (_imagesController.text.trim().isNotEmpty) {
        images = _imagesController.text
            .split(',')
            .map((e) => e.trim())
            .where((url) => url.isNotEmpty)
            .toList();
      }

      final idProduk = int.tryParse(widget.product['id_produk'].toString());

      if (idProduk == null) {
        throw "ID Produk tidak valid!";
      }

      final response = await produkService.updateProduct(
        widget.token,
        idProduk,
        namaProduk: _namaController.text,
        harga: int.parse(_hargaController.text),
        deskripsi: _deskripsiController.text,
        stok: int.parse(_stokController.text),
        images: images,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil diupdate'),
          backgroundColor: Color(0xFF1E88E5),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error update produk: $e',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
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
          "Edit Produk",
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
        padding: const EdgeInsets.all(16),
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
                      "Edit Produk",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Perbarui informasi produk",
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
                    // Nama Produk
                    const Text(
                      "Nama Produk",
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
                        hintText: "Masukkan nama produk",
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
                        prefixIcon: const Icon(Icons.shopping_bag, color: Color(0xFF1E88E5)),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Nama produk tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),

                    // Harga
                    const Text(
                      "Harga",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _hargaController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Masukkan harga produk",
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
                        prefixIcon: const Icon(Icons.attach_money, color: Color(0xFF1E88E5)),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Harga tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),

                    // Stok
                    const Text(
                      "Stok",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _stokController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Masukkan jumlah stok",
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
                        prefixIcon: const Icon(Icons.inventory_2, color: Color(0xFF1E88E5)),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Stok tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),

                    // Deskripsi
                    const Text(
                      "Deskripsi",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _deskripsiController,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Masukkan deskripsi produk",
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
                        prefixIcon: const Icon(Icons.description, color: Color(0xFF1E88E5)),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Deskripsi tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),

                    // URL Gambar
                    const Text(
                      "URL Gambar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _imagesController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Pisahkan dengan koma jika lebih dari satu",
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
                        prefixIcon: const Icon(Icons.image, color: Color(0xFF1E88E5)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Button Update
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
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
                            Text("Update Produk"),
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