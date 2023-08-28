import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../widgets/menu_drawer.dart';  
import '../../controllers/laporan_controller.dart';  

class LaporanPage extends StatefulWidget {
  final _drawerController = ZoomDrawerController();

  @override
  _LaporanPageState createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  final dateFormat = DateFormat('dd/MM/yyyy');
  DateTime _selectedStartDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _selectedEndDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        if (isStart) {
          _selectedStartDate = pickedDate;
        } else {
          _selectedEndDate = pickedDate;
        }
      });
    }
  }

  // Inisialisasi data pada saat pertama kali
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final controller = Get.find<LaporanController>(); 
      controller.refreshReports();
    });
  }

  Future<void> _handleRefresh() async {
    final controller = Get.find<LaporanController>();
    await controller.refreshReports();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LaporanController>();
    
    return ZoomDrawer(
      controller: widget._drawerController,
      menuScreen: MenuDrawer(),
      mainScreen: Scaffold(
        appBar: AppBar(
          title: Text("Laporan Komisi"),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              if (ZoomDrawer.of(context)?.isOpen() ?? false) {
                ZoomDrawer.of(context)?.close();
              } else {
                ZoomDrawer.of(context)?.open();
              }
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
                              ..text = dateFormat.format(_selectedStartDate), // Set default value
                            onTap: () async {
                              _selectDate(context, true);
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today)
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
                              ..text = dateFormat.format(_selectedEndDate), // Set default value
                            onTap: () async {
                              _selectDate(context, false);
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    controller.refreshReports();
                  },
                  child: Text('Tampilkan Laporan'),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        // Tabel laporan
        Expanded(
          child: controller.isLoading
            ? CircularProgressIndicator()
            : controller.listKomisiSales != null && controller.listKomisiSales!.saleses.isNotEmpty
              ? ListView.builder(
                  itemCount: controller.listKomisiSales!.saleses.length,
                  itemBuilder: (context, index) {
                    final sales = controller.listKomisiSales!.saleses[index];
                    return Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text(sales.nama),
                        subtitle: Text('Total Penjualan: ${sales.totalPenjualan}'),
                        trailing: Text('Total Komisi: ${sales.totalKomisi}'),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text('Data tidak tersedia'),
                ),
        ),
      ],
    ),
  ),
),
      ),
      borderRadius: 24.0,
      showShadow: true,
      angle: -12.0,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
    );
  }
}
