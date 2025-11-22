import 'package:flutter/material.dart';
import 'produk_service.dart';
import 'LoginService.dart';

class TambahProdukPage extends StatefulWidget {
  final String token;

  const TambahProdukPage({super.key, required this.token});

  @override
  State<TambahProdukPage> createState() => _TambahProdukPageState();
}

class _TambahProdukPageState extends State<TambahProdukPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController stokController = TextEditingController();

  // Dropdown kategori
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

      setState(() {
        kategoriList = data;
        loadingKategori = false;

        // reset kategori jika tidak ada
        if (selectedKategori != null &&
            !kategoriList.any((i) => i['id'].toString() == selectedKategori)) {
          selectedKategori = null;
        }
      });
    } catch (e) {
      print("Error kategori: $e");
      setState(() => loadingKategori = false);
    }
  }

  Future<void> simpanProduk() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih kategori terlebih dahulu!")),
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produk berhasil ditambahkan!")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menambahkan produk: $e")),
      );
    }

    setState(() => loadingSubmit = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Produk")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nama Produk
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Produk",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v!.isEmpty ? "Nama produk tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),

              // Harga
              TextFormField(
                controller: hargaController,
                decoration: const InputDecoration(
                  labelText: "Harga",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Masukkan harga" : null,
              ),
              const SizedBox(height: 16),

              // Deskripsi
              TextFormField(
                controller: deskripsiController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Stok
              TextFormField(
                controller: stokController,
                decoration: const InputDecoration(
                  labelText: "Stok",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Masukkan stok" : null,
              ),
              const SizedBox(height: 16),

              // Dropdown Kategori
              loadingKategori
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Kategori",
                        border: OutlineInputBorder(),
                      ),
                      value: selectedKategori,
                      items: kategoriList.map((item) {
                        return DropdownMenuItem(
                          value: item['id'].toString(),
                          child: Text(item['nama_kategori'] ?? "-"),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setState(() => selectedKategori = v);
                      },
                      validator: (v) =>
                          v == null ? "Kategori wajib dipilih!" : null,
                    ),

              const SizedBox(height: 24),

              // Button Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loadingSubmit ? null : simpanProduk,
                  child: loadingSubmit
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Simpan Produk"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
