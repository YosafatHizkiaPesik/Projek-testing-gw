import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../widgets/menu_drawer.dart';
import '../../controllers/laporan_controller.dart';

class LaporanPage extends StatefulWidget {
  @override
  _LaporanPageState createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  final _drawerController = ZoomDrawerController();
  final dateFormat = DateFormat('yyyy-MM-dd');
  DateTime _selectedStartDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _selectedEndDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStart ? _selectedStartDate : _selectedEndDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _selectedStartDate = pickedDate;
        } else {
          _selectedEndDate = pickedDate;
        }
      });
    }
  }

  Future<void> _handleRefresh() async {
    final controller = Get.find<LaporanController>();
    await controller.refreshReports(
      awalTanggal: dateFormat.format(_selectedStartDate),
      akhirTanggal: dateFormat.format(_selectedEndDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LaporanController());

    return ZoomDrawer(
      controller: _drawerController,
      menuScreen: MenuDrawer(),
      mainScreen: Scaffold(
        appBar: AppBar(
          title: Text("Laporan Komisi"),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _drawerController.toggle!();
            },
          ),
        ),
        body: LiquidPullToRefresh(
          onRefresh: _handleRefresh,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card untuk filter
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filter Laporan Komisi Sales',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Periode Awal'),
                                  SizedBox(height: 8),
                                  TextField(
                                    readOnly: true,
                                    controller: TextEditingController()
                                      ..text = dateFormat.format(_selectedStartDate),
                                    onTap: () async {
                                      _selectDate(context, true);
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      suffixIcon: Icon(Icons.calendar_today),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Periode Akhir'),
                                  SizedBox(height: 8),
                                  TextField(
                                    readOnly: true,
                                    controller: TextEditingController()
                                      ..text = dateFormat.format(_selectedEndDate),
                                    onTap: () async {
                                      _selectDate(context, false);
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      suffixIcon: Icon(Icons.calendar_today),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Tombol Download PDF
                        ElevatedButton(
                          onPressed: () async {
                            String start = dateFormat.format(_selectedStartDate);
                            String end = dateFormat.format(_selectedEndDate);
                            print("Downloading PDF with period: $start to $end"); // Log period
                            await controller.downloadPdf(
                              awalTanggal: start,
                              akhirTanggal: end,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('PDF berhasil diunduh dan dibuka')),
                            );
                          },
                          child: Text('Download PDF'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
