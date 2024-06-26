import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../utils/constants.dart';
import '../models/komisi_sales.dart';
import '../models/detail_per_sales.dart';
import 'auth_controller.dart';

class LaporanController with ChangeNotifier {
  ListKomisiSales? _listKomisiSales;
  DetailPerSales? _detailPerSales;
  bool isLoading = false;
  String? errorMessage;

  final AuthController _authController = AuthController();

  ListKomisiSales? get listKomisiSales => _listKomisiSales;
  DetailPerSales? get detailPerSales => _detailPerSales;

  // Mendapatkan laporan komisi sales
  Future<ListKomisiSales?> fetchKomisiSales() async {
    isLoading = true;
    notifyListeners();

    final token = _authController.token;
    final salesId = _authController.currentUser?.id;  

    if (token == null) {
      throw Exception('Token tidak ditemukan.');
    }

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = salesId != null ? "${ApiEndpoints.LAPORAN_KOMISI_SALES}?salesId=$salesId" : ApiEndpoints.LAPORAN_KOMISI_SALES;
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      _listKomisiSales = ListKomisiSales.fromJson(json.decode(response.body));
      errorMessage = null;
      isLoading = false;
      notifyListeners();
      return _listKomisiSales;
    } else if (response.statusCode == 422) { 
      print('Error 422: Tidak dapat memproses data');
    } else {
      errorMessage = 'Gagal mengambil data laporan komisi sales';
      throw Exception(errorMessage);
    }
  }

  // Mendapatkan detail laporan per sales
  Future<DetailPerSales?> fetchDetailPerSales() async {
    isLoading = true;
    notifyListeners();

    final token = _authController.token;
    final salesId = _authController.currentUser?.id; 

    if (token == null) {
      throw Exception('Token tidak ditemukan.');
    }

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = salesId != null ? "${ApiEndpoints.LAPORAN_KOMISI_SALES_DETAIL}?salesId=$salesId" : ApiEndpoints.LAPORAN_KOMISI_SALES_DETAIL;
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      _detailPerSales = DetailPerSales.fromJson(json.decode(response.body));
      errorMessage = null;
      isLoading = false;
      notifyListeners();
      return _detailPerSales;
    } else {
      errorMessage = 'Gagal mengambil data detail per sales';
      throw Exception(errorMessage);
    }
  }

  // Refresh laporan
  Future<void> refreshReports() async {
    await fetchKomisiSales();
    await fetchDetailPerSales();
    notifyListeners();
  }

  // Tampilkan PDF
  Future<String?> viewPdf() async {
    try {
      final token = _authController.token;
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(Uri.parse(ApiEndpoints.LAPORAN_KOMISI_SALES_PRINT), headers: headers);

      if (response.statusCode == 200) {
        Directory tempDir = await getTemporaryDirectory();
        File tempFile = File('${tempDir.path}/report.pdf');
        await tempFile.writeAsBytes(response.bodyBytes, flush: true);
        return tempFile.path;
      } else {
        errorMessage = 'Gagal mengunduh file PDF';
        throw Exception(errorMessage);
      }
    } catch (error) {
      errorMessage = error.toString();
      print("Error: $errorMessage");
      throw error;
    }
  }

  // Download PDF
  Future<void> downloadPdf() async {
    try {
      String? filePath = await viewPdf();
      if (filePath != null) {
        final directory = await getExternalStorageDirectory();
        final newPath = join(directory!.path, 'Download');
        final newDirectory = Directory(newPath);
        if (!await newDirectory.exists()) {
          await newDirectory.create();
        }
        final newFile = await File(filePath).copy('$newPath/laporan.pdf');
        print('PDF tersimpan di ${newFile.path}');
      }
    } catch (error) {
      print('Gagal mendownload PDF: $error');
    }
  }
}
