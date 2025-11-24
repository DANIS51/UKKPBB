import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Mengambil data produk dengan nilai default jika null
    final nama = product['nama_produk']?.toString() ?? "Tanpa Nama";
    final harga = product['harga']?.toString() ?? "0";
    final deskripsi = product['deskripsi']?.toString() ?? "Tidak ada deskripsi";
    // Mengubah stok menjadi integer untuk perhitungan
    final stokValue = int.tryParse(product['stok']?.toString() ?? "0") ?? 0;
    final stok = stokValue.toString();
    final tanggal = product['tanggal_upload']?.toString() ?? "-";
    final kategori = product['nama_kategori']?.toString() ?? "-";
    final gambarUrl = product['gambar']?.toString() ?? "";
    final imagesRaw = product['images'];
    final List images = (imagesRaw is List) ? imagesRaw : [];

    return Scaffold(
      // 1. Background gelap sesuai tema BerandaPage
      backgroundColor: const Color(0xFF0F1419),
      appBar: AppBar(
        elevation: 0,
        // 2. AppBar dengan tema gelap
        backgroundColor: const Color(0xFF1E2A38),
        centerTitle: true,
        title: const Text(
          "Detail Produk",
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
            // 3. Kartu untuk gambar utama dengan desain gelap
            Container(
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
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 250,
                          color: const Color(0xFF2A3F5F),
                          child: const Icon(Icons.broken_image,
                              color: Colors.grey, size: 50),
                        ),
                      )
                    : Container(
                        height: 250,
                        width: double.infinity,
                        color: const Color(0xFF2A3F5F),
                        child: Icon(Icons.image_not_supported,
                            size: 50, color: Colors.blue[300]),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // 4. Kartu untuk informasi produk
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
                  // Nama produk
                  Text(
                    nama,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Harga
                  Text(
                    "Rp $harga",
                    style: const TextStyle(
                      fontSize: 22,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Stok & Kategori
                  Row(
                    children: [
                      // Badge stok
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
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
                              size: 16,
                              color: stokValue <= 5
                                  ? Colors.red
                                  : const Color(0xFF1E88E5),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Stok: $stok",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: stokValue <= 5
                                    ? Colors.red
                                    : const Color(0xFF1E88E5),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Badge kategori
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colors.purple.withOpacity(0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.category,
                                size: 16, color: Colors.purple),
                            const SizedBox(width: 4),
                            Text(
                              kategori,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Tanggal Upload
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 16, color: Colors.blue[300]),
                      const SizedBox(width: 4),
                      Text(
                        "Tanggal Upload: $tanggal",
                        style: TextStyle(fontSize: 14, color: Colors.blue[300]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Deskripsi
                  const Text(
                    "Deskripsi:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    deskripsi,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 5. Galeri gambar tambahan
            if (images.isNotEmpty) ...[
              // Judul galeri
              Row(
                children: [
                  const Icon(Icons.photo_library, color: Color(0xFF1E88E5)),
                  const SizedBox(width: 8),
                  const Text(
                    "Galeri Gambar:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

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
                          color: const Color(0xFF1E2A38),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color(0xFF1E88E5).withOpacity(0.3)),
                        ),
                        child:
                            const Icon(Icons.broken_image, color: Colors.grey),
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
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 120,
                            height: 120,
                            color: const Color(0xFF1E2A38),
                            child: const Icon(Icons.broken_image,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 20),

            // 6. Tombol aksi
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final waUrl = Uri.encodeFull(
                          "https://wa.me/?text=Halo, saya ingin memesan produk: ${product['nama_produk'] ?? 'Produk'}");
                      if (await canLaunch(waUrl)) {
                        await launch(waUrl);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tidak dapat membuka WhatsApp'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text("Pesan via WhatsApp"),
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
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    // Implementasi favorit
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ditambahkan ke favorit'),
                        backgroundColor: Colors.purple,
                      ),
                    );
                  },
                  icon: const Icon(Icons.favorite_border),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.purple.withOpacity(0.2),
                    foregroundColor: Colors.purple,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
