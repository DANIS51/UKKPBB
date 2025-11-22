import 'package:flutter/material.dart';
import 'package:ukk_danis/service/login_service.dart';
import 'package:ukk_danis/service/produk_service.dart';
import 'package:ukk_danis/screens/add_product.dart';
import 'package:ukk_danis/screens/edit_product.dart';
import 'package:ukk_danis/screens/product_detail.dart';

class ProductsPage extends StatefulWidget {
  final String token;

  const ProductsPage({super.key, required this.token});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final LoginService loginService = LoginService();
  final ProdukService produkService = ProdukService();

  List<dynamic> products = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  // Safe helper to convert dynamic id to int (returns null if can't)
  int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is String) return int.tryParse(v);
    if (v is double) return v.toInt();
    return null;
  }

  Future<void> loadProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await loginService.getStoreProducts(widget.token);

      // ensure we always have a list
      final list = (data is List) ? data : [];

      setState(() {
        products = list;
      });
    } catch (e) {
      // treat 404 as empty result (new user / no products)
      final s = e.toString();
      if (s.contains('404')) {
        setState(() {
          products = [];
        });
      } else {
        setState(() {
          errorMessage = s;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshProducts() async {
    await loadProducts();
  }

  Future<void> _navigateToAddProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddProductPage(token: widget.token)),
    );
    await _refreshProducts();
  }

  Future<void> _navigateToEditProduct(Map<String, dynamic> product) async {
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProductPage(token: widget.token, product: product),
      ),
    );
    await _refreshProducts();
  }

  Future<void> _deleteProduct(dynamic rawId) async {
    final id = _toInt(rawId);
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("ID produk tidak valid"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E2A38),
        title: const Text(
          "Hapus Produk",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Yakin ingin menghapus produk ini?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "Batal",
              style: TextStyle(color: Color(0xFF1E88E5)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await produkService.deleteProduct(widget.token, id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Produk berhasil dihapus"),
          backgroundColor: Color(0xFF1E88E5),
        ),
      );
      await _refreshProducts();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error menghapus produk: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildProductCard(Map product) {
    // defensive extraction with fallbacks
    final nama = product['nama_produk']?.toString() ?? "Nama tidak tersedia";
    final harga = product['harga']?.toString() ?? "-";
    final deskripsi = (product['deskripsi']?.toString() ?? "-");
    final stokValue = int.tryParse(product['stok']?.toString() ?? "0") ?? 0;
    final stok = stokValue.toString();
    final tanggal = product['tanggal_upload']?.toString() ?? "-";
    final kategori = product['nama_kategori']?.toString() ?? "-";

    final imagesRaw = product['images'];
    final List images = (imagesRaw is List) ? imagesRaw : [];

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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row title & harga
            Row(
              children: [
                Expanded(
                  child: Text(
                    nama,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Rp $harga",
                  style: const TextStyle(
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Deskripsi
            Text(
              deskripsi,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),

            const SizedBox(height: 12),

            // Images horizontal
            if (images.isNotEmpty)
              SizedBox(
                height: 95,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, idx) {
                    final img = images[idx];
                    final url = (img is Map && img['url'] != null)
                        ? img['url'].toString()
                        : null;

                    if (url == null || url.isEmpty) {
                      return Container(
                        width: 95,
                        height: 95,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A3F5F),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      );
                    }

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url,
                          width: 95,
                          height: 95,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 95,
                            height: 95,
                            color: const Color(0xFF2A3F5F),
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          ),
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              width: 95,
                              height: 95,
                              color: const Color(0xFF2A3F5F),
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF1E88E5),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.image_not_supported,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Tidak ada gambar",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // stok & kategori & tanggal
            Row(
              children: [
                // Badge stok
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: stokValue <= 5
                        ? Colors.red.withOpacity(0.2)
                        : const Color(0xFF1E88E5).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: stokValue <= 5
                          ? Colors.red.withOpacity(0.5)
                          : const Color(0xFF1E88E5).withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 14,
                        color: stokValue <= 5 ? Colors.red : const Color(0xFF1E88E5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Stok: $stok",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: stokValue <= 5 ? Colors.red : const Color(0xFF1E88E5),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Badge kategori
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.purple.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.category, size: 14, color: Colors.purple),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            kategori,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            
            // Tanggal upload
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Colors.grey[400],
                ),
                const SizedBox(width: 4),
                Text(
                  "Tanggal Upload: $tanggal",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    try {
                      _navigateToEditProduct(
                        Map<String, dynamic>.from(product),
                      );
                    } catch (_) {
                      _navigateToEditProduct(
                        Map<String, dynamic>.from(product as Map),
                      );
                    }
                  },
                  icon: const Icon(Icons.edit, color: Color(0xFF1E88E5)),
                  label: const Text("Edit", style: TextStyle(color: Color(0xFF1E88E5))),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5).withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _deleteProduct(
                    product['id_produk'] ??
                        product['id'] ??
                        product['idProduct'],
                  ),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text("Hapus", style: TextStyle(color: Colors.red)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProduct,
        backgroundColor: const Color(0xFF1E88E5),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1E88E5)))
          : RefreshIndicator(
              color: const Color(0xFF1E88E5),
              onRefresh: _refreshProducts,
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
                            onPressed: _refreshProducts,
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
                  : products.isEmpty
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
                          itemCount: products.length,
                          itemBuilder: (_, i) {
                            final item = products[i];
                            if (item is Map<String, dynamic>) {
                              return buildProductCard(item);
                            } else if (item is Map) {
                              return buildProductCard(Map<String, dynamic>.from(item));
                            } else {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E2A38),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Data produk tidak standar",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.toString(),
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
            ),
    );
  }
}