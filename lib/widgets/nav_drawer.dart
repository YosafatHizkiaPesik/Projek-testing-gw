import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dwijaya_sales_app/utils/auth.dart'; // Gantikan dengan path yang benar ke AuthService
import 'package:dwijaya_sales_app/models/user.dart'; // Gantikan dengan path yang benar ke model User

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final AuthService _authService = AuthService();
  User? user;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    user = await _authService.getCurrentUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String role = user?.hakAkses == 2 ? "Owner" : "Admin";
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user?.username ?? ''),
            accountEmail: Text(role),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Color(0xFFf3f6f9),
              child: Text(
                user?.username[0] ?? '',
                style: TextStyle(fontSize: 40.0, color: Colors.black),
              ),
            ),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.tachometerAlt),
            title: Text('Dashboard'),
            onTap: () => Navigator.pushReplacementNamed(context, '/dashboard'),
          ),
          ExpansionTile(
            leading: Icon(FontAwesomeIcons.list),
            title: Text('Master'),
            children: [
              ListTile(
                leading: Icon(FontAwesomeIcons.boxOpen),
                title: Text('Barang'),
                onTap: () => Navigator.pushReplacementNamed(context, '/barang'),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.users),
                title: Text('Customer'),
                onTap: () => Navigator.pushReplacementNamed(context, '/customer'),
              ),
            ],
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.box),
            title: Text('Stok'),
            onTap: () => Navigator.pushReplacementNamed(context, '/stok'),
          ),
          ExpansionTile(
            leading: Icon(FontAwesomeIcons.shoppingCart),
            title: Text('Penjualan'),
            children: [
              ListTile(
                leading: Icon(FontAwesomeIcons.fileInvoice),
                title: Text('Pesanan Penjualan (SO)'),
                onTap: () => Navigator.pushReplacementNamed(context, '/pesanan_penjualan'),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.receipt),
                title: Text('Invoice'),
                onTap: () => Navigator.pushReplacementNamed(context, '/invoice'),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(FontAwesomeIcons.print),
            title: Text('Laporan'),
            children: [
              ListTile(
                leading: Icon(FontAwesomeIcons.fileAlt),
                title: Text('Laporan Komisi'),
                onTap: () => Navigator.pushReplacementNamed(context, '/laporan_komisi'),
              ),
            ],
          ),
          Divider(),
          ExpansionTile(
            leading: Icon(FontAwesomeIcons.user),
            title: Text('Profile'),
            children: [
              ListTile(
                leading: Icon(FontAwesomeIcons.cogs),
                title: Text('Setting'),
                onTap: () => Navigator.pushReplacementNamed(context, '/setting'),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.signOutAlt),
                title: Text('Logout'),
                onTap: () async {
                  await _authService.logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
