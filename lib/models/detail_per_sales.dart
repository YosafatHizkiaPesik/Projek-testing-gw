import 'package:dwijaya_sales_app/models/komisi_sales.dart';

class DetailPerSales {
  final List<dynamic> penjualanHeaders;
  final KomisiSales komisiSales;
  final Filters filters;

  DetailPerSales({
    required this.penjualanHeaders,
    required this.komisiSales,
    required this.filters,
  });

  static DetailPerSales fromJson(Map<String, dynamic> json) {
    return DetailPerSales(
      penjualanHeaders: json['penjualan_headers'],
      komisiSales: KomisiSales.fromJson(json['komisi_sales']),
      filters: Filters.fromJson(json['filters']),
    );
  }
}

class KomisiSales {
  final int totalPenjualan;
  final int totalHpp;
  final int totalLaba;
  final int persentaseLaba;
  final int totalKomisi;

  KomisiSales({
    required this.totalPenjualan,
    required this.totalHpp,
    required this.totalLaba,
    required this.persentaseLaba,
    required this.totalKomisi,
  });

  static KomisiSales fromJson(Map<String, dynamic> json) {
    return KomisiSales(
      totalPenjualan: json['total_penjualan'],
      totalHpp: json['total_hpp'],
      totalLaba: json['total_laba'],
      persentaseLaba: json['persentase_laba'],
      totalKomisi: json['total_komisi'],
    );
  }
}

class Filters {
  final Sales sales;
  final String awalTanggal;
  final String akhirTanggal;

  Filters({
    required this.sales,
    required this.awalTanggal,
    required this.akhirTanggal,
  });

  static Filters fromJson(Map<String, dynamic> json) {
    return Filters(
      sales: Sales.fromJson(json['sales']),
      awalTanggal: json['awal_tanggal'],
      akhirTanggal: json['akhir_tanggal'],
    );
  }
}
