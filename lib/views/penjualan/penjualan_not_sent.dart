import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/penjualan_header_controller.dart';
import '../../models/penjualan_header.dart';

class PenjualanNotSentPage extends StatefulWidget {
  @override
  _PenjualanNotSentPageState createState() => _PenjualanNotSentPageState();
}

class _PenjualanNotSentPageState extends State<PenjualanNotSentPage> {
  final PenjualanHeaderController _penjualanHeaderController = Get.put(PenjualanHeaderController());
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _penjualanHeaderController.fetchPenjualanHeaders('not_sent');
  }

  Future<void> _refresh() async {
    await _penjualanHeaderController.refreshPenjualanHeadersNotSent();
  }

  void _showAddSOForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah SO'),
          content: Form(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'No Invoice'),
                    initialValue: 'DJ202406002',
                    readOnly: true,
                  ),
                  DropdownButtonFormField(
                    items: [], // Tambahkan list sales di sini
                    decoration: InputDecoration(labelText: 'Sales'),
                    onChanged: (value) {},
                  ),
                  DropdownButtonFormField(
                    items: [], // Tambahkan list customer di sini
                    decoration: InputDecoration(labelText: 'Customer'),
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Tanggal SO'),
                    controller: TextEditingController(text: DateTime.now().toString().split(' ')[0]),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          // Set tanggal SO
                        });
                      }
                    },
                  ),
                  DropdownButtonFormField(
                    items: [], // Tambahkan list jatuh tempo di sini
                    decoration: InputDecoration(labelText: 'Tanggal Jatuh Tempo'),
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Keterangan'),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('BATAL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('TAMBAH'),
              onPressed: () {
                // Implementasi fungsi tambah SO
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            : Text('Penjualan Not Sent'),
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

        if (_penjualanHeaderController.penjualanHeadersNotSent.isEmpty) {
          return Center(child: Text('Tidak ada penjualan yang belum terkirim'));
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            child: PaginatedDataTable(
              header: Text('Pesanan Penjualan (SO)'),
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
                DataColumn(label: Text('HAPUS')),
              ],
              source: PenjualanDataTableSource(_penjualanHeaderController.penjualanHeadersNotSent),
              rowsPerPage: 10,
              columnSpacing: 20,
              showCheckboxColumn: false,
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSOForm,
        child: Icon(Icons.add),
        tooltip: 'Create Sales Order',
      ),
    );
  }
}

class PenjualanDataTableSource extends DataTableSource {
  final List<PenjualanHeader> _data;

  PenjualanDataTableSource(this._data);

  @override
  DataRow getRow(int index) {
    if (index >= _data.length) return null!;
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
          _printSO(penjualan.id);
        })),
        DataCell(IconButton(icon: Icon(Icons.delete), onPressed: () {
          _deleteSO(penjualan.id);
        })),
      ],
    );
  }

  void _printSO(int id) {
    Get.find<PenjualanHeaderController>().printPenjualanHeader(id);
  }

  void _deleteSO(int id) {
    Get.defaultDialog(
      title: "Konfirmasi",
      middleText: "Apakah Anda yakin ingin menghapus SO ini?",
      textCancel: "Batal",
      textConfirm: "Hapus",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.find<PenjualanHeaderController>().deletePenjualanHeader(id);
        Get.back();
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}
