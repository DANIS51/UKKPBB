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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("ID produk tidak valid")));
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Produk"),
        content: const Text("Yakin ingin menghapus produk ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Produk berhasil dihapus")));
      await _refreshProducts();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error menghapus produk: $e")));
    }
  }

  Widget buildProductCard(Map product) {
    // defensive extraction with fallbacks
    final nama = product['nama_produk']?.toString() ?? "Nama tidak tersedia";
    final harga = product['harga']?.toString() ?? "-";
    final deskripsi = (product['deskripsi']?.toString() ?? "-");
    final stok = product['stok']?.toString() ?? "-";
    final tanggal = product['tanggal_upload']?.toString() ?? "-";
    final kategori = product['nama_kategori']?.toString() ?? "-";

    final imagesRaw = product['images'];
    final List images = (imagesRaw is List) ? imagesRaw : [];

    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
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
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Rp $harga",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Deskripsi
            Text(
              deskripsi,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),

            const SizedBox(height: 10),

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
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      );
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        url,
                        width: 95,
                        height: 95,
                        fit: BoxFit.cover,
                        // keep errorBuilder to avoid runtime crashes on broken links
                        errorBuilder: (_, __, ___) => Container(
                          width: 95,
                          height: 95,
                          color: Colors.grey[300],
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
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text(
                  "Tidak ada gambar",
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

            const SizedBox(height: 10),

            // stok & kategori & tanggal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Stok: $stok", style: const TextStyle(color: Colors.blue)),
                Expanded(
                  child: Text(
                    "Kategori: $kategori",
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.purple),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),
            Text(
              "Tanggal Upload: $tanggal",
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),

            const SizedBox(height: 8),

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
                      // fallback if casting fails
                      _navigateToEditProduct(
                        Map<String, dynamic>.from(product as Map),
                      );
                    }
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  label: const Text("Edit"),
                ),
                const SizedBox(width: 6),
                TextButton.icon(
                  onPressed: () => _deleteProduct(
                    product['id_produk'] ??
                        product['id'] ??
                        product['idProduct'],
                  ),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text("Hapus"),
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
      appBar: AppBar(title: const Text("Daftar Produk"), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProduct,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (errorMessage != null)
          ? Center(child: Text("Error: $errorMessage"))
          : products.isEmpty
          ? const Center(child: Text("Tidak ada produk"))
          : RefreshIndicator(
              onRefresh: _refreshProducts,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (_, i) {
                  final item = products[i];
                  if (item is Map<String, dynamic>) {
                    return buildProductCard(item);
                  } else if (item is Map) {
                    // convert dynamic Map to proper Map<String, dynamic>
                    return buildProductCard(Map<String, dynamic>.from(item));
                  } else {
                    // unknown item type - render safe fallback
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(item.toString()),
                        subtitle: const Text("Data produk tidak standar"),
                      ),
                    );
                  }
                },
              ),
            ),
    );
  }
}
