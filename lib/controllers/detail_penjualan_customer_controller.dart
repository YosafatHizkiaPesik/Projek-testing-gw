import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart'; 
import '../models/detail_penjualan_customer.dart'; 
import 'auth_controller.dart';

class DetailPenjualanCustomerController with ChangeNotifier {
  DetailPenjualanCustomer? _detailPenjualanCustomer;
  bool isLoading = false;
  String? errorMessage;

  final AuthController _authController = AuthController();

  DetailPenjualanCustomer? get detailPenjualanCustomer => _detailPenjualanCustomer;

  Future<void> fetchDetailPenjualanCustomer({
    required String cabangId,
    required String customerId,
    required String barangId,
    required String awalTanggal,
    required String akhirTanggal,
  }) async {
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

      final queryParameters = {
        'filter_clicked': 'true',
        'cabang_id': cabangId,
        'customer_id': customerId,
        'barang_id': barangId,
        'awal_tanggal': awalTanggal,
        'akhir_tanggal': akhirTanggal,
      };

      final uri = Uri.parse(ApiEndpoints.DETAIL_PENJUALAN_CUSTOMER).replace(queryParameters: queryParameters);
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final DetailPenjualanCustomer detailPenjualanResponse = DetailPenjualanCustomer.fromJson(json.decode(response.body));
        _detailPenjualanCustomer = detailPenjualanResponse;
        errorMessage = null;
        isLoading = false;
        notifyListeners();
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

  Future<void> refreshDetailPenjualanCustomer({
    required String cabangId,
    required String customerId,
    required String barangId,
    required String awalTanggal,
    required String akhirTanggal,
  }) async {
    await fetchDetailPenjualanCustomer(
      cabangId: cabangId,
      customerId: customerId,
      barangId: barangId,
      awalTanggal: awalTanggal,
      akhirTanggal: akhirTanggal,
    );
    notifyListeners();
  }
}
