import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../controllers/detail_penjualan_customer_controller.dart';
import '../../models/detail_penjualan_customer.dart';
import '../../widgets/menu_drawer.dart';

class DetailPenjualanCustomerPage extends StatefulWidget {
  @override
  _DetailPenjualanCustomerPageState createState() => _DetailPenjualanCustomerPageState();
}

class _DetailPenjualanCustomerPageState extends State<DetailPenjualanCustomerPage> {
  final _drawerController = ZoomDrawerController();
  final DetailPenjualanCustomerController detailPenjualanController = DetailPenjualanCustomerController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime? awalTanggal;
  DateTime? akhirTanggal;

  @override
  void initState() {
    super.initState();
    detailPenjualanController.fetchDetailPenjualanCustomer(
      cabangId: 'all',
      customerId: 'all',
      barangId: 'all',
      awalTanggal: '2023-07-01',
      akhirTanggal: '2023-07-31',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => detailPenjualanController,
      child: Consumer<DetailPenjualanCustomerController>(
        builder: (context, controller, child) {
          return ZoomDrawer(
            controller: _drawerController,
            menuScreen: MenuDrawer(),
            mainScreen: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text('Detail Penjualan Customer'),
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    _drawerController.toggle!();
                  },
                ),
              ),
              body: controller.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : controller.errorMessage != null
                      ? Center(child: Text(controller.errorMessage!))
                      : controller.detailPenjualanCustomer == null
                          ? Center(child: Text('No data available'))
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _buildFilterInfo(controller.detailPenjualanCustomer!.teksFilter),
                                ),
                                Expanded(
                                  child: controller.detailPenjualanCustomer!.penjualanHeaders.isEmpty
                                      ? Center(child: Text('Tidak ada data yang cocok dengan filter'))
                                      : ListView.builder(
                                          itemCount: controller.detailPenjualanCustomer!.penjualanHeaders.length,
                                          itemBuilder: (context, index) {
                                            return _buildPenjualanCard(controller.detailPenjualanCustomer!.penjualanHeaders[index]);
                                          },
                                        ),
                                ),
                              ],
                            ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterInfo(Map<String, String?> teksFilter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Institusi: ${teksFilter['cabang'] ?? ''}'),
        Text('Customer: ${teksFilter['customer'] ?? ''}'),
        Text('Barang: ${teksFilter['barang'] ?? ''}'),
        Text('Periode Awal: ${teksFilter['awal_tanggal'] ?? ''}'),
        Text('Periode Akhir: ${teksFilter['akhir_tanggal'] ?? ''}'),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            _showFilterDialog();
          },
          icon: Icon(Icons.filter_alt),
          label: Text('Filter'),
        ),
      ],
    );
  }

  Widget _buildPenjualanCard(PenjualanHeader penjualanHeader) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('Institusi: ${penjualanHeader.cabang.nama}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Invoice: ${penjualanHeader.noInvoice}'),
                Text('Customer: ${penjualanHeader.customer.nama}'),
                Text('Tanggal Invoice: ${penjualanHeader.tanggalInvoice}'),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('No.')),
                DataColumn(label: Text('Nama Barang')),
                DataColumn(label: Text('QTY')),
                DataColumn(label: Text('Harga (Rp)')),
                DataColumn(label: Text('Diskon (%)')),
                DataColumn(label: Text('Subtotal (Rp)')),
              ],
              rows: _buildPenjualanDetailRows(penjualanHeader.penjualanDetailList),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('GRAND TOTAL: ${penjualanHeader.total}', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> _buildPenjualanDetailRows(List<PenjualanDetail> penjualanDetails) {
    return penjualanDetails.map((detail) {
      return DataRow(
        cells: [
          DataCell(Text((penjualanDetails.indexOf(detail) + 1).toString())),
          DataCell(Text(detail.barang.nama ?? '')),
          DataCell(Text('${detail.jumlah} ${detail.barang.satuan ?? ''}')),
          DataCell(Text(detail.harga.toString())),
          DataCell(Text(detail.diskon.toString())),
          DataCell(Text(detail.subtotal.toString())),
        ],
      );
    }).toList();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String cabangId = 'all';
        String customerId = 'all';
        String barangId = 'all';

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Filter Penjualan'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Institusi'),
                      items: detailPenjualanController.detailPenjualanCustomer?.cabangs
                          .map((cabang) => DropdownMenuItem<String>(
                                value: cabang.id.toString(),
                                child: Text(cabang.nama),
                              ))
                          .toList() ??
                          [],
                      onChanged: (value) {
                        setState(() {
                          cabangId = value ?? 'all';
                        });
                      },
                      value: cabangId != 'all' ? cabangId : null,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Customer'),
                      items: detailPenjualanController.detailPenjualanCustomer?.customers
                          .map((customer) => DropdownMenuItem<String>(
                                value: customer.id.toString(),
                                child: Text(customer.nama),
                              ))
                          .toList() ??
                          [],
                      onChanged: (value) {
                        setState(() {
                          customerId = value ?? 'all';
                        });
                      },
                      value: customerId != 'all' ? customerId : null,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Barang'),
                      items: detailPenjualanController.detailPenjualanCustomer?.barangs
                          .map((barang) => DropdownMenuItem<String>(
                                value: barang.id.toString(),
                                child: Text('${barang.kodeBarang} ${barang.nama}'),
                              ))
                          .toList() ??
                          [],
                      onChanged: (value) {
                        setState(() {
                          barangId = value ?? 'all';
                        });
                      },
                      value: barangId != 'all' ? barangId : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Periode Awal Tanggal Invoice'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            awalTanggal = pickedDate;
                          });
                        }
                      },
                      readOnly: true,
                      controller: TextEditingController(
                        text: awalTanggal == null ? '' : DateFormat('yyyy-MM-dd').format(awalTanggal!),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Periode Akhir Tanggal Invoice'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            akhirTanggal = pickedDate;
                          });
                        }
                      },
                      readOnly: true,
                      controller: TextEditingController(
                        text: akhirTanggal == null ? '' : DateFormat('yyyy-MM-dd').format(akhirTanggal!),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Batal'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Filter'),
                  onPressed: () {
                    detailPenjualanController.fetchDetailPenjualanCustomer(
                      cabangId: cabangId,
                      customerId: customerId,
                      barangId: barangId,
                      awalTanggal: awalTanggal != null ? DateFormat('yyyy-MM-dd').format(awalTanggal!) : '',
                      akhirTanggal: akhirTanggal != null ? DateFormat('yyyy-MM-dd').format(akhirTanggal!) : '',
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
