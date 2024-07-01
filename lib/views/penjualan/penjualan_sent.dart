import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import '../../controllers/penjualan_header_controller.dart';
import '../../models/penjualan_header.dart';
import '../../widgets/menu_drawer.dart';

class PenjualanSentPage extends StatefulWidget {
  @override
  _PenjualanSentPageState createState() => _PenjualanSentPageState();
}

class _PenjualanSentPageState extends State<PenjualanSentPage> {
  final PenjualanHeaderController _penjualanHeaderController = Get.put(PenjualanHeaderController());
  final _drawerController = ZoomDrawerController();
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _penjualanHeaderController.fetchPenjualanHeaders('sent');
  }

  Future<void> _refresh() async {
    await _penjualanHeaderController.refreshPenjualanHeadersSent();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _drawerController,
      menuScreen: MenuDrawer(),
      mainScreen: Scaffold(
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari penjualan...',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    _penjualanHeaderController.updateSearch(value);
                  },
                )
              : Text('Penjualan Sent'),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _drawerController.toggle!();
            },
          ),
          actions: [
            _isSearching
                ? IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        _searchController.clear();
                        _penjualanHeaderController.updateSearch('');
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
          ],
        ),
        body: Obx(() {
          if (_penjualanHeaderController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (_penjualanHeaderController.penjualanHeadersSent.isEmpty) {
            return Center(child: Text('No data available in table.'));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DataTable(
                    columns: [
                      DataColumn(label: Text('NO')),
                      DataColumn(label: Text('TANGGAL INVOICE')),
                      DataColumn(label: Text('NO INVOICE')),
                      DataColumn(label: Text('SALES')),
                      DataColumn(label: Text('CUSTOMER')),
                      DataColumn(label: Text('KETERANGAN')),
                      DataColumn(label: Text('TOTAL INVOICE')),
                      DataColumn(label: Text('REVISI')),
                      DataColumn(label: Text('DETAIL')),
                      DataColumn(label: Text('REPRINT INVOICE')),
                    ],
                    rows: _penjualanHeaderController.penjualanHeadersSent.map((penjualan) {
                      return DataRow(cells: [
                        DataCell(Text(penjualan.id.toString())),
                        DataCell(Text(penjualan.tanggalInvoice)),
                        DataCell(Text(penjualan.noInvoice)),
                        DataCell(Text(penjualan.sales.nama)),
                        DataCell(Text(penjualan.customer.nama)),
                        DataCell(Text(penjualan.keterangan ?? '')),
                        DataCell(Text(penjualan.total.toString())),
                        DataCell(IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Get.toNamed('/penjualan_edit', arguments: penjualan.id);
                          },
                        )),
                        DataCell(IconButton(
                          icon: Icon(Icons.visibility),
                          onPressed: () {
                            // Navigate to detail page
                          },
                        )),
                        DataCell(IconButton(
                          icon: Icon(Icons.print),
                          onPressed: () {
                            _printInvoice(penjualan.id);
                          },
                        )),
                      ]);
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void _printInvoice(int id) {
    Get.find<PenjualanHeaderController>().printPenjualanHeader(id);
  }
}
