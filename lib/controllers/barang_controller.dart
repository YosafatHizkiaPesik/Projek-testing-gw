import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/barang.dart';
import '../utils/constants.dart';
import 'auth_controller.dart';

class BarangController with ChangeNotifier {
  List<Barang> _items = []; 
  final AuthController _authController = AuthController(); 

  List<Barang> get items => [..._items]; 

  // Fungsi untuk mengambil data barang dari server
  Future<BarangResponse> fetchBarang() async {
    try {
      final token = _authController.token;
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      // HTTP GET request
      final response = await http.get(
        Uri.parse(ApiEndpoints.BARANG),
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = BarangResponse.fromJson(json.decode(response.body));
        _items = responseData.barangs ?? [];
        notifyListeners();  
        return responseData;
      } else {
        throw Exception('Gagal mengambil data barang.');
      }
    } catch (error) {
      throw error;
    }
  }

  // Fungsi untuk merefresh data
  Future<void> refreshBarang() async {
    final newBarangs = await fetchBarang();
    _items = newBarangs.barangs ?? [];
    notifyListeners();  
  }
}
