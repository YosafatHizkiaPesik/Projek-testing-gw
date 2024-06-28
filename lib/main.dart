import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'controllers/auth_controller.dart';
import 'controllers/barang_controller.dart';
import 'controllers/laporan_controller.dart';
import 'views/auth/login_page.dart';
import 'views/home/dashboard_page.dart';
import 'views/home/splash_screen.dart';
import 'controllers/penjualan_header_controller.dart';
import 'views/penjualan/penjualan_edit.dart'; // Import halaman edit
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await FlutterDownloader.initialize(
      debug: true 
    );
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Inisialisasi GetX Controllers
    Get.put(AuthController());
    Get.put(BarangController());
    Get.put(LaporanController());
    Get.put(PenjualanHeaderController());

    return GetMaterialApp(
      title: 'DWI JAYA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/dashboard', page: () => DashboardPage()),
        GetPage(
          name: '/penjualan_edit',
          page: () => PenjualanEditPage(penjualanHeaderId: Get.arguments),
        ), 
      ],
    );
  }
}
