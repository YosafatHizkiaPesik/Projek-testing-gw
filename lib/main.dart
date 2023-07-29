import 'package:flutter/material.dart';
import 'package:dwijaya_sales_app/widgets/splash_screen.dart'; // Gantikan dengan path yang benar ke SplashScreen
import 'package:dwijaya_sales_app/views/login_page.dart'; // Gantikan dengan path yang benar ke LoginPage
import 'package:dwijaya_sales_app/views/dashboard/dashboard.dart'; // Gantikan dengan path yang benar ke DashboardScreen

void main() {
  runApp(DwijayaSalesApp());
}

class DwijayaSalesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dwi Jaya',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => DashboardScreen(),
        // Anda dapat menambahkan rute lain di sini sesuai kebutuhan
      },
    );
  }
}
