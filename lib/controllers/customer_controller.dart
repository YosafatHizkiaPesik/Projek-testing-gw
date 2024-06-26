import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/customer.dart';
import 'auth_controller.dart';

class CustomerController with ChangeNotifier {
  List<Customer> _customers = [];
  bool isLoading = false;
  String? errorMessage;

  final AuthController _authController = AuthController();

  List<Customer> get customers => [..._customers];

  Future<CustomerResponse> fetchCustomers() async {
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

      final response = await http.get(Uri.parse(ApiEndpoints.CUSTOMER), headers: headers);

      if (response.statusCode == 200) {
        final CustomerResponse customerResponse = CustomerResponse.fromJson(json.decode(response.body));
        _customers = customerResponse.customers ?? [];
        errorMessage = null;
        isLoading = false;
        notifyListeners();
        return customerResponse; 
      } else {
        errorMessage = 'Gagal mengambil data customer';
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

  Future<void> refreshCustomers() async {
    await fetchCustomers();
    notifyListeners();
  }
}
