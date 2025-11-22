import 'package:flutter/material.dart';

class CategoryDetailPage extends StatelessWidget {
  final Map<String, dynamic> category;

  const CategoryDetailPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final nama = category['nama_kategori']?.toString() ?? "Tidak ada nama";
    final deskripsi = category['deskripsi']?.toString() ?? "Deskripsi tidak tersedia";
    final gambarUrl = category['gambar']?.toString() ?? "";

    return Scaffold(
      // 1. Background gelap sesuai tema
      backgroundColor: const Color(0xFF0F1419),
      appBar: AppBar(
        elevation: 0,
        // 2. AppBar dengan tema gelap
        backgroundColor: const Color(0xFF1E2A38),
        centerTitle: true,
        title: const Text(
          "Detail Kategori",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // Ikon di AppBar dibuat putih agar kontras
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 3. Kartu untuk gambar kategori
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2A38),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: gambarUrl.isNotEmpty
                    ? Image.network(
                        gambarUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFF2A3F5F),
                          child: const Icon(Icons.category, size: 80, color: Colors.grey),
                        ),
                      )
                    : Container(
                        color: const Color(0xFF2A3F5F),
                        child: const Icon(Icons.category, size: 80, color: Colors.grey),
                      ),
              ),
            ),

            const SizedBox(height: 24),

            // 4. Kartu untuk informasi kategori
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2A38),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 5. Nama kategori dengan ikon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E88E5).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.category, size: 28, color: Color(0xFF1E88E5)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          nama,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 6. Bagian deskripsi
                  Row(
                    children: [
                      const Icon(Icons.description, color: Color(0xFF1E88E5), size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        "Deskripsi:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    deskripsi,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 7. Bagian informasi tambahan
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F1419),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.inventory, color: Color(0xFF4CAF50), size: 24),
                              const SizedBox(height: 8),
                              const Text(
                                "Total Produk",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${category['jumlah_produk'] ?? 0}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F1419),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.calendar_today, color: Color(0xFF1E88E5), size: 24),
                              const SizedBox(height: 8),
                              const Text(
                                "Dibuat",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                category['created_at']?.toString().substring(0, 10) ?? "-",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 8. Tombol aksi
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigasi ke halaman produk kategori
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Kembali ke Beranda"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}