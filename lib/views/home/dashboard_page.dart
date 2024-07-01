import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import '../../widgets/menu_drawer.dart';
import '../penjualan/penjualan_not_sent.dart';
import '../laporan/laporan_komisi_page.dart';
import '../master/barang_page.dart';
import '../stok/stok_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _drawerController,
      menuScreen: MenuDrawer(),
      mainScreen: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _drawerController.toggle!();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildDashboardCard(
                context,
                icon: Icons.shopping_cart,
                title: 'Penjualan Not Sent',
                page: PenjualanNotSentPage(),
              ),
              _buildDashboardCard(
                context,
                icon: Icons.inventory,
                title: 'Stok',
                page: StockPage(),
              ),
              _buildDashboardCard(
                context,
                icon: Icons.category,
                title: 'Barang',
                page: BarangPage(),
              ),
              _buildDashboardCard(
                context,
                icon: Icons.bar_chart,
                title: 'Laporan Komisi',
                page: LaporanPage(),
              ),
            ],
          ),
        ),
      ),
      showShadow: true,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
    );
  }

  Widget _buildDashboardCard(BuildContext context, {required IconData icon, required String title, required Widget page}) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          Get.to(page);
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                child: Icon(icon, size: 30, color: Colors.white),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
