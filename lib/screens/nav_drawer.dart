import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'sales_order.dart';
import 'stock.dart';
import 'pricelist.dart';
import 'piutang.dart';
import 'komisi.dart';
import 'order_list.dart';
import 'login.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Arkas'),
            accountEmail: Text('Owner'),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DashboardPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Pesanan Penjualan (SO)'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SalesOrderPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Stok Barang'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StockPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('Price List'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PriceListPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text('Piutang'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PiutangPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.calculate),
            title: Text('Komisi'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => KomisiPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Daftar SO'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderListPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Ubah Password'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Ubah Password'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password Lama',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password Baru',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Konfirmasi Password Baru',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Simulasikan perubahan password
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Password berhasil diubah'),
                            ),
                          );
                        },
                        child: Text('Simpan'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
