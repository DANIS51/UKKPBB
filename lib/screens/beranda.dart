import 'package:flutter/material.dart';
import 'package:ukk_danis/screens/category_detail.dart';
import 'package:ukk_danis/screens/edit_store.dart'; // ← tambah import
import 'package:ukk_danis/screens/product_detail.dart';
import 'package:ukk_danis/service/login_service.dart';
import 'products.dart';

class BerandaPage extends StatefulWidget {
  final String token;
  final int userId;

  const BerandaPage({super.key, required this.token, required this.userId});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final LoginService loginService = LoginService();
  List<dynamic> products = [];
  List<dynamic> categories = [];
  Map<String, dynamic>? store; // ← tambahkan store
  bool isLoading = true;
  String? errorMessage;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final productsData = await loginService.getStoreProducts(widget.token);
      final categoriesData = await loginService.getKategori(widget.token);
      final tokoData =
          await loginService.getToko(widget.token); // ← ambil data toko

      setState(() {
        products = productsData ?? [];
        categories = categoriesData;
        store = tokoData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  List<dynamic> getFilteredProducts() {
    if (searchQuery.isEmpty) return products;
    return products
        .where((p) => p['nama_produk']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = getFilteredProducts();

    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1E88E5)))
          : RefreshIndicator(
              color: const Color(0xFF1E88E5),
              onRefresh: loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================================ HEADER ================================
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
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.person,
                                size: 32, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Selamat Datang!",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                Text("User ID: ${widget.userId}",
                                    style:
                                        const TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                          // Icon edit toko (tambah)
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            tooltip: 'Edit Toko',
                            onPressed: () async {
                              if (store == null) {
                                // jika belum ada data toko, ambil dulu
                                try {
                                  final toko =
                                      await loginService.getToko(widget.token);
                                  setState(() => store = toko);
                                } catch (_) {}
                              }
                              if (store == null) return;
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditStorePage(
                                    token: widget.token,
                                    store: store!,
                                  ),
                                ),
                              );
                              if (result == true) await loadData();
                            },
                          ),
                          // ikon keranjang tetap ada
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductsPage(token: widget.token),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.shopping_cart,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ================================ KATEGORI ================================
                    const Text("Kategori Produk",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 12),

                    categories.isEmpty
                        ? const Text("Tidak ada kategori",
                            style: TextStyle(color: Colors.white70))
                        : SizedBox(
                            height: 110,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (context, i) {
                                final c = categories[i];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            CategoryDetailPage(category: c),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 130,
                                    margin: const EdgeInsets.only(right: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E2A38),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                          color: const Color(0xFF1E88E5)
                                              .withOpacity(0.2)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1E88E5)
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Icon(Icons.category,
                                              size: 32,
                                              color: Color(0xFF1E88E5)),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          c['nama_kategori'] ?? "Kategori",
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                    const SizedBox(height: 28),

                    // ================================ SEARCH ================================
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2A38),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (q) => setState(() => searchQuery = q),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0)),
                        decoration: InputDecoration(
                          hintText: "Cari Produk...",
                          hintStyle: TextStyle(color: Colors.blue[200]),
                          prefixIcon:
                              Icon(Icons.search, color: Colors.blue[300]),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ================================ PRODUK ================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Produk Toko",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0))),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductsPage(token: widget.token),
                              ),
                            );
                          },
                          child: const Text("Lihat Semua →",
                              style: TextStyle(color: Color(0xFF1E88E5))),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    filteredProducts.isEmpty
                        ? const Center(
                            child: Text("Produk tidak ditemukan",
                                style: TextStyle(
                                    color: Color.fromARGB(179, 0, 0, 0))),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredProducts.length > 4
                                ? 4
                                : filteredProducts.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.78,
                            ),
                            itemBuilder: (context, i) {
                              final p = filteredProducts[i];
                              final imgs = p['images'] ?? [];

                              final stockValue =
                                  int.tryParse(p['stok'].toString()) ?? 0;

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ProductDetailPage(product: p),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E2A38),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4))
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                      top: Radius.circular(16)),
                                              child: Container(
                                                width: double.infinity,
                                                color: const Color(0xFF2A3F5F),
                                                child: imgs.isNotEmpty
                                                    ? Image.network(
                                                        imgs[0]['url'],
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return const Icon(
                                                              Icons
                                                                  .broken_image,
                                                              color:
                                                                  Colors.grey,
                                                              size: 50);
                                                        },
                                                      )
                                                    : Center(
                                                        child: Icon(
                                                            Icons
                                                                .image_not_supported,
                                                            size: 50,
                                                            color: Colors
                                                                .blue[300]),
                                                      ),
                                              ),
                                            ),
                                            if (stockValue <= 5 &&
                                                stockValue > 0)
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: const Text("Terbatas",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                p['nama_produk'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                "Rp ${p['harga']}",
                                                style: const TextStyle(
                                                    color: Color(0xFF4CAF50),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Stok: $stockValue",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .blue[300])),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                              0xFF1E88E5)
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: const Icon(
                                                        Icons.add_shopping_cart,
                                                        size: 16,
                                                        color:
                                                            Color(0xFF1E88E5)),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
