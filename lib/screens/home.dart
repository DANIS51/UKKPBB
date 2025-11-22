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
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Toko',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Kategori',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
