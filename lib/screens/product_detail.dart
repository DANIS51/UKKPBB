import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final nama = product['nama_produk']?.toString() ?? "Tanpa Nama";
    final harga = product['harga']?.toString() ?? "0";
    final deskripsi = product['deskripsi']?.toString() ?? "Tidak ada deskripsi";
    final stok = product['stok']?.toString() ?? "0";
    final tanggal = product['tanggal_upload']?.toString() ?? "-";
    final kategori = product['nama_kategori']?.toString() ?? "-";
    final gambarUrl = product['gambar']?.toString() ?? "";
    final imagesRaw = product['images'];
    final List images = (imagesRaw is List) ? imagesRaw : [];

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Produk"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar utama
            if (gambarUrl.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    gambarUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.image_not_supported, size: 50),
              ),

            const SizedBox(height: 16),

            // Nama produk
            Text(
              nama,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),

            const SizedBox(height: 8),

            // Harga
            Text(
              "Rp $harga",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Stok & Kategori
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Stok: $stok",
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
                Text(
                  "Kategori: $kategori",
                  style: const TextStyle(fontSize: 16, color: Colors.purple),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Tanggal Upload
            Text(
              "Tanggal Upload: $tanggal",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 16),

            // Deskripsi
            const Text(
              "Deskripsi:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(deskripsi, style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 16),

            // Galeri gambar tambahan
            if (images.isNotEmpty) ...[
              const Text(
                "Galeri Gambar:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
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
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.broken_image),
                      );
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        url,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
