import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/penjualan_detail_controller.dart';
import '../../models/penjualan_detail.dart';

class PenjualanEditPage extends StatelessWidget {
  final int penjualanHeaderId;
  final PenjualanDetailController controller = Get.put(PenjualanDetailController());

  PenjualanEditPage({required this.penjualanHeaderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Penjualan'),
      ),
      body: FutureBuilder<void>(
        future: _initializeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: [
                    _buildPenjualanHeaderForm(),
                    Divider(),
                    _buildPenjualanDetailList(),
                  ],
                );
              }
            });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTambahDetailDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _initializeData() async {
    await controller.fetchPenjualanHeader(penjualanHeaderId);
    await controller.fetchPenjualanDetails(penjualanHeaderId);
  }

  Widget _buildPenjualanHeaderForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          children: [
            TextFormField(
              initialValue: controller.penjualanHeader['no_invoice'],
              decoration: InputDecoration(labelText: 'No Invoice'),
              readOnly: true,
            ),
            FutureBuilder<List<DropdownMenuItem<int>>>(
              future: controller.fetchSales().then((sales) {
                return sales.map((sale) {
                  var saleMap = sale as Map<String, dynamic>;
                  return DropdownMenuItem<int>(
                    value: saleMap['id'],
                    child: Text(saleMap['nama']),
                  );
                }).toList();
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Obx(() => DropdownButtonFormField<int>(
                    value: controller.penjualanHeader['sales_id'],
                    decoration: InputDecoration(labelText: 'Sales'),
                    items: snapshot.data,
                    onChanged: (value) => controller.penjualanHeader['sales_id'] = value,
                  ));
                }
              },
            ),
            FutureBuilder<List<DropdownMenuItem<int>>>(
              future: controller.fetchCustomers().then((customers) {
                return customers.map((customer) {
                  var customerMap = customer as Map<String, dynamic>;
                  return DropdownMenuItem<int>(
                    value: customerMap['id'],
                    child: Text(customerMap['nama']),
                  );
                }).toList();
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Obx(() => DropdownButtonFormField<int>(
                    value: controller.penjualanHeader['customer_id'],
                    decoration: InputDecoration(labelText: 'Customer'),
                    items: snapshot.data,
                    onChanged: (value) => controller.penjualanHeader['customer_id'] = value,
                  ));
                }
              },
            ),
            TextFormField(
              initialValue: controller.penjualanHeader['tanggal_so'],
              decoration: InputDecoration(labelText: 'Tanggal SO'),
              readOnly: true,
            ),
            TextFormField(
              initialValue: controller.penjualanHeader['keterangan'],
              decoration: InputDecoration(labelText: 'Keterangan'),
              onChanged: (value) => controller.penjualanHeader['keterangan'] = value,
            ),
            TextFormField(
              initialValue: controller.penjualanHeader['total_ongkir'].toString(),
              decoration: InputDecoration(labelText: 'Total Ongkir'),
              keyboardType: TextInputType.number,
              onChanged: (value) => controller.penjualanHeader['total_ongkir'] = double.parse(value),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.updatePenjualanHeader(penjualanHeaderId, controller.penjualanHeader.value),
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPenjualanDetailList() {
    return Expanded(
      child: Obx(() {
        if (controller.penjualanDetails.isEmpty) {
          return Center(child: Text('Belum ada data'));
        } else {
          return ListView.builder(
            itemCount: controller.penjualanDetails.length,
            itemBuilder: (context, index) {
              PenjualanDetail detail = controller.penjualanDetails[index];
              return ListTile(
                title: Text(detail.barangId.toString()),
                subtitle: Text('Jumlah: ${detail.jumlah}, Harga: ${detail.harga}, Diskon: ${detail.diskon}, Subtotal: ${detail.subtotal}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showEditDetailDialog(context, detail),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => controller.deletePenjualanDetail(detail.id, penjualanHeaderId),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }),
    );
  }

  void _showTambahDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Penjualan Detail'),
          content: _buildPenjualanDetailForm(context, isEdit: false),
        );
      },
    );
  }

  void _showEditDetailDialog(BuildContext context, PenjualanDetail detail) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Penjualan Detail'),
          content: _buildPenjualanDetailForm(context, detail: detail, isEdit: true),
        );
      },
    );
  }

  Widget _buildPenjualanDetailForm(BuildContext context, {PenjualanDetail? detail, required bool isEdit}) {
    final TextEditingController jumlahController = TextEditingController(text: isEdit ? detail!.jumlah.toString() : '');
    final TextEditingController hargaController = TextEditingController(text: isEdit ? detail!.harga : '');
    final TextEditingController diskonController = TextEditingController(text: isEdit ? detail!.diskon : '');
    final TextEditingController subtotalController = TextEditingController(text: isEdit ? detail!.subtotal : '');

    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder<List<DropdownMenuItem<int>>>(
            future: controller.fetchSales().then((sales) {
              return sales.map((sale) {
                var saleMap = sale as Map<String, dynamic>;
                return DropdownMenuItem<int>(
                  value: saleMap['id'],
                  child: Text(saleMap['nama']),
                );
              }).toList();
            }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: 'Barang'),
                  items: snapshot.data,
                  onChanged: (value) => isEdit ? detail!.barangId = value! : {},
                );
              }
            },
          ),
          FutureBuilder<List<DropdownMenuItem<int>>>(
            future: controller.fetchCustomers().then((customers) {
              return customers.map((customer) {
                var customerMap = customer as Map<String, dynamic>;
                return DropdownMenuItem<int>(
                  value: customerMap['id'],
                  child: Text(customerMap['nama']),
                );
              }).toList();
            }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: 'Gudang'),
                  items: snapshot.data,
                  onChanged: (value) => isEdit ? detail!.gudangId = value! : {},
                );
              }
            },
          ),
          TextFormField(
            controller: jumlahController,
            decoration: InputDecoration(labelText: 'Jumlah'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: hargaController,
            decoration: InputDecoration(labelText: 'Harga'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: diskonController,
            decoration: InputDecoration(labelText: 'Diskon'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: subtotalController,
            decoration: InputDecoration(labelText: 'Subtotal'),
            keyboardType: TextInputType.number,
            readOnly: true,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (isEdit) {
                controller.updatePenjualanDetail(detail!.id, {
                  'barang_id': detail.barangId,
                  'gudang_id': detail.gudangId,
                  'jumlah': jumlahController.text,
                  'harga': hargaController.text,
                  'diskon': diskonController.text,
                });
              } else {
                controller.addPenjualanDetail({
                  'penjualan_header_id': penjualanHeaderId,
                  'barang_id': detail!.barangId,
                  'gudang_id': detail.gudangId,
                  'jumlah': jumlahController.text,
                  'harga': hargaController.text,
                  'diskon': diskonController.text,
                });
              }
              Navigator.pop(context);
            },
            child: Text(isEdit ? 'Edit' : 'Tambah'),
          ),
        ],
      ),
    );
  }
}
