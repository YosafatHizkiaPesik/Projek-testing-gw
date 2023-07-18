import 'package:flutter/material.dart';
import 'nav_drawer.dart';

class StockPage extends StatefulWidget {
  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  List<StockItem> stockItems = [
    StockItem('Produk A', 'Kategori A', 10),
    StockItem('Produk B', 'Kategori A', 15),
    StockItem('Produk C', 'Kategori A', 20),
    StockItem('Produk D', 'Kategori A', 18),
    StockItem('Produk E', 'Kategori A', 5),
    StockItem('Produk F', 'Kategori B', 30),
    StockItem('Produk G', 'Kategori B', 25),
    StockItem('Produk H', 'Kategori B', 12),
  ];

  List<StockItem> filteredStockItems = [];

  String searchQuery = '';
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    filteredStockItems = stockItems;
  }

  void filterStockItems() {
    setState(() {
      if (selectedCategory == 'All') {
        filteredStockItems = stockItems;
      } else {
        filteredStockItems =
            stockItems.where((item) => item.category == selectedCategory).toList();
      }

      if (searchQuery.isNotEmpty) {
        filteredStockItems = filteredStockItems
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
        title: Text('Stok Barang'),
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
                  filterStockItems();
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
                  filterStockItems();
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
                itemCount: filteredStockItems.length,
                itemBuilder: (context, index) {
                  StockItem item = filteredStockItems[index];
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
                      trailing: Text('Stok: ${item.stock.toString()}'),
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

class StockItem {
  final String name;
  final String category;
  final int stock;

  StockItem(this.name, this.category, this.stock);
}
