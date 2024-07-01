import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import '../models/user.dart';
import '../utils/constants.dart';

class AuthController with ChangeNotifier {
  static final AuthController _instance = AuthController._internal();

  factory AuthController() {
    return _instance;
  }

  AuthController._internal();

  String? _token;
  User? _currentUser;

  String? get token => _token;
  User? get currentUser => _currentUser;

  Future<void> _saveTokenToPrefs(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userToken', token);
  }

  Future<String?> _getTokenFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  Future<void> _removeTokenFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userToken');
  }

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

  Future<String> _getDeviceImei() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Untuk Android, gunakan ID perangkat
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'Unknown'; // Untuk iOS, gunakan ID vendor
    }
    throw UnsupportedError('Platform not supported');
  }

  Future<void> login(String username, String password, String imei) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.AUTH_LOGIN),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'imei': imei,
      }),
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

  Future<void> fetchCurrentUser() async {
    if (_token == null) {
      _token = await _getTokenFromPrefs();
      if (_token == null) {
        throw Exception('Token tidak ditemukan. Pastikan Anda sudah login.');
      }
    }

    final response = await http.post(  // Menggunakan POST alih-alih GET
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

  Future<void> logout() async {
    await _removeTokenFromPrefs();
    _token = null;
    _currentUser = null;
    notifyListeners();
  }
}
