import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/contstants.dart'; 
import '../models/detail_penjualan_customer.dart'; 
import 'auth_controller.dart';

class DetailPenjualanCustomerController with ChangeNotifier {
  List<DetailPenjualanCustomer> _detailPenjualan = [];
  bool isLoading = false;
  String? errorMessage;

  final AuthController _authController = AuthController();

  List<DetailPenjualanCustomer> get detailPenjualan => [..._detailPenjualan];

  Future<DetailPenjualanCustomer> fetchDetailPenjualan() async {
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

      final response = await http.get(Uri.parse(ApiEndpoints.DETAIL_PENJUALAN_CUSTOMER), headers: headers);

      if (response.statusCode == 200) {
        final DetailPenjualanCustomer detailPenjualanResponse = DetailPenjualanCustomer.fromJson(json.decode(response.body));
        _detailPenjualan = [detailPenjualanResponse];
        errorMessage = null;
        isLoading = false;
        notifyListeners();
        return detailPenjualanResponse;
      } else {
        errorMessage = 'Gagal mengambil data penjualan';
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

  Future<void> refreshDetailPenjualan() async {
    await fetchDetailPenjualan();
    notifyListeners();
  }
}
