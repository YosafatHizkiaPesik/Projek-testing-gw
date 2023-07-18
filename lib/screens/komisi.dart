import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'nav_drawer.dart';

class KomisiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Komisi'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Komisi',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Periode: ${DateFormat('dd MMMM yyyy').format(DateTime.now())}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 16.0,
                    headingRowHeight: 48.0,
                    dataRowHeight: 56.0,
                    columns: [
                      DataColumn(
                        label: Text(
                          'Nama Barang',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Total Harga Penjualan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'HPP',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Laba',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '%',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Komisi',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: komisiItems.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text(item.namaBarang)),
                          DataCell(Text(' ${NumberFormat.currency(locale: 'id_ID').format(item.totalHargaPenjualan)}')),
                          DataCell(Text(' ${NumberFormat.currency(locale: 'id_ID').format(item.hpp)}')),
                          DataCell(Text(' ${NumberFormat.currency(locale: 'id_ID').format(item.laba)}')),
                          DataCell(Text('${item.persentase.toStringAsFixed(2)}%')),
                          DataCell(Text(' ${NumberFormat.currency(locale: 'id_ID').format(item.komisi)}')),
                        ],
                      );
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

class KomisiItem {
  final String namaBarang;
  final double totalHargaPenjualan;
  final double hpp;
  final double laba;
  final double persentase;
  final double komisi;

  KomisiItem({
    required this.namaBarang,
    required this.totalHargaPenjualan,
    required this.hpp,
    required this.laba,
    required this.persentase,
    required this.komisi,
  });
}

List<KomisiItem> komisiItems = [
  KomisiItem(namaBarang: 'Barang A', totalHargaPenjualan: 1000000.0, hpp: 800000.0, laba: 200000.0, persentase: 20.0, komisi: 50000.0),
  KomisiItem(namaBarang: 'Barang B', totalHargaPenjualan: 1500000.0, hpp: 1000000.0, laba: 500000.0, persentase: 33.33, komisi: 75000.0),
  KomisiItem(namaBarang: 'Barang C', totalHargaPenjualan: 2000000.0, hpp: 1200000.0, laba: 800000.0, persentase: 40.0, komisi: 100000.0),
];
