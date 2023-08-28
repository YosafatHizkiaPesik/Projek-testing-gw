import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/contstants.dart';

class AuthController with ChangeNotifier {
  // Implementasi Singleton
  static final AuthController _instance = AuthController._internal();

  // Factory method untuk mengembalikan instance
  factory AuthController() {
    return _instance;
  }

  // Constructor internal untuk Singleton
  AuthController._internal();

  // Variabel untuk menyimpan token dan data pengguna saat ini
  String? _token;
  User? _currentUser;

  // Getter untuk mendapatkan token saat ini
  String? get token => _token;

  // Getter untuk mendapatkan data pengguna saat ini
  User? get currentUser => _currentUser;

  // Simpan token ke SharedPreferences
  Future<void> _saveTokenToPrefs(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userToken', token);
  }

  // Ambil token dari SharedPreferences
  Future<String?> _getTokenFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  // Hapus token dari SharedPreferences
  Future<void> _removeTokenFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userToken');
  }

  // Cek apakah pengguna sudah login dengan melihat adanya token
  Future<bool> isUserLoggedIn() async {
    _token = await _getTokenFromPrefs();
    if (_token != null) {
      try {
        await fetchCurrentUser();
        return true;
      } catch (error) {
        return false;
      }
    }
    return false;
  }

  // Melakukan proses login dan mengambil token jika sukses
  Future<void> login(String username, String password, String imei) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.AUTH_LOGIN),
      headers: {'Accept': 'application/json'},
      body: {'username': username, 'password': password, 'imei': imei},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData.containsKey('access_token')) {
        _token = responseData['access_token'];
        await _saveTokenToPrefs(_token!);
        await fetchCurrentUser();
      } else {
        throw Exception('Token tidak ditemukan dalam respons.');
      }
    } else {
      throw Exception('Gagal login. Silakan coba lagi.');
    }
  }

  // Mengambil data pengguna saat ini berdasarkan token
  Future<void> fetchCurrentUser() async {
    if (_token == null) {
      _token = await _getTokenFromPrefs();
      if (_token == null) {
        throw Exception('Token tidak ditemukan. Pastikan Anda sudah login.');
      }
    }

    final response = await http.post(
      Uri.parse(ApiEndpoints.AUTH_ME),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _currentUser = User.fromJson(responseData);
      notifyListeners();
    } else {
      throw Exception('Gagal mendapatkan data pengguna saat ini.');
    }
  }

  // Melakukan logout dan menghapus token serta data pengguna saat ini
  Future<void> logout() async {
    await _removeTokenFromPrefs();
    _token = null;
    _currentUser = null;
    notifyListeners();
  }
}
