class DetailPenjualanCustomer {
  final Map<String, String> teksFilter;
  final List<Cabang> cabangs;
  final List<Customer> customers;
  final List<Gudang> gudangs;
  final List<Barang> barangs;
  final List<PenjualanHeader> penjualanHeaders;

  DetailPenjualanCustomer({
    required this.teksFilter,
    required this.cabangs,
    required this.customers,
    required this.gudangs,
    required this.barangs,
    required this.penjualanHeaders,
  });

  factory DetailPenjualanCustomer.fromJson(Map<String, dynamic> json) {
    return DetailPenjualanCustomer(
      teksFilter: Map<String, String>.from(json['teks_filter']),
      cabangs: List<Cabang>.from(json['cabangs'].map((item) => Cabang.fromJson(item))),
      customers: List<Customer>.from(json['customers'].map((item) => Customer.fromJson(item))),
      gudangs: List<Gudang>.from(json['gudangs'].map((item) => Gudang.fromJson(item))),
      barangs: List<Barang>.from(json['barangs'].map((item) => Barang.fromJson(item))),
      penjualanHeaders: List<PenjualanHeader>.from(json['penjualan_headers'].map((item) => PenjualanHeader.fromJson(item))),
    );
  }
}

class Cabang {
  final int id;
  final String nama;

  Cabang({required this.id, required this.nama});

  factory Cabang.fromJson(Map<String, dynamic> json) {
    return Cabang(
      id: json['id'],
      nama: json['nama'],
    );
  }
}

class Customer {
  final int id;
  final String nama;

  Customer({required this.id, required this.nama});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      nama: json['nama'],
    );
  }
}

class Gudang {
  final int id;
  final String nama;

  Gudang({required this.id, required this.nama});

  factory Gudang.fromJson(Map<String, dynamic> json) {
    return Gudang(
      id: json['id'],
      nama: json['nama'],
    );
  }
}

class Barang {
  final int id;
  final String kodeBarang;
  final String nama;

  Barang({required this.id, required this.kodeBarang, required this.nama});

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['id'],
      kodeBarang: json['kode_barang'],
      nama: json['nama'],
    );
  }
}

class PenjualanHeader {
  final int id;
  final int cabangId;
  final int customerId;
  final String tanggal;
  final int gudangId;
  final String status;

  PenjualanHeader({
    required this.id,
    required this.cabangId,
    required this.customerId,
    required this.tanggal,
    required this.gudangId,
    required this.status,
  });

  factory PenjualanHeader.fromJson(Map<String, dynamic> json) {
    return PenjualanHeader(
      id: json['id'],
      cabangId: json['cabang_id'],
      customerId: json['customer_id'],
      tanggal: json['tanggal'],
      gudangId: json['gudang_id'],
      status: json['status'],
    );
  }
}
