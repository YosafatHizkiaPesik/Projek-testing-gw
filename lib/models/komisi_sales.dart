class ListKomisiSales {
  final int totalPenjualanSemuaSales;
  final int totalHppSemuaSales;
  final int totalLabaSemuaSales;
  final int totalKomisiSemuaSales;
  final List<Sales> saleses;
  final FilterResult filterResult;

  ListKomisiSales({
    required this.totalPenjualanSemuaSales,
    required this.totalHppSemuaSales,
    required this.totalLabaSemuaSales,
    required this.totalKomisiSemuaSales,
    required this.saleses,
    required this.filterResult,
  });

  static ListKomisiSales fromJson(Map<String, dynamic> json) {
    return ListKomisiSales(
      totalPenjualanSemuaSales: json['total_penjualan_semua_sales'],
      totalHppSemuaSales: json['total_hpp_semua_sales'],
      totalLabaSemuaSales: json['total_laba_semua_sales'],
      totalKomisiSemuaSales: json['total_komisi_semua_sales'],
      saleses: (json['saleses'] as List)
          .map((item) => Sales.fromJson(item))
          .toList(),
      filterResult: FilterResult.fromJson(json['filter_result']),
    );
  }
}

class Sales {
  final int id;
  final String nama;
  final int totalPenjualan;
  final int totalHpp;
  final int totalLaba;
  final int persentaseLaba;
  final int totalKomisi;

  Sales({
    required this.id,
    required this.nama,
    required this.totalPenjualan,
    required this.totalHpp,
    required this.totalLaba,
    required this.persentaseLaba,
    required this.totalKomisi,
  });

  static Sales fromJson(Map<String, dynamic> json) {
    return Sales(
      id: json['id'],
      nama: json['nama'],
      totalPenjualan: json['total_penjualan'],
      totalHpp: json['total_hpp'],
      totalLaba: json['total_laba'],
      persentaseLaba: json['persentase_laba'],
      totalKomisi: json['total_komisi'],
    );
  }
}

class FilterResult {
  final Map<String, String> filters;
  final Map<String, String> teksFilter;

  FilterResult({
    required this.filters,
    required this.teksFilter,
  });

  static FilterResult fromJson(Map<String, dynamic> json) {
    return FilterResult(
      filters: Map<String, String>.from(json['filters']),
      teksFilter: Map<String, String>.from(json['teks_filter']),
    );
  }
}
