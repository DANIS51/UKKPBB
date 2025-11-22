import 'package:flutter/material.dart';
import 'package:ukk_danis/service/login_service.dart';
import 'package:ukk_danis/screens/category_detail.dart';

class KategoriPage extends StatefulWidget {
  final String token;

  const KategoriPage({super.key, required this.token});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  final LoginService loginService = LoginService();
  List<dynamic>? categories;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final data = await loginService.getKategori(widget.token);

      if (!mounted) return;

      setState(() {
        categories = data ?? [];
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Background gelap sesuai tema
      backgroundColor: const Color(0xFF0F1419),
      
      // 2. AppBar dihapus dari sini karena sudah ada di HomePage
      
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1E88E5)))
          : RefreshIndicator(
              color: const Color(0xFF1E88E5),
              onRefresh: loadCategories,
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
                            onPressed: loadCategories,
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
                  : categories == null || categories!.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.category_outlined,
                                size: 80,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Tidak ada kategori",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Belum ada kategori yang tersedia",
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
                          itemCount: categories!.length,
                          itemBuilder: (context, index) {
                            final category = categories![index];
                            final nama = category['nama_kategori'] ?? "Tidak ada nama";
                            final deskripsi = category['deskripsi'] ?? "Deskripsi tidak tersedia";

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CategoryDetailPage(category: category),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(20),
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
                                child: Row(
                                  children: [
                                    // 3. Ikon kategori dengan background
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1E88E5).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.category,
                                        size: 28,
                                        color: Color(0xFF1E88E5),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            nama,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            deskripsi,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[400],
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // 4. Ikon panah
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.grey[400],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
    );
  }
}