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
  // DELETE PRODUCT (try multiple patterns to avoid 405)
  // ============================
  Future<void> deleteProduct(String token, int productId) async {
    final urlWithId = Uri.parse('$_baseUrl/stores/products/$productId');
    final urlNoId = Uri.parse('$_baseUrl/stores/products');
    final urlDelete = Uri.parse('$_baseUrl/stores/products/delete');
    final urlIdDelete =
        Uri.parse('$_baseUrl/stores/products/$productId/delete');

    String encodeForm(Map<String, String> m) => m.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final baseHeadersForm = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final baseHeadersJson = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    http.Response response;

    // 1) POST to /stores/products/{id} with _method=DELETE as form (common Laravel)
    response = await http.post(
      urlWithId,
      headers: baseHeadersForm,
      body: encodeForm({'_method': 'DELETE'}),
    );
    print("DELETE TRY 1 STATUS: ${response.statusCode}");
    print("DELETE TRY 1 BODY: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 204) return;

    response = await http.post(
      urlWithId,
      headers: baseHeadersJson,
      body: jsonEncode({'_method': 'DELETE'}),
    );
    print("DELETE TRY 2 STATUS: ${response.statusCode}");
    print("DELETE TRY 2 BODY: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 204) return;

    // 3) POST to /stores/products with form {id}
    response = await http.post(
      urlNoId,
      headers: baseHeadersForm,
      body: encodeForm({'id': productId.toString()}),
    );
    print("DELETE TRY 3 STATUS: ${response.statusCode}");
    print("DELETE TRY 3 BODY: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 204) return;

    response = await http.post(
      urlNoId,
      headers: baseHeadersForm,
      body: encodeForm({'_method': 'DELETE', 'id': productId.toString()}),
    );
    print("DELETE TRY 4 STATUS: ${response.statusCode}");
    print("DELETE TRY 4 BODY: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 204) return;

    response = await http.post(
      urlDelete,
      headers: baseHeadersJson,
      body: jsonEncode({'id': productId}),
    );
    print("DELETE TRY 5 STATUS: ${response.statusCode}");
    print("DELETE TRY 5 BODY: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 204) return;

    response = await http.post(
      urlIdDelete,
      headers: baseHeadersForm,
      body: encodeForm({'_method': 'DELETE'}),
    );
    print("DELETE TRY 6 STATUS: ${response.statusCode}");
    print("DELETE TRY 6 BODY: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 204) return;

    throw Exception('Gagal hapus produk, status code: ${response.statusCode}');
  }

  // ============================
  // UPDATE STORE / EDIT TOKO
  // Endpoint: POST /stores/save
  // ============================
  Future<Map<String, dynamic>> updateStore(
    String token, {
    required int storeId,
    required String namaToko,
    String? alamat,
    String? kontak,
    String? deskripsi,
  }) async {
    final url = Uri.parse('$_baseUrl/stores/save');

    final body = {
      'id_toko': storeId.toString(),
      'nama_toko': namaToko,
      if (alamat != null) 'alamat': alamat,
      if (kontak != null) 'kontak': kontak,
      if (deskripsi != null) 'deskripsi': deskripsi,
    };

    final encodedBody = body.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: encodedBody,
    );

    print("UPDATE STORE STATUS: ${response.statusCode}");
    print("UPDATE STORE BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data['data'] ?? data);
    }

    if (response.statusCode == 422) {
      final data = jsonDecode(response.body);
      throw Exception(data['errors'] ?? data['message']);
    }

    throw Exception('Gagal update toko, status code: ${response.statusCode}');
  }
}
