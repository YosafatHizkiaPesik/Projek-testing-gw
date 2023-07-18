import 'package:flutter/material.dart';
import 'nav_drawer.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Welcome to the Home Page'),
      ),
    );
  }
}
