import 'package:flutter/material.dart';
import 'package:ukk_danis/service/login_service.dart';
import 'package:ukk_danis/screens/products.dart';

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
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final productsData = await loginService.getStoreProducts(widget.token);
      final categoriesData = await loginService.getKategori(widget.token);

      setState(() {
        products = productsData ?? [];
        categories = categoriesData;
        isLoading = false;
      });
    } catch (e) {
      if (e.toString().contains('404')) {
        setState(() {
          products = [];
          categories = [];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          "Beranda",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text("Error: $errorMessage"))
              : RefreshIndicator(
                  onRefresh: loadData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HEADER CARD ================
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF6B4EFF),
                                Color(0xFF9A70FF),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.shade200,
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white24,
                                child: Icon(
                                  Icons.person,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Selamat Datang!",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "User ID: ${widget.userId}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // KATEGORI TITLE
                        const Text(
                          "Kategori Produk",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // KATEGORI LIST ==================
                        categories.isEmpty
                            ? const Text("Tidak ada kategori")
                            : SizedBox(
                                height: 110,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  itemBuilder: (context, i) {
                                    final c = categories[i];
                                    return Container(
                                      width: 130,
                                      margin: const EdgeInsets.only(right: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFEDE7FF),
                                            Color(0xFFD6C7FF),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.purple.shade100,
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.category,
                                            size: 32,
                                            color: Colors.deepPurple,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            c['nama_kategori'] ?? "Kategori",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),

                        const SizedBox(height: 28),

                        // PRODUK TITLE ==================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Produk Toko",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
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
                              child: const Text("Lihat Semua →"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // PRODUK GRID ==================
                        products.isEmpty
                            ? Column(
                                children: const [
                                  Icon(Icons.inventory_2_outlined,
                                      size: 50, color: Colors.grey),
                                  SizedBox(height: 10),
                                  Text(
                                    "Belum ada produk",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    products.length > 4 ? 4 : products.length,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                  childAspectRatio: 0.78,
                                ),
                                itemBuilder: (context, i) {
                                  final p = products[i];
                                  final List imgs = p['images'] ?? [];

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        // IMAGE
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                            child: imgs.isNotEmpty
                                                ? Image.network(
                                                    imgs[0]['url'],
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(
                                                    color: Colors.grey.shade300,
                                                    child: const Icon(
                                                      Icons.image_not_supported,
                                                      size: 50,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                          ),
                                        ),

                                        // TEXT
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                p['nama_produk'] ?? "Produk",
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "Rp ${p['harga']}",
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "Stok: ${p['stok']}",
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
