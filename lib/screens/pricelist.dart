import 'package:flutter/material.dart';
import 'nav_drawer.dart';

class PriceListPage extends StatefulWidget {
  @override
  _PriceListPageState createState() => _PriceListPageState();
}

class _PriceListPageState extends State<PriceListPage> {
  List<PriceItem> priceItems = [
    PriceItem('Produk A', 'Kategori A', 15000000),
    PriceItem('Produk B', 'Kategori A', 8000000),
    PriceItem('Produk C', 'Kategori A', 50000),
    PriceItem('Produk D', 'Kategori A', 80000),
    PriceItem('Produk E', 'Kategori A', 200000),
    PriceItem('Produk F', 'Kategori B', 150000),
    PriceItem('Produk G', 'Kategori B', 250000),
    PriceItem('Produk H', 'Kategori B', 300000),
  ];

  List<PriceItem> filteredPriceItems = [];

  String searchQuery = '';
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    filteredPriceItems = priceItems;
  }

  void filterPriceItems() {
    setState(() {
      if (selectedCategory == 'All') {
        filteredPriceItems = priceItems;
      } else {
        filteredPriceItems =
            priceItems.where((item) => item.category == selectedCategory).toList();
      }

      if (searchQuery.isNotEmpty) {
        filteredPriceItems = filteredPriceItems
            .where((item) =>
                item.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Price List'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  filterPriceItems();
                });
              },
              decoration: InputDecoration(
                labelText: 'Cari Barang',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                  filterPriceItems();
                });
              },
              items: [
                DropdownMenuItem(
                  value: 'All',
                  child: Text('Semua Kategori'),
                ),
                DropdownMenuItem(
                  value: 'Kategori A',
                  child: Text('Kategori A'),
                ),
                DropdownMenuItem(
                  value: 'Kategori B',
                  child: Text('Kategori B'),
                ),
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListView.builder(
                itemCount: filteredPriceItems.length,
                itemBuilder: (context, index) {
                  PriceItem item = filteredPriceItems[index];
                  bool isOdd = index % 2 == 0;
                  Color backgroundColor = isOdd ? Color(0xFF757575) : Colors.white;
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                      color: backgroundColor,
                    ),
                    child: ListTile(
                      leading: Text((index + 1).toString()),
                      title: Text(item.name),
                      subtitle: Text('Kategori: ${item.category}'),
                      trailing: Text('Harga: Rp ${item.price.toStringAsFixed(0)}'),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PriceItem {
  final String name;
  final String category;
  final double price;

  PriceItem(this.name, this.category, this.price);
}
