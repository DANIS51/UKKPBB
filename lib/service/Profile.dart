import 'package:flutter/material.dart';
import 'package:ukk_danis/service/LoginService.dart';
import 'package:ukk_danis/screens/profile_update.dart';

class ProfilePage extends StatefulWidget {
  final String token;

  const ProfilePage({super.key, required this.token});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final LoginService loginService = LoginService();
  Map<String, dynamic>? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final data = await loginService.getUserProfile(widget.token);

      // DEBUG: lihat semua field yang ada di response
      print("PROFILE DATA: $data");
      print("PROFILE KEYS: ${data.keys.toList()}");

      setState(() {
        profileData = data;
        isLoading = false;
      });
    } catch (e) {
      print("Profile Load Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Background gelap sesuai tema
      backgroundColor: const Color(0xFF0F1419),

      // 2. AppBar dihapus karena sudah ada di HomePage

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1E88E5)))
          : profileData == null
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
                        "Gagal memuat profil",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Terjadi kesalahan saat memuat data profil",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: loadProfile,
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
              : RefreshIndicator(
                  color: const Color(0xFF1E88E5),
                  onRefresh: () async {
                    await loadProfile();
                  },
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Header dengan foto profil
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(30),
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
                              // FOTO PROFIL
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 4),
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.white24,
                                  backgroundImage:
                                      (profileData!["avatar"] != null &&
                                              profileData!["avatar"]
                                                  .toString()
                                                  .isNotEmpty)
                                          ? NetworkImage(profileData!["avatar"])
                                          : null,
                                  child: (profileData!["avatar"] == null ||
                                          profileData!["avatar"]
                                              .toString()
                                              .isEmpty)
                                      ? const Icon(Icons.person,
                                          size: 60, color: Colors.white)
                                      : null,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // NAMA
                              Text(
                                profileData!["nama"] ?? "Nama tidak tersedia",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 5),

                              // EMAIL
                              Text(
                                profileData!["email"] ?? "-",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // CARD INFO
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
                                  Icons.person,
                                  "Username",
                                  profileData!["username"] ?? "-",
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  height: 1,
                                  color: const Color(0xFF0F1419),
                                ),
                                const SizedBox(height: 16),
                                infoRow(
                                  Icons.verified_user,
                                  "Role",
                                  profileData!["role"] ?? "-",
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  height: 1,
                                  color: const Color(0xFF0F1419),
                                ),
                                const SizedBox(height: 16),
                                infoRow(
                                  Icons.access_time,
                                  "Dibuat",
                                  profileData!["created_at"] ?? "-",
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // TOMBOL UPDATE PROFIL
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileUpdatePage(
                                    token: widget.token,
                                    currentProfile: profileData!,
                                  ),
                                ),
                              );

                              if (result == true) {
                                loadProfile(); // refresh setelah update
                              }
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text("Update Profil"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E88E5),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // TOMBOL LOGOUT
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: const Color(0xFF1E2A38),
                                  title: const Text(
                                    "Konfirmasi Logout",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: const Text(
                                    "Apakah Anda yakin ingin keluar dari akun?",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        "Batal",
                                        style:
                                            TextStyle(color: Color(0xFF1E88E5)),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                          '/',
                                          (Route<dynamic> route) => false,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text("Logout"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.logout),
                            label: const Text("Logout"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  // WIDGET INFO
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
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
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
