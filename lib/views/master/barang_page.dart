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
  TextEditingController searchController = TextEditingController();
  bool showSearchBar = false;

  List<Barang> filteredItems = [];

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
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari barang...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      border: InputBorder.none,
                    ),
                    onChanged: (text) {
                      setState(() {
                        filteredItems = [];
                      });
                    },
                  ),
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
                        searchController.clear();
                        filteredItems = [];
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

                filteredItems = items.where((item) {
                  return item.nama!
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase());
                }).toList();

                return Column(
                  children: [
                    Expanded(
                      child: HorizontalDataTable(
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
                          return _getBodyItemWidget(
                              (index + 1).toString(), 50);
                        },
                        rightSideItemBuilder: (BuildContext context, int index) {
                          return _getRowWidget(filteredItems[index], 600);
                        },
                        itemCount: filteredItems.length,
                        rowSeparatorWidget: const Divider(
                          color: Colors.black54,
                          height: 1.0,
                          thickness: 0.0,
                        ),
                        leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                        rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(child: Text('Data tidak tersedia.'));
              }
            },
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
