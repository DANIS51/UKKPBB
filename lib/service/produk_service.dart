import 'dart:convert';
import 'package:http/http.dart' as http;

class ProdukService {
  final String _baseUrl = 'https://learncode.biz.id/api';

  // ============================
  // GET PRODUK
  // ============================
  Future<List<dynamic>> getProduk(String token) async {
    final url = Uri.parse('$_baseUrl/products');

    final headers = {'Content-Type': 'application/json'};
    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(url, headers: headers);

    print("PRODUK STATUS: ${response.statusCode}");
    print("PRODUK BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<dynamic>.from(data['data']);
    }

    throw Exception(
      'Gagal mengambil data produk, status code: ${response.statusCode}',
    );
  }

  // ============================
  // ADD PRODUCT
  // ============================
  Future<Map<String, dynamic>> addProduct(
    String token, {
    required String namaProduk,
    required int harga,
    required String deskripsi,
    required int stok,
    required int kategoriId,
  }) async {
    final url = Uri.parse('$_baseUrl/products/save');

    final body = {
      'nama_produk': namaProduk,
      'harga': harga.toString(),
      'deskripsi': deskripsi,
      'stok': stok.toString(),
      'id_kategori': kategoriId.toString(),
    };

    final encodedBody = body.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
      },
      body: encodedBody,
    );

    print("ADD PRODUCT STATUS: ${response.statusCode}");
    print("ADD PRODUCT BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data['data']);
    }

    if (response.statusCode == 422) {
      final data = jsonDecode(response.body);
      throw Exception(data['errors'] ?? data['message']);
    }

    throw Exception('Gagal tambah produk, status code: ${response.statusCode}');
  }

  // ============================
  // UPDATE PRODUCT
  // ============================
  Future<Map<String, dynamic>> updateProduct(
    String token,
    int productId, {
    required String namaProduk,
    required int harga,
    required String deskripsi,
    required int stok,
    List<String>? images,
  }) async {
    final url = Uri.parse('$_baseUrl/product/save');

    final body = {
      'id_produk': productId.toString(),
      'nama_produk': namaProduk,
      'harga': harga.toString(),
      'deskripsi': deskripsi,
      'stok': stok.toString(),
      if (images != null) 'images': images.join(','),
    };

    final encodedBody = body.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
      },
      body: encodedBody,
    );

    print("UPDATE PRODUCT STATUS: ${response.statusCode}");
    print("UPDATE PRODUCT BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data['data']);
    }

    if (response.statusCode == 422) {
      final data = jsonDecode(response.body);
      throw Exception(data['errors'] ?? data['message']);
    }

    throw Exception('Gagal update produk, status code: ${response.statusCode}');
  }

  // ============================
  // DELETE PRODUCT
  // ============================
  Future<void> deleteProduct(String token, int productId) async {
    final url = Uri.parse('$_baseUrl/products/$productId/delete');

    final body = {'id_produk': productId.toString()};

    final encodedBody = body.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
      },
      body: encodedBody,
    );

    print("DELETE PRODUCT STATUS: ${response.statusCode}");
    print("DELETE PRODUCT BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }

    throw Exception('Gagal hapus produk, status code: ${response.statusCode}');
  }
}
