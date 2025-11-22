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
  String? errorMessage;

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
          errorMessage = null;
        });
      }
    } catch (e) {
      print("Error: $e");
      if (mounted) setState(() {
        loading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> deleteProduk(int productId) async {
    try {
      await produkService.deleteProduct(widget.token, productId);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Produk berhasil dihapus"),
          backgroundColor: Color(0xFF1E88E5),
        ),
      );

      loadProduk();
    } catch (e, stackTrace) {
      if (!mounted) return;
      print("Delete Produk Error: \$e");
      print(stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal hapus produk: \$e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void showDeleteDialog(int productId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E2A38),
        title: const Text(
          "Hapus Produk",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Apakah Anda yakin ingin menghapus produk ini?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Batal",
              style: TextStyle(color: Color(0xFF1E88E5)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteProduk(productId);
            },
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Background gelap sesuai tema
      backgroundColor: const Color(0xFF0F1419),

      body: loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1E88E5)))
          : RefreshIndicator(
              color: const Color(0xFF1E88E5),
              onRefresh: loadProduk,
              child: errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Terjadi kesalahan",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: loadProduk,
                            icon: const Icon(Icons.refresh),
                            label: const Text("Coba Lagi"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E88E5),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  : produkList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shopping_cart_outlined,
                                size: 80,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Tidak ada produk",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Belum ada produk yang tersedia",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: produkList.length,
                          itemBuilder: (context, index) {
                            final p = produkList[index];
                            final gambarUrl = (p['gambar'] ?? "").toString();
                            final stockValue = int.tryParse(p['stok'].toString()) ?? 0;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E2A38),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailPage(product: p),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Gambar produk
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: const Color(0xFF2A3F5F),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: gambarUrl.isNotEmpty
                                                  ? Image.network(
                                                      gambarUrl,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (_, __, ___) => const Icon(
                                                        Icons.broken_image,
                                                        color: Colors.grey,
                                                        size: 40,
                                                      ),
                                                    )
                                                  : const Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.grey,
                                                      size: 40,
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Nama produk
                                                Text(
                                                  (p['nama_produk'] ?? "Tanpa Nama").toString(),
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 8),
                                                // Harga
                                                Text(
                                                  "Rp ${p['harga'] ?? 0}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF4CAF50),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                // Stok dengan badge
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: stockValue <= 5
                                                            ? Colors.red.withOpacity(0.2)
                                                            : const Color(0xFF1E88E5).withOpacity(0.2),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      child: Text(
                                                        "Stok: ${p['stok'] ?? 0}",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: stockValue <= 5 ? Colors.red : const Color(0xFF1E88E5),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // Deskripsi
                                      Text(
                                        (p['deskripsi'] ?? '').toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[400],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 12),
                                      // Tanggal upload dan aksi
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Tanggal: ${(p['tanggal_upload'] ?? '').toString().substring(0, 10)}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Tombol edit
                                              IconButton(
                                                icon: const Icon(Icons.edit, color: Color(0xFF1E88E5)),
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
                                              // Tombol hapus
                                              IconButton(
                                                icon: const Icon(Icons.delete, color: Colors.red),
                                                onPressed: () => showDeleteDialog(p['id_produk']),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
    );
  }
}