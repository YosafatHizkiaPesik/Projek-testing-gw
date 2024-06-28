import 'package:get/get.dart';
import '../models/penjualan_detail.dart';
import '../utils/constants.dart';
import 'auth_controller.dart';
import 'sales_controller.dart';
import 'customer_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PenjualanDetailController extends GetxController {
  var penjualanDetails = <PenjualanDetail>[].obs;
  var isLoading = false.obs;
  var penjualanHeader = <String, dynamic>{}.obs;

  final AuthController _authController = Get.find<AuthController>();
  final SalesController _salesController = Get.put(SalesController());
  final CustomerController _customerController = Get.put(CustomerController());

  // Mengambil data penjualan header untuk halaman edit
  Future<void> fetchPenjualanHeader(int id) async {
    isLoading(true);
    try {
      final token = _authController.token;
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      final response = await http.get(
        Uri.parse('${ApiEndpoints.PENJUALAN_HEADER}/$id/edit'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        penjualanHeader.value = json.decode(response.body);
      } else {
        Get.snackbar('Error', 'Gagal mengambil data penjualan header');
      }
    } finally {
      isLoading(false);
    }
  }

  // Mengupdate penjualan header
  Future<void> updatePenjualanHeader(int id, Map<String, dynamic> data) async {
    isLoading(true);
    try {
      final token = _authController.token;
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      var request = http.MultipartRequest(
          'POST', Uri.parse('${ApiEndpoints.PENJUALAN_HEADER}/$id'));
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['_method'] = 'PUT';

      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      final response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Penjualan header diperbarui');
        fetchPenjualanHeader(id);
      } else {
        Get.snackbar('Error', 'Gagal memperbarui penjualan header');
      }
    } finally {
      isLoading(false);
    }
  }

  // Mengambil data penjualan detail
  Future<void> fetchPenjualanDetails(int headerId) async {
    isLoading(true);
    try {
      final token = _authController.token;
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      final response = await http.get(
        Uri.parse('${ApiEndpoints.PENJUALAN_DETAIL}?penjualan_header_id=$headerId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        penjualanDetails.value = data.map((json) => PenjualanDetail.fromJson(json)).toList();
      } else {
        Get.snackbar('Error', 'Gagal mengambil data penjualan detail');
      }
    } finally {
      isLoading(false);
    }
  }

  // Menambahkan penjualan detail
  Future<void> addPenjualanDetail(Map<String, dynamic> data) async {
    isLoading(true);
    try {
      final token = _authController.token;
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      var request = http.MultipartRequest(
          'POST', Uri.parse(ApiEndpoints.PENJUALAN_DETAIL));
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      final response = await request.send();

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Penjualan detail ditambahkan');
        fetchPenjualanDetails(data['penjualan_header_id']);
      } else {
        Get.snackbar('Error', 'Gagal menambahkan penjualan detail');
      }
    } finally {
      isLoading(false);
    }
  }

  // Mengupdate penjualan detail
  Future<void> updatePenjualanDetail(int detailId, Map<String, dynamic> data) async {
    isLoading(true);
    try {
      final token = _authController.token;
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      var request = http.MultipartRequest(
          'POST', Uri.parse('${ApiEndpoints.PENJUALAN_DETAIL}/$detailId'));
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['_method'] = 'PUT';

      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      final response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Penjualan detail diperbarui');
        fetchPenjualanDetails(data['penjualan_header_id']);
      } else {
        Get.snackbar('Error', 'Gagal memperbarui penjualan detail');
      }
    } finally {
      isLoading(false);
    }
  }

  // Menghapus penjualan detail
  Future<void> deletePenjualanDetail(int detailId, int headerId) async {
    isLoading(true);
    try {
      final token = _authController.token;
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      var request = http.MultipartRequest(
          'POST', Uri.parse('${ApiEndpoints.PENJUALAN_DETAIL}/$detailId'));
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['_method'] = 'DELETE';

      final response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Penjualan detail dihapus');
        fetchPenjualanDetails(headerId);
      } else {
        Get.snackbar('Error', 'Gagal menghapus penjualan detail');
      }
    } finally {
      isLoading(false);
    }
  }

  // Mengambil data customers
  Future<List<Object>> fetchCustomers() async {
    isLoading.value = true;
    List<Object> customers = [];
    try {
      final token = _authController.token;
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      final response = await http.get(
        Uri.parse(ApiEndpoints.CUSTOMER),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body)['customers'];
        customers = data
            .map((customer) => {'id': customer['id'], 'nama': customer['nama'].toString()})
            .toList();
      } else {
        throw Exception('Gagal mengambil data customers.');
      }
    } catch (error) {
      print('Error fetching customers: $error');
    } finally {
      isLoading.value = false;
    }
    return customers;
  }

  // Mengambil data sales
  Future<List<Object>> fetchSales() async {
    isLoading.value = true;
    List<Object> sales = [];
    try {
      final token = _authController.token;
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      final response = await http.get(
        Uri.parse(ApiEndpoints.SALES),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body)['saleses'];
        sales = data
            .map((sale) => {'id': sale['id'], 'nama': sale['nama'].toString()})
            .toList();
      } else {
        throw Exception('Gagal mengambil data sales.');
      }
    } catch (error) {
      print('Error fetching sales: $error');
    } finally {
      isLoading.value = false;
    }
    return sales;
  }

  // Mengambil data awal
  Future<void> fetchInitialData() async {
    await _salesController.fetchSales();
    await _customerController.fetchCustomers();
  }
}
