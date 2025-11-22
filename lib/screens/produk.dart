import 'package:flutter/material.dart';
import 'package:ukk_danis/service/produk_service.dart';
import 'package:ukk_danis/screens/edit_product.dart';
import 'package:ukk_danis/screens/product_detail.dart';

class ProdukPage extends StatefulWidget {
  final String token;

  const ProdukPage({super.key, required this.token});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  final ProdukService produkService = ProdukService();
  List<Map<String, dynamic>> produkList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProduk();
  }

  Future<void> loadProduk() async {
    try {
      final data = await produkService.getProduk(widget.token);

      if (mounted) {
        setState(() {
          produkList = List<Map<String, dynamic>>.from(data ?? []);
          loading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> deleteProduk(int productId) async {
    try {
      await produkService.deleteProduct(widget.token, productId);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Produk berhasil dihapus")));

      loadProduk();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal hapus produk: $e")));
    }
  }

  void showDeleteDialog(int productId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Produk"),
        content: const Text("Apakah Anda yakin ingin menghapus produk ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteProduk(productId);
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (produkList.isEmpty) {
      return const Scaffold(body: Center(child: Text("Tidak ada produk")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Produk")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: produkList.length,
        itemBuilder: (context, index) {
          final p = produkList[index];

          final gambarUrl = (p['gambar'] ?? "").toString();

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailPage(product: p),
                  ),
                );
              },
              child: ListTile(
                leading: gambarUrl.isNotEmpty
                    ? Image.network(
                        gambarUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      )
                    : const Icon(Icons.image_not_supported),

                title: Text(
                  (p['nama_produk'] ?? "Tanpa Nama").toString(),
                  style: const TextStyle(color: Colors.teal),
                ),

                subtitle: Text(
                  "Harga: Rp ${p['harga'] ?? 0}\n"
                  "Stok: ${p['stok'] ?? 0}\n"
                  "Tanggal Upload: ${(p['tanggal_upload'] ?? '').toString()}\n"
                  "Deskripsi: ${(p['deskripsi'] ?? '').toString()}",
                ),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProductPage(
                              token: widget.token,
                              product: p,
                            ),
                          ),
                        ).then((_) => loadProduk());
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => showDeleteDialog(p['id_produk']),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
