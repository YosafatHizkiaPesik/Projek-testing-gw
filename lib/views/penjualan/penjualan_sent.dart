import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import '../../controllers/penjualan_header_controller.dart';
import '../../widgets/menu_drawer.dart';
import '../../models/penjualan_header.dart';

class PenjualanSentPage extends StatefulWidget {
  @override
  _PenjualanSentPageState createState() => _PenjualanSentPageState();
}

class _PenjualanSentPageState extends State<PenjualanSentPage> {
  final _drawerController = ZoomDrawerController();
  final PenjualanHeaderController _penjualanHeaderController = Get.put(PenjualanHeaderController());
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
            return SingleChildScrollView(
              child: PaginatedDataTable(
                header: Text('Pesanan Penjualan (Sent)'),
                columns: [
                  DataColumn(label: Text('NO')),
                  DataColumn(label: Text('TANGGAL SO')),
                  DataColumn(label: Text('NO SO')),
                  DataColumn(label: Text('SALES')),
                  DataColumn(label: Text('CUSTOMER')),
                  DataColumn(label: Text('KETERANGAN')),
                  DataColumn(label: Text('TOTAL SO')),
                  DataColumn(label: Text('EDIT')),
                  DataColumn(label: Text('DETAIL')),
                  DataColumn(label: Text('PRINT SO')),
                  DataColumn(label: Text('BATAL')),
                ],
                source: PenjualanDataTableSource([]),
                rowsPerPage: 10,
                columnSpacing: 20,
                showCheckboxColumn: false,
              ),
            );
          }

          return SingleChildScrollView(
            child: PaginatedDataTable(
              header: Text('Pesanan Penjualan (Sent)'),
              columns: [
                DataColumn(label: Text('NO')),
                DataColumn(label: Text('TANGGAL SO')),
                DataColumn(label: Text('NO SO')),
                DataColumn(label: Text('SALES')),
                DataColumn(label: Text('CUSTOMER')),
                DataColumn(label: Text('KETERANGAN')),
                DataColumn(label: Text('TOTAL SO')),
                DataColumn(label: Text('EDIT')),
                DataColumn(label: Text('DETAIL')),
                DataColumn(label: Text('PRINT SO')),
                DataColumn(label: Text('BATAL')),
              ],
              source: PenjualanDataTableSource(_penjualanHeaderController.penjualanHeadersSent),
              rowsPerPage: 10,
              columnSpacing: 20,
              showCheckboxColumn: false,
            ),
          );
        }),
      ),
    );
  }
}

class PenjualanDataTableSource extends DataTableSource {
  final List<PenjualanHeader> _data;

  PenjualanDataTableSource(this._data);

  @override
  DataRow getRow(int index) {
    if (index >= _data.length) {
      return DataRow.byIndex(
        index: index,
        cells: List.generate(11, (index) => DataCell(Text(''))),
      );
    }
    final PenjualanHeader penjualan = _data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(Text(penjualan.tanggalInvoice)),
        DataCell(Text(penjualan.noInvoice)),
        DataCell(Text(penjualan.sales.nama)),
        DataCell(Text(penjualan.customer.nama)),
        DataCell(Text(penjualan.keterangan ?? '')),
        DataCell(Text(penjualan.total)),
        DataCell(IconButton(icon: Icon(Icons.edit), onPressed: () {
          // Navigate to edit page
        })),
        DataCell(IconButton(icon: Icon(Icons.visibility), onPressed: () {
          // Navigate to detail page
        })),
        DataCell(IconButton(icon: Icon(Icons.print), onPressed: () {
          // Print SO
        })),
        DataCell(IconButton(icon: Icon(Icons.cancel), onPressed: () {
          // Cancel SO
        })),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}
