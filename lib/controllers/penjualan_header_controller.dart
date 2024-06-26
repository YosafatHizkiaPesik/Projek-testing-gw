import 'package:get/get.dart';
import '../models/penjualan_header.dart';
import '../utils/constants.dart';
import 'auth_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class PenjualanHeaderController extends GetxController {
  var penjualanHeadersNotSent = <PenjualanHeader>[].obs;
  var penjualanHeadersSent = <PenjualanHeader>[].obs;
  var isLoading = false.obs;
  var filterSales = ''.obs;
  var filterCustomer = ''.obs;
  var filterBarang = ''.obs;
  var filterStartDate = ''.obs;
  var filterEndDate = ''.obs;
  var searchQuery = ''.obs;

  final AuthController _authController = Get.find<AuthController>();

  // Fungsi untuk mendapatkan akhir bulan dari tanggal tertentu
  String _getEndOfMonth(String date) {
    DateTime parsedDate = DateTime.parse(date);
    DateTime lastDayOfMonth = DateTime(parsedDate.year, parsedDate.month + 1, 0);
    return DateFormat('yyyy-MM-dd').format(lastDayOfMonth);
  }

  // Fungsi untuk mengambil data penjualan header berdasarkan status dan filter
  Future<void> fetchPenjualanHeaders(String status) async {
    isLoading.value = true;
    try {
      final token = _authController.token;
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      // Menggunakan parameter dengan nilai default "all" jika kosong
      String salesId = filterSales.value.isEmpty ? "all" : filterSales.value;
      String customerId = filterCustomer.value.isEmpty ? "all" : filterCustomer.value;
      String barangId = filterBarang.value.isEmpty ? "all" : filterBarang.value;
      String startDate = "2023-01-01";
      String endDate = _getEndOfMonth(DateFormat('yyyy-MM-dd').format(DateTime.now()));

      final response = await http.get(
        Uri.parse('${ApiEndpoints.PENJUALAN_HEADER}?status_kirim=$status&filter_clicked=true&cabang_id=all&sales_id=$salesId&customer_id=$customerId&barang_id=$barangId&awal_tanggal=$startDate&akhir_tanggal=$endDate'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body)['penjualan_headers'];
        if (status == 'not_sent') {
          penjualanHeadersNotSent.value =
              data.map((item) => PenjualanHeader.fromJson(item)).toList();
        } else if (status == 'sent') {
          penjualanHeadersSent.value =
              data.map((item) => PenjualanHeader.fromJson(item)).toList();
        }
      } else {
        throw Exception('Gagal mengambil data penjualan header.');
      }
    } catch (error) {
      print('Error fetching penjualan headers: $error');
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk merefresh data penjualan header yang not sent
  Future<void> refreshPenjualanHeadersNotSent() async {
    await fetchPenjualanHeaders('not_sent');
  }

  // Fungsi untuk merefresh data penjualan header yang sent
  Future<void> refreshPenjualanHeadersSent() async {
    await fetchPenjualanHeaders('sent');
  }

  // Fungsi untuk mengupdate filter dan mengambil data ulang
  void updateFilter({String? sales, String? customer, String? barang, String? startDate, String? endDate}) {
    filterSales.value = sales ?? '';
    filterCustomer.value = customer ?? '';
    filterBarang.value = barang ?? '';
    filterStartDate.value = startDate ?? '';
    filterEndDate.value = endDate ?? '';
    fetchPenjualanHeaders('not_sent'); // fetch again with the updated filters
  }

  // Fungsi untuk mengupdate pencarian dan mengambil data ulang
  void updateSearch(String query) {
    searchQuery.value = query;
    fetchPenjualanHeaders('not_sent'); // fetch again with the updated search query
  }

  // Fungsi untuk menambahkan SO baru
  Future<void> storePenjualanHeader(Map<String, dynamic> data) async {
    isLoading.value = true;
    try {
      final token = _authController.token;
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      var request = http.MultipartRequest('POST', Uri.parse(ApiEndpoints.PENJUALAN_HEADER));
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      final response = await request.send();

      if (response.statusCode == 201) {
        // Berhasil menambahkan penjualan header
        refreshPenjualanHeadersNotSent();
      } else {
        throw Exception('Gagal menambahkan penjualan header.');
      }
    } catch (error) {
      print('Error storing penjualan header: $error');
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk mengedit SO
  Future<void> updatePenjualanHeader(int id, Map<String, dynamic> data) async {
    isLoading.value = true;
    try {
      final token = _authController.token;
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      var request = http.MultipartRequest('POST', Uri.parse('${ApiEndpoints.PENJUALAN_HEADER}/$id'));
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['_method'] = 'PUT';

      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      final response = await request.send();

      if (response.statusCode == 200) {
        // Berhasil mengupdate penjualan header
        refreshPenjualanHeadersNotSent();
      } else {
        throw Exception('Gagal mengupdate penjualan header.');
      }
    } catch (error) {
      print('Error updating penjualan header: $error');
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk menghapus SO
  Future<void> deletePenjualanHeader(int id) async {
    isLoading.value = true;
    try {
      final token = _authController.token;
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      final response = await http.delete(
        Uri.parse('${ApiEndpoints.PENJUALAN_HEADER}/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Berhasil menghapus penjualan header
        refreshPenjualanHeadersNotSent();
      } else {
        throw Exception('Gagal menghapus penjualan header.');
      }
    } catch (error) {
      print('Error deleting penjualan header: $error');
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk mencetak PDF SO
  Future<void> printPenjualanHeader(int id) async {
    isLoading.value = true;
    try {
      final token = _authController.token;
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      final response = await http.get(
        Uri.parse('${ApiEndpoints.INVOICE_PENJUALAN}?tipe_invoice=invoice&penjualan_header_id=$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Berhasil mencetak PDF SO
        print('PDF generated successfully');
        // Implementasi download atau tampilan PDF bisa ditambahkan di sini
      } else {
        throw Exception('Gagal mencetak PDF.');
      }
    } catch (error) {
      print('Error printing penjualan header: $error');
    } finally {
      isLoading.value = false;
    }
  }
}
