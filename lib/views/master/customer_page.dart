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
  List<Customer> filteredCustomers = [];
  TextEditingController searchController = TextEditingController();
  bool showSearchBar = false;

  int currentPage = 1;
  int itemsPerPage = 10; 
  int totalCustomers = 0; 


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
          // Bagian pencarian customer
          title: showSearchBar
              ? Autocomplete<Customer>(
                  optionsBuilder: (textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<Customer>.empty();
                    }
                    return filteredCustomers.where((customer) {
                      return customer.nama!
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  // Bagian dropdown hasil pencarian
                  optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<Customer> onSelected, Iterable<Customer> options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        child: ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Customer option = options.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                              },
                              child: ListTile(
                                title: Text(option.nama!),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  // Bagian input pencarian
                  fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextField(
                        controller: searchController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          hintText: 'Cari customer...',
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.transparent, width: 0),
                          ),
                        ),
                        onChanged: (text) {
                          setState(() {
                            filteredCustomers = filteredCustomers.where((customer) {
                              return customer.nama!
                                  .toLowerCase()
                                  .contains(text.toLowerCase());
                            }).toList();
                          });
                        },
                      ),
                    );
                  },
                  onSelected: (Customer selection) {
                    print("Anda memilih: ${selection.nama}");
                  },
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
        // Bagian isi halaman customer
        body: LiquidPullToRefresh(
          onRefresh: _refresh,
          showChildOpacityTransition: false,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: DropdownButton<int>(
                    value: itemsPerPage,
                    items: [10, 25, 50]
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text("$value"),
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        itemsPerPage = newValue!;
                        currentPage = 1; 
                      });
                    },
                  ),
                ),
              ),
              Expanded(
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
                      filteredCustomers = customers
                          .where((customer) => customer.nama!
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase()))
                          .toList();
                      return HorizontalDataTable(
                        leftHandSideColumnWidth: 50,
                        rightHandSideColumnWidth: 50 + 200 + 100 + 100 + 100 + 100 + 100 + 100,

                        isFixedHeader: true,
                        //Header table
                        headerWidgets: [
                          _getTitleItemWidget('No', 50),
                          _getTitleItemWidget('Nama Customer', 200),
                          _getTitleItemWidget('Alamat', 100),
                          _getTitleItemWidget('No. Telepon', 100),
                          _getTitleItemWidget('Kota', 100),
                          _getTitleItemWidget('Term of Payment', 100),
                          _getTitleItemWidget('Rekomendasi Harga', 100),
                          _getTitleItemWidget('Limit', 100),
                        ],
                        leftSideItemBuilder: (BuildContext context, int index) {
                          return _getBodyItemWidget((index + 1).toString(), 50);
                        },
                        rightSideItemBuilder: (BuildContext context, int index) {
                          return _getRowWidget(filteredCustomers[index], 600);
                        },
                        itemCount: filteredCustomers.length,
                        rowSeparatorWidget: const Divider(
                          color: Colors.black54,
                          height: 1.0,
                          thickness: 0.0,
                        ),
                        leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                        rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                      );
                    } else {
                      return Center(child: Text('Data tidak tersedia.'));
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.first_page),
                    onPressed: () {
                      if (currentPage != 1) {
                        setState(() {
                          currentPage = 1;
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      if (currentPage > 1) {
                        setState(() {
                          currentPage--;
                        });
                      }
                    },
                  ),
                  Text('Halaman $currentPage dari ${(filteredCustomers.length / itemsPerPage).ceil()}'),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      if (currentPage < (filteredCustomers.length / itemsPerPage).ceil()) {
                        setState(() {
                          currentPage++;
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.last_page),
                    onPressed: () {
                      int lastPage = (filteredCustomers.length / itemsPerPage).ceil();
                      if (currentPage != lastPage) {
                        setState(() {
                          currentPage = lastPage;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      borderRadius: 24.0,
      showShadow: true,
      angle: -12.0,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
    );
  }

  // Widget untuk menampilkan judul kolom
  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  // Widget untuk menampilkan item di setiap baris
Widget _getBodyItemWidget(String label, double width) {
    return Container(
      child: Text(label),
      width: width,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  // Widget untuk menampilkan data customer di setiap baris
  Widget _getRowWidget(Customer item, double width) {
    return Row(
      children: <Widget>[
        _getBodyItemWidget(item.nama ?? '', 200),
        _getBodyItemWidget(item.alamat ?? '', 100),
        _getBodyItemWidget(item.noTelepon ?? '', 100),
        _getBodyItemWidget(item.kota ?? '', 100),
        _getBodyItemWidget(item.termOfPayment ?? '', 100),
        _getBodyItemWidget(item.rekomendasiHarga ?? '', 100),
        _getBodyItemWidget(item.limit != null ? item.limit.toString() : "Data kosong", 100),
      ],
    );
  }

}
