import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/sales.dart';
import '../utils/constants.dart';
import 'auth_controller.dart';
import 'dart:developer';

class SalesController with ChangeNotifier {
  List<Sales> _salesList = [];
  bool isLoading = false;
  String? errorMessage;

  final AuthController _authController = AuthController();

  List<Sales> get salesList => [..._salesList];

  Future<List<Sales>> fetchSales() async {
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

      final response = await http.get(Uri.parse(ApiEndpoints.PENJUALAN_HEADER), headers: headers);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        _salesList = data.map((item) => Sales.fromJson(item)).toList();
        errorMessage = null;
      } else {
        // errorMessage = 'Gagal mengambil data sales';
        // throw Exception(errorMessage);
      }
    } catch (error) {
      errorMessage = error.toString();
      print("Error: $errorMessage");
      throw error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return _salesList;
  }

  Future<void> refreshSales() async {
    await fetchSales();
    notifyListeners();
  }
}
