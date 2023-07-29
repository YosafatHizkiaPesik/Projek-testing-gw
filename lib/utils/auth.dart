import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dwijaya_sales_app/models/user.dart'; // Pastikan path-nya benar

class AuthService {
  // URL untuk endpoint API login Anda
  final String loginUrl = "https://apidev.dwijayagrup.id/api/auth/login";

  // Login dengan username dan password
  Future<User?> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      body: json.encode({"username": username, "password": password}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      // Simpan data user
      final user = User.fromJson(json.decode(response.body));

      // Simpan token atau data lain yang diperlukan untuk otentikasi di masa depan
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', response.body);

      return user;
    } else {
      // Tangani kesalahan jika login gagal
      return null;
    }
  }

  // Cek apakah pengguna sudah login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userData') != null;
  }

  // Logika logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData'); // Hapus data pengguna yang disimpan
    // Lakukan tindakan logout lainnya jika diperlukan
  }

  // Dapatkan data pengguna saat ini (jika ada)
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('userData');
    if (userData != null) {
      return User.fromJson(json.decode(userData));
    } else {
      return null;
    }
  }
}
