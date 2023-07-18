import 'package:flutter/material.dart';
import 'screens/dashboard.dart';
import 'screens/login.dart';
import 'screens/splash.dart';

void main() {
  runApp(SalesApp());
}

class SalesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sales App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => DashboardPage(),
      },
    );
  }
}
