import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../controllers/customer_controller.dart';
import '../../models/customer.dart';
import '../../widgets/menu_drawer.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final _drawerController = ZoomDrawerController();
  final customerController = CustomerController();
  late Future<CustomerResponse> futureCustomer;
  TextEditingController searchController = TextEditingController();
  bool showSearchBar = false;

  List<Customer> filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    futureCustomer = customerController.fetchCustomers();
  }

  Future<void> _refresh() async {
    setState(() {
      futureCustomer = customerController.fetchCustomers();
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
                      hintText: 'Cari customer...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      border: InputBorder.none,
                    ),
                    onChanged: (text) {
                      setState(() {
                        filteredCustomers = [];
                      });
                    },
                  ),
                )
              : Text('Customer'),
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
                        filteredCustomers = [];
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
          child: FutureBuilder<CustomerResponse>(
            future: futureCustomer,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.hasData && snapshot.data != null) {
                final customers = snapshot.data!.customers ?? [];

                filteredCustomers = customers.where((customer) {
                  return customer.nama!
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase());
                }).toList();

                return Column(
                  children: [
                    Expanded(
                      child: HorizontalDataTable(
                        leftHandSideColumnWidth: 50,
                        rightHandSideColumnWidth: 1150,
                        isFixedHeader: true,
                        headerWidgets: [
                          _getTitleItemWidget('No', 50),
                          _getTitleItemWidget('Nama Customer', 200),
                          _getTitleItemWidget('Alamat', 200),
                          _getTitleItemWidget('No. Telepon', 150),
                          _getTitleItemWidget('Kota', 100),
                          _getTitleItemWidget('Term of Payment', 150),
                          _getTitleItemWidget('Rekomendasi Harga', 150),
                          _getTitleItemWidget('Limit', 200),
                        ],
                        leftSideItemBuilder: (BuildContext context, int index) {
                          return _getBodyItemWidget((index + 1).toString(), 50);
                        },
                        rightSideItemBuilder: (BuildContext context, int index) {
                          return _getRowWidget(filteredCustomers[index], 1150);
                        },
                        itemCount: filteredCustomers.length,
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

  Widget _getRowWidget(Customer customer, double width) {
    return Container(
      width: width,
      height: 52,
      child: Row(
        children: <Widget>[
          _getBodyItemWidget(customer.nama ?? '', 200),
          _getBodyItemWidget(customer.alamat ?? '', 200),
          _getBodyItemWidget(customer.noTelepon ?? '', 150),
          _getBodyItemWidget(customer.kota ?? '', 100),
          _getBodyItemWidget(customer.termOfPayment ?? '', 150),
          _getBodyItemWidget(customer.rekomendasiHarga ?? '', 150),
          _getBodyItemWidget(customer.limit.toString(), 200),
        ],
      ),
    );
  }
}
