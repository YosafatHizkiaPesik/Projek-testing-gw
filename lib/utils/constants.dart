/// Base URL
const BASE_API_URL = 'https://apidev.dwijayagrup.id/api/';

class ApiEndpoints {
  // Auth
  static const AUTH_LOGIN = '${BASE_API_URL}auth/login';
  static const AUTH_ME = '${BASE_API_URL}auth/me';

  // Barang
  static const BARANG = '${BASE_API_URL}barang'; 

  // Customer
  static const CUSTOMER = '${BASE_API_URL}customer';

  // Stok
  static const STOK = '${BASE_API_URL}stok';

  // Laporan
  static const LAPORAN_KOMISI_SALES = '${BASE_API_URL}laporan_komisi_sales';
  static const LAPORAN_KOMISI_SALES_DETAIL = '${BASE_API_URL}laporan_komisi_sales/detail_per_sales';
  static const LAPORAN_KOMISI_SALES_PRINT = '${BASE_API_URL}laporan_komisi_sales/print_pdf';

  // Penjualan
  static const DETAIL_PENJUALAN_CUSTOMER = '${BASE_API_URL}detail_penjualan_customer';
  static const INVOICE_PENJUALAN = '${BASE_API_URL}invoice_penjualan';
  static const PENJUALAN_HEADER = '${BASE_API_URL}penjualan_header';
  static const PENJUALAN_HEADER_DETAIL = '${BASE_API_URL}penjualan_header/';

  // Penjualan Detail
  static const PENJUALAN_DETAIL = '${BASE_API_URL}penjualan_detail';
  static String penjualanDetailById(String id) => '${BASE_API_URL}penjualan_detail/$id';
}
