import 'dart:convert';

class PenjualanDetail {
  int id;
  int penjualanHeaderId;
  int barangId;
  int gudangId;
  String harga;
  int jumlah;
  String diskon;
  String subtotal;

  PenjualanDetail({
    required this.id,
    required this.penjualanHeaderId,
    required this.barangId,
    required this.gudangId,
    required this.harga,
    required this.jumlah,
    required this.diskon,
    required this.subtotal,
  });

  factory PenjualanDetail.fromJson(Map<String, dynamic> json) {
    return PenjualanDetail(
      id: json['id'],
      penjualanHeaderId: json['penjualan_header_id'],
      barangId: json['barang_id'],
      gudangId: json['gudang_id'],
      harga: json['harga'].toString(), // Mengonversi harga ke string
      jumlah: json['jumlah'],
      diskon: json['diskon'].toString(), // Mengonversi diskon ke string
      subtotal: json['subtotal'].toString(), // Mengonversi subtotal ke string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'penjualan_header_id': penjualanHeaderId,
      'barang_id': barangId,
      'gudang_id': gudangId,
      'harga': harga,
      'jumlah': jumlah,
      'diskon': diskon,
      'subtotal': subtotal,
    };
  }
}
