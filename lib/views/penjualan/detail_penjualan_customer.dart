// import 'package:flutter/material.dart';
// import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
// import 'package:horizontal_data_table/horizontal_data_table.dart';
// import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
// import '../../controllers/detail_penjualan_customer_controller.dart';
// import '../../models/detail_penjualan_customer.dart';
// import '../../widgets/menu_drawer.dart';

// class DetailPenjualanCustomerPage extends StatefulWidget {
//   @override
//   _DetailPenjualanCustomerPageState createState() => _DetailPenjualanCustomerPageState();
// }

// class _DetailPenjualanCustomerPageState extends State<DetailPenjualanCustomerPage> {
//   final _drawerController = ZoomDrawerController();
//   final detailPenjualanCustomerController = DetailPenjualanCustomerController();
//   late Future<DetailPenjualanCustomerResponse> futureDetailPenjualanCustomer;
//   List<DetailPenjualanCustomer> filteredDetails = [];
//   TextEditingController searchController = TextEditingController();
//   bool showSearchBar = false;

//   int currentPage = 1;
//   int itemsPerPage = 10;

//   @override
//   void initState() {
//     super.initState();
//     futureDetailPenjualanCustomer = detailPenjualanCustomerController.fetchDetailPenjualan();
//   }

//   Future<void> _refresh() async {
//     await detailPenjualanCustomerController.fetchDetailPenjualan();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ZoomDrawer(
//       controller: _drawerController,
//       menuScreen: MenuDrawer(),
//       mainScreen: Scaffold(
//         appBar: AppBar(
//           title: showSearchBar ? TextField(
//             // Implement your search bar here
//           ) : Text('Detail Penjualan Customer'),
//           leading: IconButton(
//             icon: Icon(Icons.menu),
//             onPressed: () {
//               _drawerController.toggle!();
//             },
//           ),
//           actions: [
//             // Implement your action buttons here
//           ],
//         ),
//         body: LiquidPullToRefresh(
//           onRefresh: _refresh,
//           showChildOpacityTransition: false,
//           child: FutureBuilder<DetailPenjualanCustomerResponse>(
//             future: futureDetailPenjualanCustomer,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               }
//               if (snapshot.hasData && snapshot.data != null) {
//                 final details = snapshot.data!.details ?? [];
//                 filteredDetails = details;
//                 return HorizontalDataTable(
//                   leftHandSideColumnWidth: 50,
//                   rightHandSideColumnWidth: 600,
//                   isFixedHeader: true,
//                   headerWidgets: [
//                     _getTitleItemWidget('ID', 50),
//                     _getTitleItemWidget('Nama Produk', 200),
//                     _getTitleItemWidget('Jumlah', 100),
//                     _getTitleItemWidget('Harga', 100),
//                     _getTitleItemWidget('Total', 150),
//                   ],
//                   leftSideItemBuilder: (context, index) => _getRowNumber(index),
//                   rightSideItemBuilder: (context, index) => _getRowDetail(filteredDetails[index]),
//                   itemCount: filteredDetails.length,
//                   rowSeparatorWidget: const Divider(color: Colors.black54, height: 1.0, thickness: 0.0),
//                   leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
//                   rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
//                 );
//               } else {
//                 return Center(child: Text('No Data Available'));
//               }
//             },
//           ),
//         ),
//       ),
//       borderRadius: 24.0,
//       showShadow: true,
//       angle: -12.0,
//       slideWidth: MediaQuery.of(context).size.width * 0.65,
//     );
//   }

//   Widget _getRowNumber(int index) {
//     return Container(
//       child: Text('${index + 1}'),
//       width: 50,
//       height: 52,
//       padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
//       alignment: Alignment.centerLeft,
//     );
//   }

//   Widget _getTitleItemWidget(String label, double width) {
//     return Container(
//       child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
//       width: width,
//       height: 56,
//       padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
//       alignment: Alignment.centerLeft,
//     );
//   }

//   Widget _getRowDetail(DetailPenjualanCustomer detail) {
//     return Row(
//       children: [
//         _getRowItemWidget(detail.id ?? '', 50),
//         _getRowItemWidget(detail.namaProduk ?? '', 200),
//         _getRowItemWidget(detail.jumlah.toString(), 100),
//         _getRowItemWidget(detail.harga.toString(), 100),
//         _getRowItemWidget((detail.jumlah * detail.harga).toString(), 150),
//       ],
//     );
//   }

//   Widget _getRowItemWidget(String item, double width) {
//     return Container(
//       child: Text(item),
//       width: width,
//       height: 52,
//       padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
//       alignment: Alignment.centerLeft,
//     );
//   }
// }
