import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String _baseUrl = 'https://learncode.biz.id/api';

  // ============================
  // LOGIN
  // ============================
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    print("LOGIN STATUS: ${response.statusCode}");
    print("LOGIN BODY: ${response.body}");

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
    }

    throw Exception("Gagal login, status code: ${response.statusCode}");
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
    final url = Uri.parse('$_baseUrl/stores/save');

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
      return jsonDecode(response.body);
    }

    throw Exception('Gagal register, status code: ${response.statusCode}');
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
  // GET KATEGORI
  // ============================
  Future<List<dynamic>> getKategori(String token) async {
    final url = Uri.parse('$_baseUrl/categories');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
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
  // CREATE TOKO
  // ============================
  Future<Map<String, dynamic>> createToko(
    String token, {
    required String namaToko,
    required String deskripsi,
    required String alamat,
    required String kontak,
  }) async {
    final url = Uri.parse('$_baseUrl/stores/save');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nama_toko': namaToko,
        'deskripsi': deskripsi,
        'alamat': alamat,
        'kontak': kontak,
      }),
    );

    print("CREATE TOKO STATUS: ${response.statusCode}");
    print("CREATE TOKO BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data['data']);
    }

    if (response.statusCode == 422) {
      final data = jsonDecode(response.body);
      throw Exception(data['errors'] ?? data['message']);
    }

    throw Exception('Gagal buat toko, status code: ${response.statusCode}');
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
}
