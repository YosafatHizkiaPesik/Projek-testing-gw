import 'dart:convert';

class PenjualanDetail {
  int id;
  int penjualanHeaderId;
  int barangId;
  int qty;
  String harga;
  String diskon;
  String total;
  Barang barang;

  PenjualanDetail({
    required this.id,
    required this.penjualanHeaderId,
    required this.barangId,
    required this.qty,
    required this.harga,
    required this.diskon,
    required this.total,
    required this.barang,
  });

  factory PenjualanDetail.fromJson(Map<String, dynamic> json) {
    return PenjualanDetail(
      id: json['id'],
      penjualanHeaderId: json['penjualan_header_id'],
      barangId: json['barang_id'],
      qty: json['qty'],
      harga: json['harga'],
      diskon: json['diskon'],
      total: json['total'],
      barang: Barang.fromJson(json['barang']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'penjualan_header_id': penjualanHeaderId,
      'barang_id': barangId,
      'qty': qty,
      'harga': harga,
      'diskon': diskon,
      'total': total,
      'barang': barang.toJson(),
    };
  }
}

class Barang {
  int id;
  String kodeBarang;
  String nama;

  Barang({
    required this.id,
    required this.kodeBarang,
    required this.nama,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['id'],
      kodeBarang: json['kode_barang'],
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode_barang': kodeBarang,
      'nama': nama,
    };
  }
}
