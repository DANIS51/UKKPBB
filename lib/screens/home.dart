import 'package:flutter/material.dart';
import 'package:ukk_danis/screens/beranda.dart';
import 'package:ukk_danis/service/Toko.dart';
import 'package:ukk_danis/screens/products.dart';
import 'package:ukk_danis/screens/kategori.dart';
import 'package:ukk_danis/service/Profile.dart';

class HomePage extends StatefulWidget {
  final String token;
  final int userId;

  const HomePage({super.key, required this.token, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Pastikan semua halaman menerima token dan userId bila perlu
    _pages = [
      BerandaPage(token: widget.token, userId: widget.userId),
      TokoPage(token: widget.token),
      ProductsPage(token: widget.token),
      KategoriPage(token: widget.token),
      ProfilePage(token: widget.token),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Background gelap sesuai tema
      backgroundColor: const Color(0xFF0F1419),
      
      // 2. AppBar dengan tema gelap
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1E2A38),
        centerTitle: true,
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // Ikon di AppBar dibuat putih agar kontras
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      // 3. BottomNavigationBar dengan tema gelap
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E2A38),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent, // Transparan agar menampilkan warna container
          selectedItemColor: const Color(0xFF1E88E5),
          unselectedItemColor: Colors.white70,
          elevation: 0, // Menghilangkan shadow default

          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined),
              activeIcon: Icon(Icons.store),
              label: 'Toko',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Produk',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              activeIcon: Icon(Icons.category),
              label: 'Kategori',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // 4. Fungsi untuk mendapatkan judul AppBar berdasarkan halaman aktif
  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Beranda';
      case 1:
        return 'Toko';
      case 2:
        return 'Produk';
      case 3:
        return 'Kategori';
      case 4:
        return 'Profile';
      default:
        return 'Aplikasi';
    }
  }
}