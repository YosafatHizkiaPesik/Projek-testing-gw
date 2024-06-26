import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class AuthController extends GetxController {
  static final AuthController _instance = AuthController._internal();
  final Dio _dio = Dio(); // Membuat instance Dio

  factory AuthController() {
    return _instance;
  }

  AuthController._internal() {
    _dio.options.baseUrl = BASE_API_URL; // Menggunakan BASE_API_URL
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer ${_token.value}';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        return handler.next(e);
      }
    ));
  }

  var _token = ''.obs;
  var _currentUser = Rxn<User>();

  String? get token => _token.value;
  User? get currentUser => _currentUser.value;

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
    _token.value = await _getTokenFromPrefs() ?? '';
    if (_token.value.isNotEmpty) {
      try {
        await fetchCurrentUser();
        return true;
      } catch (error) {
        return false;
      }
    }
    return false;
  }

  Future<void> login(String username, String password, String imei) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.AUTH_LOGIN,
        data: {'username': username, 'password': password, 'imei': imei},
      );

      if (response.statusCode == 200 && response.data.containsKey('access_token')) {
        _token.value = response.data['access_token'];
        await _saveTokenToPrefs(_token.value);
        await fetchCurrentUser();
      } else {
        throw Exception('Token tidak ditemukan dalam respons.');
      }
    } catch (e) {
      throw Exception('Gagal login. Silakan coba lagi. ${e.toString()}');
    }
  }

  Future<void> fetchCurrentUser() async {
    try {
      final response = await _dio.post(ApiEndpoints.AUTH_ME); // Diubah ke POST

      if (response.statusCode == 200) {
        _currentUser.value = User.fromJson(response.data);
      } else {
        throw Exception('Gagal mendapatkan data pengguna saat ini.');
      }
    } catch (e) {
      throw Exception('Gagal mendapatkan data pengguna: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    await _removeTokenFromPrefs();
    _token.value = '';
    _currentUser.value = null;
  }
}
