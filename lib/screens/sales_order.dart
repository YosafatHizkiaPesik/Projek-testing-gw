import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'nav_drawer.dart';

class SalesOrderPage extends StatefulWidget {
  @override
  _SalesOrderPageState createState() => _SalesOrderPageState();
}

class _SalesOrderPageState extends State<SalesOrderPage> {
  String? selectedCustomer;
  DateTime selectedDate = DateTime.now();
  String selectedDueDate = '3 Hari';
  String keterangan = '';
  double ongkir = 0.0;

  List<String> customers = [
    'Customer A',
    'Customer B',
    'Customer C',
  ];

  List<String> dueDates = [
    '3 Hari',
    '1 Minggu',
    '2 Minggu',
    '3 Minggu',
    '1 Bulan',
    '2 Bulan',
    '3 Bulan',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Order'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tambah Sales Order',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedCustomer,
              onChanged: (newValue) {
                setState(() {
                  selectedCustomer = newValue;
                });
              },
              items: customers.map((customer) {
                return DropdownMenuItem<String>(
                  value: customer,
                  child: Text(customer),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Pelanggan',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Tanggal SO',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  DateFormat('dd/MM/yyyy').format(selectedDate),
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedDueDate,
              onChanged: (newValue) {
                setState(() {
                  selectedDueDate = newValue!;
                });
              },
              items: dueDates.map((dueDate) {
                return DropdownMenuItem<String>(
                  value: dueDate,
                  child: Text(dueDate),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Tanggal Jatuh Tempo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  keterangan = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Keterangan',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  ongkir = double.tryParse(value) ?? 0.0;
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Biaya Ongkir',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Logika untuk menyimpan sales order ke database atau melakukan tindakan lain
                // sesuai dengan data yang diisi oleh pengguna
                print('Sales Order berhasil ditambahkan');
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
