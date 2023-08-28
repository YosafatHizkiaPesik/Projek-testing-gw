class StockResponse {
  final List<Stock> stocks;
  final Map<String, dynamic> filterResult;

  StockResponse({
    required this.stocks,
    required this.filterResult,
  });

  factory StockResponse.fromJson(Map<String, dynamic> json) {
    return StockResponse(
      stocks: (json['barangs'] as List).map((e) => Stock.fromJson(e)).toList(),
      filterResult: json['filter_result'],
    );
  }
}

class Stock {
  final int id;
  final String kodeBarang;
  final String nama;
  final String satuan;
  final List<StockList> stokList;

  Stock({
    required this.id,
    required this.kodeBarang,
    required this.nama,
    required this.satuan,
    required this.stokList,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      kodeBarang: json['kode_barang'],
      nama: json['nama'],
      satuan: json['satuan'],
      stokList: (json['stok_list'] as List).map((e) => StockList.fromJson(e)).toList(),
    );
  }
}

class StockList {
  final int jumlah;
  final int barangId;
  final int gudangId;
  final Gudang gudang;

  StockList({
    required this.jumlah,
    required this.barangId,
    required this.gudangId,
    required this.gudang,
  });

  factory StockList.fromJson(Map<String, dynamic> json) {
    return StockList(
      jumlah: json['jumlah'] is String ? int.parse(json['jumlah']) : json['jumlah'],
      barangId: json['barang_id'] is String ? int.parse(json['barang_id']) : json['barang_id'],
      gudangId: json['gudang_id'] is String ? int.parse(json['gudang_id']) : json['gudang_id'],
      gudang: Gudang.fromJson(json['gudang']),
    );
  }
}

class Gudang {
  final int id;
  final String nama;

  Gudang({
    required this.id,
    required this.nama,
  });

  factory Gudang.fromJson(Map<String, dynamic> json) {
    return Gudang(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      nama: json['nama'],
    );
  }
}
