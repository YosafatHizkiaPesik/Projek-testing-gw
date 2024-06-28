class Sales {
  final int? id;
  final String? nama;
  final String? alamat;
  final String? noTelepon;
  final String? kota;

  Sales({
    this.id,
    this.nama,
    this.alamat,
    this.noTelepon,
    this.kota,
  });

  // Konversi dari JSON ke object Sales
  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      id: (json['id'] is String) ? int.tryParse(json['id']) : json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      noTelepon: json['no_telepon'],
      kota: json['kota'],
    );
  }
}
