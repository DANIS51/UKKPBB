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

  void loadProfile() async {
    try {
      final data = await loginService.getUserProfile(widget.token);

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
      appBar: AppBar(
        title: const Text("Profil Saya"),
        centerTitle: true,
        elevation: 0,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileData == null
              ? const Center(child: Text("Gagal memuat profil"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // FOTO PROFIL
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: (profileData!["avatar"] != null &&
                                profileData!["avatar"].toString().isNotEmpty)
                            ? NetworkImage(profileData!["avatar"])
                            : const AssetImage("assets/user.png")
                                as ImageProvider,
                      ),

                      const SizedBox(height: 20),

                      // NAMA
                      Text(
                        profileData!["name"] ?? "Nama tidak tersedia",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // EMAIL
                      Text(
                        profileData!["email"] ?? "-",
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),

                      const SizedBox(height: 20),

                      // CARD INFO
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              infoRow(
                                Icons.person,
                                "Username",
                                profileData!["username"] ?? "-",
                              ),
                              const Divider(),

                              infoRow(
                                Icons.verified_user,
                                "Role",
                                profileData!["role"] ?? "-",
                              ),
                              const Divider(),

                              infoRow(
                                Icons.access_time,
                                "Dibuat",
                                profileData!["created_at"] ?? "-",
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

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
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // TOMBOL LOGOUT
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/',
                              (Route<dynamic> route) => false,
                            );
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text("Logout"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  // WIDGET INFO
  Widget infoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 28),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.2,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
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
