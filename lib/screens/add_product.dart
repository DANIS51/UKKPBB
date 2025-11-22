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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Pilih kategori!")));
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
        const SnackBar(content: Text("Produk berhasil ditambahkan!")),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal tambah produk: $e")));
    }

    if (!mounted) return;
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

              TextFormField(
                controller: deskripsiController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

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

              loadingKategori
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Kategori",
                        border: OutlineInputBorder(),
                      ),

                      value: kategoriList.any((item) =>
                              item['id_kategori'].toString() ==
                              selectedKategori)
                          ? selectedKategori
                          : null,

                      items: kategoriList.map((item) {
                        return DropdownMenuItem<String>(
                          value: item['id_kategori'].toString(),
                          child: Text(item['nama_kategori']),
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

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: loadingSubmit ? null : simpanProduk,
                child: loadingSubmit
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Simpan Produk"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
