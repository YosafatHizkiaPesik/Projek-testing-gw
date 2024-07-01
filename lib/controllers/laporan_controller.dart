import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import '../utils/constants.dart';
import '../models/komisi_sales.dart';
import '../models/detail_per_sales.dart';
import 'auth_controller.dart';

class LaporanController extends GetxController {
  var listKomisiSales = Rx<ListKomisiSales?>(null);
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final AuthController _authController = AuthController();

  // Mendapatkan laporan komisi sales
  Future<ListKomisiSales?> fetchKomisiSales({
    required String awalTanggal,
    required String akhirTanggal,
  }) async {
    isLoading(true);
    final token = _authController.token;

    if (token == null) {
      errorMessage('Token tidak ditemukan.');
      isLoading(false);
      return null;
    }

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url =
        "${ApiEndpoints.LAPORAN_KOMISI_SALES}?filter_clicked=true&awal_tanggal=$awalTanggal&akhir_tanggal=$akhirTanggal";
    print("Fetching komisi sales with URL: $url"); // Log URL
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      listKomisiSales.value = ListKomisiSales.fromJson(json.decode(response.body));
      errorMessage('');
    } else if (response.statusCode == 422) {
      errorMessage('Error 422: Tidak dapat memproses data');
    } else {
      errorMessage('Gagal mengambil data laporan komisi sales');
    }

    isLoading(false);
    return listKomisiSales.value;
  }

  // Mendapatkan detail laporan per sales
  Future<DetailPerSales?> fetchDetailPerSales({
    required int salesId,
    required String awalTanggal,
    required String akhirTanggal,
  }) async {
    isLoading(true);
    final token = _authController.token;

    if (token == null) {
      errorMessage('Token tidak ditemukan.');
      isLoading(false);
      return null;
    }

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url =
        "${ApiEndpoints.LAPORAN_KOMISI_SALES_DETAIL}?sales_id=$salesId&awal_tanggal=$awalTanggal&akhir_tanggal=$akhirTanggal";
    print("Fetching detail per sales with URL: $url"); // Log URL
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var detailPerSales = DetailPerSales.fromJson(json.decode(response.body));
      errorMessage('');
      isLoading(false);
      return detailPerSales;
    } else {
      errorMessage('Gagal mengambil data detail per sales');
      isLoading(false);
      return null;
    }
  }

  // Refresh laporan
  Future<void> refreshReports({
    required String awalTanggal,
    required String akhirTanggal,
  }) async {
    await fetchKomisiSales(awalTanggal: awalTanggal, akhirTanggal: akhirTanggal);
  }

  // Tampilkan PDF
  Future<String?> viewPdf({
    required String awalTanggal,
    required String akhirTanggal,
  }) async {
    try {
      final token = _authController.token;
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final url =
          "${ApiEndpoints.LAPORAN_KOMISI_SALES_PRINT}?awal_tanggal=$awalTanggal&akhir_tanggal=$akhirTanggal";
      print("Generating PDF with URL: $url"); // Log URL
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        Directory tempDir = await getTemporaryDirectory();
        File tempFile = File('${tempDir.path}/report.pdf');
        await tempFile.writeAsBytes(response.bodyBytes, flush: true);
        return tempFile.path;
      } else {
        errorMessage('Gagal mengunduh file PDF');
        throw Exception(errorMessage.value);
      }
    } catch (error) {
      errorMessage(error.toString());
      throw error;
    }
  }

  // Download PDF
  Future<void> downloadPdf({
    required String awalTanggal,
    required String akhirTanggal,
  }) async {
    try {
      String? filePath = await viewPdf(awalTanggal: awalTanggal, akhirTanggal: akhirTanggal);
      if (filePath != null) {
        final directory = await getExternalStorageDirectory();
        final newPath = join(directory!.path, 'Download');
        final newDirectory = Directory(newPath);
        if (!await newDirectory.exists()) {
          await newDirectory.create();
        }
        final newFile = await File(filePath).copy('$newPath/laporan.pdf');
        print('PDF tersimpan di ${newFile.path}');
        await OpenFile.open(newFile.path); // Buka file setelah diunduh
      }
    } catch (error) {
      print('Gagal mendownload PDF: $error');
    }
  }
}
