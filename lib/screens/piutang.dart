import 'package:flutter/material.dart';
import 'nav_drawer.dart';

class PiutangPage extends StatefulWidget {
  @override
  _PiutangPageState createState() => _PiutangPageState();
}

class _PiutangPageState extends State<PiutangPage> {
  List<PiutangItem> piutangItems = [
    PiutangItem(1, '2023-07-01', 'Customer A', 'Penjualan Barang A', 1000000, 0, 1000000),
    PiutangItem(2, '2023-07-05', 'Customer B', 'Penjualan Barang B', 0, 500000, 500000),
    PiutangItem(3, '2023-07-10', 'Customer C', 'Penjualan Barang C', 2000000, 0, 2000000),
    PiutangItem(4, '2023-07-15', 'Customer D', 'Penjualan Barang D', 0, 800000, 800000),
  ];

  List<PiutangItem> filteredPiutangItems = [];

  String searchQuery = '';
  String selectedPeriod = 'All Time';

  @override
  void initState() {
    super.initState();
    filteredPiutangItems = piutangItems;
  }

  void filterPiutangItems() {
    List<PiutangItem> tempList = [];
    tempList.addAll(piutangItems);

    if (selectedPeriod != 'All Time') {
      tempList.retainWhere((item) {
        DateTime itemDate = DateTime.parse(item.tanggal);
        DateTime selectedDate = DateTime.parse(selectedPeriod);

        return itemDate.isAfter(selectedDate) || itemDate.isAtSameMomentAs(selectedDate);
      });
    }

    if (searchQuery.isNotEmpty) {
      tempList.retainWhere((item) =>
          item.namaCustomer.toLowerCase().contains(searchQuery.toLowerCase()));
    }

    setState(() {
      filteredPiutangItems = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Piutang'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                      filterPiutangItems();
                    },
                    decoration: InputDecoration(
                      labelText: 'Cari Nama Customer',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                DropdownButton<String>(
                  value: selectedPeriod,
                  onChanged: (value) {
                    setState(() {
                      selectedPeriod = value!;
                    });
                    filterPiutangItems();
                  },
                  items: <String>['All Time', '2023-07-01', '2023-07-05', '2023-07-10', '2023-07-15']
                      .map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
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
                        'Nomor',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Tanggal',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Nama Customer',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Keterangan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Debit',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Kredit',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: filteredPiutangItems.map((item) {
                    return DataRow(
                      cells: [
                        DataCell(Text(item.nomor.toString())),
                        DataCell(Text(item.tanggal)),
                        DataCell(Text(item.namaCustomer)),
                        DataCell(Text(item.keterangan)),
                        DataCell(Text(item.debit.toString())),
                        DataCell(Text(item.kredit.toString())),
                        DataCell(Text(item.total.toString())),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PiutangItem {
  final int nomor;
  final String tanggal;
  final String namaCustomer;
  final String keterangan;
  final int debit;
  final int kredit;
  final int total;

  PiutangItem(
    this.nomor,
    this.tanggal,
    this.namaCustomer,
    this.keterangan,
    this.debit,
    this.kredit,
    this.total,
  );
}
