import 'package:flutter/material.dart';
import 'package:ukk_danis/service/LoginService.dart';
import 'package:ukk_danis/screens/add_store.dart';

class TokoPage extends StatefulWidget {
  final String token;

  const TokoPage({super.key, required this.token});

  @override
  State<TokoPage> createState() => _TokoPageState();
}

class _TokoPageState extends State<TokoPage> {
  final LoginService loginService = LoginService();
  Map<String, dynamic>? tokoData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadToko();
  }

  void loadToko() async {
    try {
      final data = await loginService.getToko(widget.token);
      setState(() {
        tokoData = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  void _navigateToAddStore() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddStorePage(token: widget.token),
      ),
    );
    loadToko(); // Refresh setelah membuat toko
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toko Saya"),
        centerTitle: true,
      ),

      floatingActionButton: tokoData == null
          ? null
          : FloatingActionButton(
              onPressed: _navigateToAddStore,
              child: const Icon(Icons.edit),
            ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())

          // ================================================
          // Jika belum punya toko
          // ================================================
          : tokoData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.store_mall_directory,
                          size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        "Belum ada toko",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text("Silakan buat toko terlebih dahulu"),
                      const SizedBox(height: 20),

                      // Tombol Buat Toko
                      ElevatedButton.icon(
                        onPressed: _navigateToAddStore,
                        icon: const Icon(Icons.add_business),
                        label: const Text("Buat Toko"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )
                    ],
                  ),
                )

              // ================================================
              // Jika toko sudah ada
              // ================================================
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Nama Toko
                      Text(
                        tokoData!["nama_toko"] ?? "Nama Toko tidak tersedia",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Deskripsi
                      Text(
                        tokoData!["deskripsi"] ?? "Deskripsi tidak tersedia",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Card Informasi
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              infoRow(
                                Icons.location_on,
                                "Alamat",
                                tokoData!["alamat"] ?? "-",
                              ),
                              const Divider(),
                              infoRow(
                                Icons.phone,
                                "Kontak",
                                tokoData!["kontak"]?.toString() ?? "-",
                              ),
                              const Divider(),
                              infoRow(
                                Icons.calendar_today,
                                "Dibuat",
                                tokoData!["created_at"] ?? "-",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget infoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 28, color: Colors.deepPurple),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
