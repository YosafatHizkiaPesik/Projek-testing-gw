import 'package:dwijaya_sales_app/views/penjualan/penjualan_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../../controllers/penjualan_header_controller.dart';
import '../../models/penjualan_header.dart';
import '../../widgets/menu_drawer.dart';

class PenjualanNotSentPage extends StatefulWidget {
  @override
  _PenjualanNotSentPageState createState() => _PenjualanNotSentPageState();
}

class _PenjualanNotSentPageState extends State<PenjualanNotSentPage> {
  final PenjualanHeaderController _penjualanHeaderController =
      Get.put(PenjualanHeaderController());
  final _drawerController = ZoomDrawerController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController _tanggalSOController =
      TextEditingController(text: DateTime.now().toString().split(' ')[0]);
  TextEditingController _keteranganController = TextEditingController();
  bool _isSearching = false;
  String? _selectedSales;
  String? _selectedCustomer;
  String? _selectedJatuhTempo;
  List<Object> _salesList = [];
  List<Object> _customersList = [];
  Offset _fabPosition = Offset(20, 20);

  @override
  void initState() {
    super.initState();
    _penjualanHeaderController.fetchPenjualanHeaders('not_sent');
    _penjualanHeaderController.fetchPenjualanHeaders('sent');
    _fetchInitialData();
  }

  Future<void> _refresh() async {
    await _penjualanHeaderController.refreshPenjualanHeadersNotSent();
  }

  Future<void> _fetchInitialData() async {
    _salesList = await _penjualanHeaderController.fetchSales();
    _customersList = await _penjualanHeaderController.fetchCustomers();
    setState(() {});
  }

  void _submitSOForm() async {
    final Map<String, dynamic> data = {
      'sales_id': _selectedSales,
      'customer_id': _selectedCustomer,
      'tanggal_invoice': _tanggalSOController.text,
      'tanggal_jatuh_tempo_invoice': _selectedJatuhTempo,
      'keterangan': _keteranganController.text,
    };

    // Tambahkan SO baru dan simpan penjualan_header_id di SharedPreferences
    final responseBody =
        await _penjualanHeaderController.storePenjualanHeader(data);
    if (responseBody != null) {
      await _savePenjualanHeaderId(responseBody['id']);
      Get.toNamed('/penjualan_edit', arguments: responseBody['id']);
    }
  }

  Future<void> _savePenjualanHeaderId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('penjualan_header_id', id);
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
                  DropdownButtonFormField(
                    items: _salesList.map((value) {
                      final mapValue = value as Map<String, dynamic>;

                      return DropdownMenuItem(
                        value: mapValue["id"].toString(),
                        child: Text(mapValue["nama"].toString()),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Sales'),
                    onChanged: (value) {
                      setState(() {
                        _selectedSales = value as String?;
                      });
                    },
                  ),
                  DropdownButtonFormField(
                    items: _customersList.map((value) {
                      final mapValue = value as Map<String, dynamic>;

                      return DropdownMenuItem(
                        value: mapValue["id"].toString(),
                        child: Text(mapValue["nama"].toString()),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Customer'),
                    onChanged: (value) {
                      setState(() {
                        _selectedCustomer = value as String?;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Tanggal SO'),
                    controller: _tanggalSOController,
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
                          _tanggalSOController.text =
                              pickedDate.toString().split(' ')[0];
                        });
                      }
                    },
                  ),
                  DropdownButtonFormField(
                    items: [
                      '0',
                      '3',
                      '7',
                      '14',
                      '30',
                      '40',
                      '45',
                      '60',
                      '75',
                      '90'
                    ].map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text('$value Hari (+$value)'),
                      );
                    }).toList(),
                    decoration:
                        InputDecoration(labelText: 'Tanggal Jatuh Tempo'),
                    onChanged: (value) {
                      setState(() {
                        _selectedJatuhTempo = value as String?;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Keterangan'),
                    controller: _keteranganController,
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
                _submitSOForm();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              : null,
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

          if (_penjualanHeaderController.penjualanHeadersNotSent.isEmpty) {
            return Center(child: Text('Tidak ada penjualan yang belum terkirim'));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PaginatedDataTable(
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
                    source: PenjualanDataTableSource(
                        _penjualanHeaderController.penjualanHeadersNotSent),
                    rowsPerPage: 10,
                    columnSpacing: 20,
                    showCheckboxColumn: false,
                  ),
                ],
              ),
            ),
          );
        }),
        floatingActionButton: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: FloatingActionButton(
              onPressed: _showAddSOForm,
              child: Icon(Icons.add),
              tooltip: 'Create Sales Order',
            ),
          ),
        ),
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
        DataCell(Text(penjualan.total.toString())),
        DataCell(IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Get.toNamed('/penjualan_edit', arguments: penjualan.id);
            })),
        DataCell(IconButton(
            icon: Icon(Icons.visibility),
            onPressed: () {
              // Navigate to detail page
            })),
        DataCell(IconButton(
            icon: Icon(Icons.print),
            onPressed: () {
              _printSO(penjualan.id);
            })),
        DataCell(
          penjualan.statusKirim != 2
              ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteSO(penjualan.id);
                  })
              : Container(), // Kondisi button delete
        ),
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
