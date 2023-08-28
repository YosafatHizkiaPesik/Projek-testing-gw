import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/contstants.dart'; 
import '../models/stok.dart'; 
import 'auth_controller.dart';

class StockController with ChangeNotifier {
  List<Stock> _stocks = [];
  bool isLoading = false;
  String? errorMessage;

  final AuthController _authController = AuthController();

  List<Stock> get stocks => [..._stocks];

  Future<StockResponse> fetchStocks() async {
    isLoading = true;
    notifyListeners();

    try {
      final token = _authController.token;
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(Uri.parse(ApiEndpoints.STOK), headers: headers);

      if (response.statusCode == 200) {
        final StockResponse stockResponse = StockResponse.fromJson(json.decode(response.body));
        _stocks = stockResponse.stocks ?? [];
        errorMessage = null;
        isLoading = false;
        notifyListeners();
        return stockResponse;
      } else {
        errorMessage = 'Gagal mengambil data stok';
        throw Exception(errorMessage);
      }
    } catch (error) {
      errorMessage = error.toString();
      print("Error: $errorMessage");
      throw error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshStocks() async {
    await fetchStocks();
    notifyListeners();
  }
}
