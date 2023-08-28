class Customer {
  final int? id;
  final String? nama;
  final String? alamat;
  final String? noTelepon;
  final String? kota;
  final String? termOfPayment;
  final String? rekomendasiHarga;
  final int? limit;

  Customer({
    this.id,
    this.nama,
    this.alamat,
    this.noTelepon,
    this.kota,
    this.termOfPayment,
    this.rekomendasiHarga,
    this.limit,
  });

  // Konversi dari JSON ke object Customer
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: (json['id'] is String) ? int.tryParse(json['id']) : json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      noTelepon: json['no_telepon'],
      kota: json['kota'],
      termOfPayment: json['term_of_payment'],
      rekomendasiHarga: json['rekomendasi_harga'],
      limit: (json['limit'] is String) ? int.tryParse(json['limit']) ?? 0 : json['limit'],
    );
  }
}

class CustomerResponse {
  final List<Customer>? customers;

  CustomerResponse({this.customers});

  // Konversi dari JSON ke object CustomerResponse
  factory CustomerResponse.fromJson(Map<String, dynamic> json) {
    return CustomerResponse(
      customers: (json['customers'] as List<dynamic>?)
          ?.map((item) => Customer.fromJson(item as Map<String, dynamic>))
          ?.toList(),
    );
  }
}
