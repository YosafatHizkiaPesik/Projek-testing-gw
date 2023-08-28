import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../controllers/barang_controller.dart';
import '../../models/barang.dart';
import '../../widgets/menu_drawer.dart';

class BarangPage extends StatefulWidget {
  @override
  _BarangPageState createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  final _drawerController = ZoomDrawerController();
  final barangController = BarangController();
  late Future<BarangResponse> futureBarang;
  List<Barang> filteredItems = [];
  TextEditingController searchController = TextEditingController();
  bool showSearchBar = false;

  // Variabel untuk paginasi
  int currentPage = 1;
  int itemsPerPage = 10;
  int totalBarang = 0;

  @override
  void initState() {
    super.initState();
    futureBarang = barangController.fetchBarang();
  }

  Future<void> _refresh() async {
    setState(() {
      futureBarang = barangController.fetchBarang();
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
              ? Autocomplete<Barang>(
                  optionsBuilder: (textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<Barang>.empty();
                    }
                    return filteredItems.where((item) {
                      return item.nama!
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<Barang> onSelected, Iterable<Barang> options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        child: ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Barang option = options.elementAt(index);
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
                          hintText: 'Cari barang...',
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
                            filteredItems = filteredItems.where((item) {
                              return item.nama!
                                  .toLowerCase()
                                  .contains(text.toLowerCase());
                            }).toList();
                          });
                        },
                      ),
                    );
                  },
                  onSelected: (Barang selection) {
                    print("You selected: ${selection.nama}");
                  },
                )
              : Text('Barang'),
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
              // Dropdown untuk memilih jumlah item per halaman
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
                        currentPage = 1; // Reset ke halaman pertama
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<BarangResponse>(
                  future: futureBarang,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      final items = snapshot.data!.barangs ?? [];
                      filteredItems = items;

                      // Kode untuk paginasi
                      final start = (currentPage - 1) * itemsPerPage;
                      final end = min(start + itemsPerPage, filteredItems.length);
                      final itemsOnPage = filteredItems.sublist(start, end);

                      return HorizontalDataTable(
                        leftHandSideColumnWidth: 50,
                        rightHandSideColumnWidth: 600,
                        isFixedHeader: true,
                        headerWidgets: [
                          _getTitleItemWidget('No', 50),
                          _getTitleItemWidget('Barang', 200),
                          _getTitleItemWidget('HP', 100),
                          _getTitleItemWidget('H1', 100),
                          _getTitleItemWidget('H2', 100),
                          _getTitleItemWidget('H3', 100),
                        ],
                        leftSideItemBuilder: (BuildContext context, int index) {
                          return _getBodyItemWidget((start + index + 1).toString(), 50);
                        },
                        rightSideItemBuilder: (BuildContext context, int index) {
                          return _getRowWidget(itemsOnPage[index], 600);
                        },
                        itemCount: itemsOnPage.length,
                        rowSeparatorWidget: const Divider(
                          color: Colors.black54,
                          height: 1.0,
                          thickness: 0.0,
                        ),
                      );
                    } else {
                      return Center(child: Text('Data tidak tersedia.'));
                    }
                  },
                ),
              ),
              // Tombol paginasi
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
                  Text('Halaman $currentPage dari ${(filteredItems.length / itemsPerPage).ceil()}'),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      if (currentPage < (filteredItems.length / itemsPerPage).ceil()) {
                        setState(() {
                          currentPage++;
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.last_page),
                    onPressed: () {
                      int lastPage = (filteredItems.length / itemsPerPage).ceil();
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

  Widget _getRowWidget(Barang item, double width) {
    return Row(
      children: <Widget>[
        _getBodyItemWidget(item.nama ?? '', 200),
        _getBodyItemWidget(item.hp?.toString() ?? '', 100),
        _getBodyItemWidget(item.h1?.toString() ?? '', 100),
        _getBodyItemWidget(item.h2?.toString() ?? '', 100),
        _getBodyItemWidget(item.h3?.toString() ?? '', 100),
      ],
    );
  }
}
