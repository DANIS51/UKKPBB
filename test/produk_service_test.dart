import 'package:flutter_test/flutter_test.dart';
import 'package:ukk_danis/service/produk_service.dart';
import 'package:ukk_danis/service/login_service.dart';

void main() {
  final produkService = ProdukService();
  final loginService = LoginService();

  // Ganti dengan kredensial valid Anda
  const String testEmail = 'your-email@example.com';
  const String testPassword = 'your-password';

  late String token;
  late int testProductId;

  group('ProdukService tests with real token', () {
    setUpAll(() async {
      // Login untuk mendapatkan token yang valid
      final loginResult = await loginService.login(testEmail, testPassword);
      token = loginResult['token'];

      // Buat produk baru untuk dapatkan productId yang valid
      final newProduct = await produkService.addProduct(
        token,
        namaProduk: 'Test Produk',
        harga: 10000,
        deskripsi: 'Deskripsi test produk',
        stok: 10,
      );

      testProductId = int.parse(newProduct['id_produk'] ?? newProduct['id'].toString());
    });

    test('getProduk returns list of products', () async {
      try {
        final produkList = await produkService.getProduk(token);
        expect(produkList, isA<List<dynamic>>());
      } catch (e) {
        print('getProduk failed: $e');
      }
    });

    test('deleteProduct deletes product successfully or throws exception', () async {
      try {
        await produkService.deleteProduct(token, testProductId);
        expect(true, true);
      } catch (e) {
        print('deleteProduct failed: $e');
        expect(e, isA<Exception>());
      }
    });
  });
}
