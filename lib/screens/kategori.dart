import 'package:flutter/material.dart';
import 'package:ukk_danis/service/login_service.dart';

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
      appBar: AppBar(
        title: const Text('Kategori'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())

          : errorMessage != null
              ? Center(
                  child: Text(
                    "Error: $errorMessage",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                )

              : categories == null || categories!.isEmpty
                  ? const Center(
                      child: Text(
                        "Tidak ada kategori",
                        style: TextStyle(fontSize: 16),
                      ),
                    )

                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: categories!.length,
                      itemBuilder: (context, index) {
                        final category = categories![index];

                        final nama = category['nama_kategori'] ?? "Tidak ada nama";
                        final deskripsi =
                            category['deskripsi'] ?? "Deskripsi tidak tersedia";

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nama,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  deskripsi,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
