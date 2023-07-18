import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'nav_drawer.dart';

class Order {
  final DateTime tanggal;
  final String customer;
  final String keterangan;
  final double totalInvoice;
  final bool dikirim;

  Order({
    required this.tanggal,
    required this.customer,
    required this.keterangan,
    required this.totalInvoice,
    required this.dikirim,
  });
}

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final List<Order> _orders = [
    Order(
      tanggal: DateTime(2023, 7, 1),
      customer: 'Customer A',
      keterangan: 'Pesanan pertama',
      totalInvoice: 1500000.0,
      dikirim: true,
    ),
    Order(
      tanggal: DateTime(2023, 7, 3),
      customer: 'Customer B',
      keterangan: 'Pesanan kedua',
      totalInvoice: 2000000.0,
      dikirim: false,
    ),
    Order(
      tanggal: DateTime(2023, 7, 5),
      customer: 'Customer C',
      keterangan: 'Pesanan ketiga',
      totalInvoice: 1000000.0,
      dikirim: true,
    ),
  ];

  List<Order> _filteredOrders = [];

  TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _filteredOrders = List.from(_orders);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterOrders() {
    String keyword = _searchController.text.toLowerCase();
    List<Order> filteredList = [];

    if (_selectedFilter == 'Semua') {
      filteredList = _orders
          .where((order) =>
              order.tanggal.toString().toLowerCase().contains(keyword) ||
              order.customer.toLowerCase().contains(keyword) ||
              order.keterangan.toLowerCase().contains(keyword) ||
              order.totalInvoice.toString().toLowerCase().contains(keyword) ||
              order.dikirim.toString().toLowerCase().contains(keyword))
          .toList();
    } else {
      filteredList = _orders
          .where((order) =>
              order.dikirim == (_selectedFilter == 'Dikirim') &&
              (order.tanggal.toString().toLowerCase().contains(keyword) ||
                  order.customer.toLowerCase().contains(keyword) ||
                  order.keterangan.toLowerCase().contains(keyword) ||
                  order.totalInvoice.toString().toLowerCase().contains(keyword)))
          .toList();
    }

    setState(() {
      _filteredOrders = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Order'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _filterOrders();
              },
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedFilter,
              onChanged: (newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                });
                _filterOrders();
              },
              items: ['Semua', 'Dikirim', 'Belum Dikirim']
                  .map((filter) => DropdownMenuItem(
                        value: filter,
                        child: Text(filter),
                      ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Filter',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text('Tanggal Order'),
                      ),
                      DataColumn(
                        label: Text('Customer'),
                      ),
                      DataColumn(
                        label: Text('Keterangan'),
                      ),
                      DataColumn(
                        label: Text('Total Invoice'),
                      ),
                      DataColumn(
                        label: Text('Status'),
                      ),
                    ],
                    rows: _filteredOrders.map((order) {
                      return DataRow(cells: [
                        DataCell(
                          Text(DateFormat('yyyy-MM-dd').format(order.tanggal)),
                        ),
                        DataCell(
                          Text(order.customer),
                        ),
                        DataCell(
                          Text(order.keterangan),
                        ),
                        DataCell(
                          Text('Rp ${order.totalInvoice.toStringAsFixed(2)}'),
                        ),
                        DataCell(
                          Text(order.dikirim ? 'Sudah dikirim' : 'Belum dikirim'),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Sales App',
    home: OrderListPage(),
  ));
}
