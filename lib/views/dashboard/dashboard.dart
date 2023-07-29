import 'package:flutter/material.dart';
import '../../widgets/nav_drawer.dart'; // Import DrawerWidget

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: DrawerWidget(), // Tambahkan DrawerWidget sebagai drawer
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Dashboard',
              style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
            ),
            // Anda bisa menambahkan konten lain di sini
          ],
        ),
      ),
    );
  }
}
