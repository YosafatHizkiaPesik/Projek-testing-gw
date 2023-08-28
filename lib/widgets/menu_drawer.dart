import 'package:dwijaya_sales_app/views/home/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../controllers/auth_controller.dart';
import '../views/master/barang_page.dart';
import '../views/auth/login_page.dart';
import '../views/master/customer_page.dart';
import '../views/stok/stok_page.dart';
import '../views/laporan/laporan_komisi_page.dart';

class MenuDrawer extends StatefulWidget {
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(authController.currentUser?.username ?? ''),
            accountEmail: Text('Admin'),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return ListTile(
                    leading: Icon(Icons.dashboard),
                    title: Text('Dashboard'),
                    onTap: () => Get.off(() => DashboardPage()),
                  );
                } else if (index == 1) {
                  return buildExpansionTile(
                    context,
                    index,
                    title: 'Master',
                    icon: Icons.list,
                    children: [
                      ListTile(
                        title: Text('Barang'),
                        onTap: () => Get.off(() => BarangPage()),
                      ),
                      ListTile(
                        title: Text('Customer'),
                        onTap: () => Get.off(() => CustomerPage()),
                      ),
                    ],
                  );
                } else if (index == 2) {
                  return buildExpansionTile(
                    context,
                    index,
                    title: 'Stok',
                    icon: Icons.store,
                    children: [
                      ListTile(
                        title: Text('Posisi Stok'),
                        onTap: () => Get.off(() => StockPage()),
                      ),
                    ],
                  );
                } else if (index == 3) {
                  return buildExpansionTile(
                    context,
                    index,
                    title: 'Penjualan',
                    icon: Icons.shopping_cart,
                    children: [
                      ListTile(
                        title: Text('Pesanan Penjualan (SO)'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text('Penjualan (Invoice)'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text('Detail Penjualan Customer'),
                        onTap: () {},
                      ),
                    ],
                  );
                } else if (index == 4) {
                  return buildExpansionTile(
                    context,
                    index,
                    title: 'Laporan',
                    icon: Icons.print,
                    children: [
                      ListTile(
                        title: Text('Laporan Komisi'),
                        onTap: () => Get.off(() => LaporanPage()),
                      ),
                    ],
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
          buildExpansionTile(
            context,
            5,
            title: 'Settings',
            icon: Icons.settings,
            children: [
              ListTile(
                title: Text('Profile'),
                onTap: () {},
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.WARNING,
                    headerAnimationLoop: false,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'Konfirmasi',
                    desc: 'Apakah Anda yakin ingin Logout?',
                    buttonsTextStyle: TextStyle(color: Colors.black),
                    btnCancelOnPress: () {
                    },
                    btnOkOnPress: () async {
                      await authController.logout();
                      Get.offAll(() => LoginPage());
                    },
                    btnCancelText: 'Batal',
                    btnOkText: 'Logout',
                    btnOkColor: Colors.red,
                    btnCancelColor: Colors.blue, 
                  ).show();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

Widget buildExpansionTile(BuildContext context, int index, {required String title, required IconData icon, required List<Widget> children}) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title),
      children: children,
      initiallyExpanded: expandedIndex == index,
      onExpansionChanged: (bool expanded) {
        if (expanded) {
          setState(() {
            expandedIndex = index;
          });
        } else {
          if (expandedIndex == index) {
            setState(() {
              expandedIndex = null;
            });
          }
        }
      },
    );
  }
}
