import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart'; 
import 'controllers/barang_controller.dart'; 
import 'controllers/laporan_controller.dart';
import 'views/auth/login_page.dart';
import 'views/home/dashboard_page.dart';
import 'views/home/splash_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());  
    Get.put(BarangController());  
    Get.put(LaporanController());
  

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
      ],
    );
  }
}
