import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../controllers/stok_controller.dart';
import '../../models/stok.dart';
import '../../widgets/menu_drawer.dart';

class StockPage extends StatefulWidget {
  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final _drawerController = ZoomDrawerController();
  final stockController = StockController();
  late Future<StockResponse> futureStock;
  TextEditingController searchController = TextEditingController();
  bool showSearchBar = false;

  int currentPage = 1;
  int itemsPerPage = 10;
  int totalStocks = 0;
  List<Stock> filteredStocks = [];

  @override
  void initState() {
    super.initState();
    futureStock = stockController.fetchStocks();
  }

  Future<void> _refresh() async {
    setState(() {
      futureStock = stockController.fetchStocks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _drawerController,
      menuScreen: MenuDrawer(),
      mainScreen: Scaffold(
        appBar: AppBar(
          title: showSearchBar
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari Stock...',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0),
                      ),
                    ),
                    onChanged: (text) {
                      setState(() {
                        filteredStocks = [];
                      });
                    },
                  ),
                )
              : Text('Stock'),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _drawerController.toggle!();
            },
          ),
          actions: [
            showSearchBar
                ? IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        showSearchBar = false;
                        searchController.clear();
                        filteredStocks = [];
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        showSearchBar = true;
                      });
                    },
                  ),
          ],
        ),
        body: LiquidPullToRefresh(
          onRefresh: _refresh,
          showChildOpacityTransition: false,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: DropdownButton<int>(
                    value: itemsPerPage,
                    items: [10, 25, 50]
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text("$value"),
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        itemsPerPage = newValue!;
                        currentPage = 1;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<StockResponse>(
                  future: futureStock,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      final stocks = snapshot.data!.stocks ?? [];

                      final start = (currentPage - 1) * itemsPerPage;

                      filteredStocks = stocks.where((stock) {
                        return stock.nama!
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase());
                      }).toList();

                      final end = start + itemsPerPage;
                      final stocksOnPage = filteredStocks.sublist(
                        start,
                        end.clamp(0, filteredStocks.length),
                      );

                      totalStocks = stocks.length;

                      return HorizontalDataTable(
                        leftHandSideColumnWidth: 50,
                        rightHandSideColumnWidth: 300, // Ubah lebar menjadi 300
                        isFixedHeader: true,
                        headerWidgets: [
                          _getTitleItemWidget('No', 50),
                          _getTitleItemWidget('Barang', 200),
                          _getTitleItemWidget('Stok', 50),
                        ],
                        leftSideItemBuilder: (BuildContext context, int index) {
                          return _getBodyItemWidget(
                              (start + index + 1).toString(), 50);
                        },
                        rightSideItemBuilder:
                            (BuildContext context, int index) {
                          return _getRowWidget(stocksOnPage[index],
                              300); // Ubah lebar menjadi 300
                        },
                        itemCount: stocksOnPage.length,
                        rowSeparatorWidget: const Divider(
                          color: Colors.black54,
                          height: 1.0,
                          thickness: 0.0,
                        ),
                        leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                        rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                      );
                    } else {
                      return Center(child: Text('Data tidak tersedia.'));
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.first_page),
                    onPressed: () {
                      if (currentPage != 1) {
                        setState(() {
                          currentPage = 1;
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      if (currentPage > 1) {
                        setState(() {
                          currentPage--;
                        });
                      }
                    },
                  ),
                  Text(
                      'Halaman $currentPage dari ${(totalStocks / itemsPerPage).ceil()}'),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      if (currentPage < (totalStocks / itemsPerPage).ceil()) {
                        setState(() {
                          currentPage++;
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.last_page),
                    onPressed: () {
                      int lastPage = (totalStocks / itemsPerPage).ceil();
                      if (currentPage != lastPage) {
                        setState(() {
                          currentPage = lastPage;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getBodyItemWidget(String label, double width) {
    return Container(
      child: Text(label),
      width: width,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getRowWidget(Stock item, double width) {
    return Row(
      children: <Widget>[
        _getBodyItemWidget(item.nama ?? '', 200), // Ubah lebar menjadi 200
        _getBodyItemWidget(
          item.stokList.isNotEmpty ? item.stokList[0].jumlah.toString() : '0',
          50,
        ),
      ],
    );
  }
}
