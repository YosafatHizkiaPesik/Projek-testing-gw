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
  List<Stock> filteredStocks = [];
  TextEditingController searchController = TextEditingController();
  bool showSearchBar = false;

  int currentPage = 1;
  int itemsPerPage = 10;
  int totalStocks = 0;

  @override
  void initState() {
    super.initState();
    futureStock = stockController.fetchStocks(); 
  }

  Future<void> _refresh() async {
    await stockController.fetchStocks(); 
  }
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _drawerController,
      menuScreen: MenuDrawer(),
      mainScreen: Scaffold(
        appBar: AppBar(
          // Bagian pencarian Stock
          title: showSearchBar
              ? Autocomplete<Stock>(
                  optionsBuilder: (textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<Stock>.empty();
                    }
                    return filteredStocks.where((Stock) {
                      return Stock.nama!
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  // Bagian dropdown hasil pencarian
                  optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<Stock> onSelected, Iterable<Stock> options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        child: ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Stock option = options.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                              },
                              child: ListTile(
                                title: Text(option.nama!),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  // Bagian input pencarian
                  fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextField(
                        controller: searchController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          hintText: 'Cari Stock...',
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.transparent, width: 0),
                          ),
                        ),
                        onChanged: (text) {
                          setState(() {
                            filteredStocks = filteredStocks.where((Stock) {
                              return Stock.nama!
                                  .toLowerCase()
                                  .contains(text.toLowerCase());
                            }).toList();
                          });
                        },
                      ),
                    );
                  },
                  onSelected: (Stock selection) {
                    print("Anda memilih: ${selection.nama}");
                  },
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
              // Tabel stok
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
                      filteredStocks = stocks
                          .where((customer) => customer.nama!
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase()))
                          .toList();
                      return HorizontalDataTable(
                        leftHandSideColumnWidth: 50,
                        rightHandSideColumnWidth: 600,

                        isFixedHeader: true,
                        //Header table
                        headerWidgets: [
                          _getTitleItemWidget('No', 50),
                          _getTitleItemWidget('Barang', 200),
                          _getTitleItemWidget('Stok', 100),
                        ],
                        leftSideItemBuilder: (BuildContext context, int index) {
                          return _getBodyItemWidget((index + 1).toString(), 50);
                        },
                        rightSideItemBuilder: (BuildContext context, int index) {
                          return _getRowWidget(filteredStocks[index], 600);
                        },
                        itemCount: filteredStocks.length,
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
              // Navigasi halaman
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
                  Text('Halaman $currentPage dari ${(filteredStocks.length / itemsPerPage).ceil()}'),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      if (currentPage < (filteredStocks.length / itemsPerPage).ceil()) {
                        setState(() {
                          currentPage++;
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.last_page),
                    onPressed: () {
                      int lastPage = (filteredStocks.length / itemsPerPage).ceil();
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
      borderRadius: 24.0,
      showShadow: true,
      angle: -12.0,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
    );
  }
  // Widget untuk menampilkan item di setiap baris
Widget _getBodyItemWidget(String label, double width) {
  return Container(
    child: Text(label),
    width: width,
    height: 52,
    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
    alignment: Alignment.centerLeft,
  );
}
  // Widget untuk menampilkan judul kolom
  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }
// Widget untuk menampilkan data stok di setiap baris
Widget _getRowWidget(Stock item, double width) {
  return Row(
    children: <Widget>[
      _getBodyItemWidget(item.nama ?? '', 300),  
      _getBodyItemWidget(
          item.stokList.isNotEmpty
              ? item.stokList[0].jumlah.toString()
              : '0',
          250  
      ),
    ],
  );
}
}
