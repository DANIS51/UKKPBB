import 'package:flutter/material.dart';
import 'package:ukk_danis/service/produk_service.dart';
import 'package:ukk_danis/service/LoginService.dart';

class AddProductPage extends StatefulWidget {
  final String token;

  const AddProductPage({super.key, required this.token});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController stokController = TextEditingController();

  // Dropdown
  List<dynamic> kategoriList = [];
  String? selectedKategori;

  bool loadingKategori = true;
  bool loadingSubmit = false;

  @override
  void initState() {
    super.initState();
    loadKategori();
  }

  Future<void> loadKategori() async {
    try {
      final data = await LoginService().getKategori(widget.token);

      if (!mounted) return;

      setState(() {
        kategoriList = data ?? [];
        loadingKategori = false;
      });

      print("Kategori Loaded: $kategoriList");
    } catch (e) {
      print("Error kategori: $e");
      if (!mounted) return;

      setState(() => loadingKategori = false);
    }
  }

  Future<void> simpanProduk() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pilih kategori!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loadingSubmit = true);

    try {
      await ProdukService().addProduct(
        widget.token,
        namaProduk: namaController.text,
        harga: int.parse(hargaController.text),
        deskripsi: deskripsiController.text,
        stok: int.parse(stokController.text),
        kategoriId: int.parse(selectedKategori!),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Produk berhasil ditambahkan!"),
          backgroundColor: Color(0xFF1E88E5),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal tambah produk: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (!mounted) return;
    setState(() => loadingSubmit = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Background gelap sesuai tema
      backgroundColor: const Color(0xFF0F1419),
      
      // 2. AppBar dengan tombol kembali
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1E2A38),
        title: const Text(
          "Tambah Produk",
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
                      Icons.add_shopping_cart,
                      size: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Tambah Produk Baru",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Lengkapi informasi produk untuk ditambahkan ke toko Anda",
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
                      controller: namaController,
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
                      ),
                      validator: (v) =>
                          v!.isEmpty ? "Nama produk tidak boleh kosong" : null,
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
                      controller: hargaController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
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
                      validator: (v) => v!.isEmpty ? "Masukkan harga" : null,
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
                      controller: stokController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
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
                      validator: (v) => v!.isEmpty ? "Masukkan stok" : null,
                    ),
                    const SizedBox(height: 16),

                    // Dropdown Kategori
                    const Text(
                      "Kategori",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    loadingKategori
                        ? const Center(
                            child: CircularProgressIndicator(color: Color(0xFF1E88E5)))
                        : DropdownButtonFormField<String>(
                            style: const TextStyle(color: Colors.white),
                            dropdownColor: const Color(0xFF1E2A38),
                            decoration: InputDecoration(
                              hintText: "Pilih kategori",
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
                              prefixIcon: const Icon(Icons.category, color: Color(0xFF1E88E5)),
                            ),
                            value: kategoriList.any((item) =>
                                    item['id_kategori'].toString() == selectedKategori)
                                ? selectedKategori
                                : null,
                            items: kategoriList.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['id_kategori'].toString(),
                                child: Text(item['nama_kategori'] ?? "-"),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedKategori = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) return "Pilih kategori!";
                              return null;
                            },
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
                      controller: deskripsiController,
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
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Button Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loadingSubmit ? null : simpanProduk,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: loadingSubmit
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
                            Text("Menyimpan..."),
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            SizedBox(width: 8),
                            Text("Simpan Produk"),
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