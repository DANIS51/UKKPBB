import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String _baseUrl = 'https://learncode.biz.id/api';

  // ============================
  // LOGIN
  // ============================
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'username': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        return {
          'token': data['token'],
          'userId': data['data']['id_user'].toString(),
          'username': data['data']['username'],
        };
      }

      throw Exception(data['message'] ?? 'Login gagal');
    } else {
      // Decode body untuk mendapatkan pesan error jika ada
      try {
        final data = jsonDecode(response.body);
        final message = data['message'] ?? 'Login gagal';
        if (response.statusCode == 401) {
          throw Exception("Username atau password salah");
        }
        throw Exception(message);
      } catch (e) {
        // Jika gagal decode, gunakan status code
        if (response.statusCode == 401) {
          throw Exception("Username atau password salah");
        }
        throw Exception("Gagal login, status code: ${response.statusCode}");
      }
    }
  }

  // ============================
  // GET PROFILE
  // ============================
  Future<Map<String, dynamic>> getUserProfile(String token) async {
    final url = Uri.parse('$_baseUrl/profile');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("PROFILE STATUS: ${response.statusCode}");
    print("PROFILE BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    }

    throw Exception(
      'Gagal mengambil data user, status code: ${response.statusCode}',
    );
  }

  // ============================
  // REGISTER
  // ============================
  Future<Map<String, dynamic>> register(
    String nama,
    String username,
    int kontak,
    String password,
  ) async {
    final url = Uri.parse('$_baseUrl/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': nama,
        'username': username,
        'kontak': kontak,
        'password': password,
      }),
    );

    print("REGISTER STATUS: ${response.statusCode}");
    print("REGISTER BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body)['data'];
    }

    if (response.statusCode == 422) {
      final data = jsonDecode(response.body);
      throw Exception(data['errors'] ?? data['message']);
    }

    throw Exception('Gagal registrasi, status code: ${response.statusCode}');
  }

  // ============================
  // GET TOKO
  // ============================
  Future<Map<String, dynamic>> getToko(String token) async {
    final url = Uri.parse('$_baseUrl/stores');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("TOKO STATUS: ${response.statusCode}");
    print("TOKO BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data['data']);
    }

    throw Exception(
      'Gagal mengambil data toko, status code: ${response.statusCode}',
    );
  }

  // ============================
  // GET PRODUK
  // ============================
  Future<List<dynamic>> getProduk(String token) async {
    final url = Uri.parse('$_baseUrl/products');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

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
  // GET STORE PRODUCTS
  // ============================
  Future<List<dynamic>> getStoreProducts(String token) async {
    final url = Uri.parse('$_baseUrl/stores/products');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("STORE PRODUCTS STATUS: ${response.statusCode}");
    print("STORE PRODUCTS BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<dynamic>.from(data['data']['produk']);
    }

    throw Exception(
      'Gagal mengambil data produk toko, status code: ${response.statusCode}',
    );
  }

  // ============================
  // GET KATEGORI
  // ============================
  Future<List<dynamic>> getKategori(String token) async {
    final url = Uri.parse('$_baseUrl/categories');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("KATEGORI STATUS: ${response.statusCode}");
    print("KATEGORI BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<dynamic>.from(data['data']);
    }

    throw Exception(
      'Gagal mengambil data kategori, status code: ${response.statusCode}',
    );
  }

  // ============================
  // UPDATE PROFILE
  // ============================
  Future<Map<String, dynamic>> updateProfile(
    String token, {
    required String nama,
    required String username,
    required String kontak,
  }) async {
    final url = Uri.parse('$_baseUrl/profile/update');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'nama': nama, 'username': username, 'kontak': kontak}),
    );

    print("UPDATE STATUS: ${response.statusCode}");
    print("UPDATE BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data['data']);
    }

    if (response.statusCode == 422) {
      final data = jsonDecode(response.body);
      throw Exception(data['errors'] ?? data['message']);
    }

    throw Exception(
      'Gagal update profile, status code: ${response.statusCode}',
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
    List<String>? images,
  }) async {
    final url = Uri.parse('$_baseUrl/stores/products');

    final body = {
      'nama_produk': namaProduk,
      'harga': harga.toString(),
      'deskripsi': deskripsi,
      'stok': stok.toString(),
      'images': images?.join(',') ?? '',
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
    final url = Uri.parse('$_baseUrl/stores/products/$productId');

    final body = {
      'nama_produk': namaProduk,
      'harga': harga,
      'deskripsi': deskripsi,
      'stok': stok,
      'images': images ?? [],
    };

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
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
    final url = Uri.parse('$_baseUrl/stores/products/$productId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("DELETE PRODUCT STATUS: ${response.statusCode}");
    print("DELETE PRODUCT BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }

    throw Exception('Gagal hapus produk, status code: ${response.statusCode}');
  }
}
