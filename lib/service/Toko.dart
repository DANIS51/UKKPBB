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
      // 1. Background gelap sesuai tema
      backgroundColor: const Color(0xFF0F1419),
      
      // 2. AppBar dihapus dari sini karena sudah ada di HomePage
      
      // 3. FloatingActionButton dengan tema gelap
      floatingActionButton: tokoData == null
          ? null
          : FloatingActionButton(
              onPressed: _navigateToAddStore,
              backgroundColor: const Color(0xFF1E88E5),
              child: const Icon(Icons.edit, color: Colors.white),
            ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1E88E5)))

          // ================================================
          // Jika belum punya toko
          // ================================================
          : tokoData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2A38),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1E88E5).withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.store_mall_directory,
                          size: 80,
                          color: Color(0xFF1E88E5),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Belum ada toko",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Silakan buat toko terlebih dahulu",
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey[400]),
                      ),
                      const SizedBox(height: 30),

                      // Tombol Buat Toko
                      ElevatedButton.icon(
                        onPressed: _navigateToAddStore,
                        icon: const Icon(Icons.add_business),
                        label: const Text("Buat Toko"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E88E5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
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
                      // Header dengan nama toko
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
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
                        child: Column(
                          children: [
                            const Icon(
                              Icons.store,
                              size: 50,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              tokoData!["nama_toko"] ?? "Nama Toko tidak tersedia",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              tokoData!["deskripsi"] ?? "Deskripsi tidak tersedia",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Card Informasi dengan tema gelap
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2A38),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              infoRow(
                                Icons.location_on,
                                "Alamat",
                                tokoData!["alamat"] ?? "-",
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 1,
                                color: const Color(0xFF0F1419),
                              ),
                              const SizedBox(height: 16),
                              infoRow(
                                Icons.phone,
                                "Kontak",
                                tokoData!["kontak"]?.toString() ?? "-",
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 1,
                                color: const Color(0xFF0F1419),
                              ),
                              const SizedBox(height: 16),
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
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF1E88E5).withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 24,
            color: const Color(0xFF1E88E5),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}