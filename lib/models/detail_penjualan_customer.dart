// Model untuk Detail Penjualan Customer
class DetailPenjualanCustomer {
  final Map<String, String> teksFilter;
  final List<Cabang> cabangs;
  final List<Customer> customers;
  final List<Gudang> gudangs;
  final List<Barang> barangs;
  final List<PenjualanHeader> penjualanHeaders;

  // Konstruktor untuk inisialisasi
  DetailPenjualanCustomer({
    required this.teksFilter,
    required this.cabangs,
    required this.customers,
    required this.gudangs,
    required this.barangs,
    required this.penjualanHeaders,
  });

  // Fungsi untuk mengubah dari JSON ke object
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

// Model untuk Cabang
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

// Model untuk Customer
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

// Model untuk Gudang
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

// Model untuk Barang
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

// Model untuk Detail Penjualan Customer Response
class DetailPenjualanCustomerResponse {
  final String status;
  final DetailPenjualanCustomer data;

  DetailPenjualanCustomerResponse({
    required this.status,
    required this.data,
  });

  factory DetailPenjualanCustomerResponse.fromJson(Map<String, dynamic> json) {
    return DetailPenjualanCustomerResponse(
      status: json['status'],
      data: DetailPenjualanCustomer.fromJson(json['data']),
    );
  }
}

// Model untuk Penjualan Header
class PenjualanHeader {
  final int id;
  final int cabangId;
  final int customerId;
  final int salesId;
  final int userKirimId;
  final String aliasCabang;
  final int noInvoice;
  final String tanggalInvoice;
  final String tanggalJatuhTempoInvoice;
  final String tanggalKirim;
  final int total;
  final int totalOngkir;
  final String payment;
  final String keterangan;
  final int statusPenjualan;
  final int statusKirim;
  final int createdBy;
  final int updatedBy;
  final String createdAt;
  final String updatedAt;
  final String? deletedBy;
  final String? ipAddress;
  final String? kotaCreatedIn;

  PenjualanHeader({
    required this.id,
    required this.cabangId,
    required this.customerId,
    required this.salesId,
    required this.userKirimId,
    required this.aliasCabang,
    required this.noInvoice,
    required this.tanggalInvoice,
    required this.tanggalJatuhTempoInvoice,
    required this.tanggalKirim,
    required this.total,
    required this.totalOngkir,
    required this.payment,
    required this.keterangan,
    required this.statusPenjualan,
    required this.statusKirim,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedBy,
    this.ipAddress,
    this.kotaCreatedIn,
  });

  factory PenjualanHeader.fromJson(Map<String, dynamic> json) {
    return PenjualanHeader(
      id: json['id'],
      cabangId: json['cabang_id'],
      customerId: json['customer_id'],
      salesId: json['sales_id'],
      userKirimId: json['user_kirim_id'],
      aliasCabang: json['alias_cabang'],
      noInvoice: json['no_invoice'],
      tanggalInvoice: json['tanggal_invoice'],
      tanggalJatuhTempoInvoice: json['tanggal_jatuh_tempo_invoice'],
      tanggalKirim: json['tanggal_kirim'],
      total: json['total'],
      totalOngkir: json['total_ongkir'],
      payment: json['payment'],
      keterangan: json['keterangan'],
      statusPenjualan: json['status_penjualan'],
      statusKirim: json['status_kirim'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedBy: json['deleted_by'],
      ipAddress: json['ip_address'],
      kotaCreatedIn: json['kota_created_in'],
    );
  }
}
