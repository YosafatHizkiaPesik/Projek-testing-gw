class DetailPenjualanCustomer {
  final Map<String, String?> teksFilter;
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
      teksFilter: Map<String, String?>.from(json['teks_filter']),
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
      nama: json['nama'] ?? '', // Handle null case
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
      nama: json['nama'] ?? '', // Handle null case
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
      nama: json['nama'] ?? '', // Handle null case
    );
  }
}

class Barang {
  final int id;
  final String kodeBarang;
  final String nama;
  final String? satuan; // Make this nullable

  Barang({required this.id, required this.kodeBarang, required this.nama, this.satuan});

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['id'],
      kodeBarang: json['kode_barang'] ?? '', // Handle null case
      nama: json['nama'] ?? '', // Handle null case
      satuan: json['satuan'], // Handle null case
    );
  }
}

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

  final Cabang cabang;
  final Customer customer;
  final List<PenjualanDetail> penjualanDetailList;

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
    required this.cabang,
    required this.customer,
    required this.penjualanDetailList,
  });

  factory PenjualanHeader.fromJson(Map<String, dynamic> json) {
    return PenjualanHeader(
      id: json['id'],
      cabangId: json['cabang_id'],
      customerId: json['customer_id'],
      salesId: json['sales_id'],
      userKirimId: json['user_kirim_id'],
      aliasCabang: json['alias_cabang'] ?? '', // Handle null case
      noInvoice: json['no_invoice'],
      tanggalInvoice: json['tanggal_invoice'] ?? '', // Handle null case
      tanggalJatuhTempoInvoice: json['tanggal_jatuh_tempo_invoice'] ?? '', // Handle null case
      tanggalKirim: json['tanggal_kirim'] ?? '', // Handle null case
      total: json['total'],
      totalOngkir: json['total_ongkir'],
      payment: json['payment'] ?? '', // Handle null case
      keterangan: json['keterangan'] ?? '', // Handle null case
      statusPenjualan: json['status_penjualan'],
      statusKirim: json['status_kirim'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      createdAt: json['created_at'] ?? '', // Handle null case
      updatedAt: json['updated_at'] ?? '', // Handle null case
      deletedBy: json['deleted_by'],
      ipAddress: json['ip_address'],
      kotaCreatedIn: json['kota_created_in'],
      cabang: Cabang.fromJson(json['cabang']),
      customer: Customer.fromJson(json['customer']),
      penjualanDetailList: List<PenjualanDetail>.from(json['penjualan_detail_list'].map((item) => PenjualanDetail.fromJson(item))),
    );
  }
}

class PenjualanDetail {
  final int id;
  final int penjualanHeaderId;
  final int barangId;
  final int gudangId;
  final int harga;
  final int jumlah;
  final int diskon;
  final int subtotal;
  final int hpp;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  final Barang barang;

  PenjualanDetail({
    required this.id,
    required this.penjualanHeaderId,
    required this.barangId,
    required this.gudangId,
    required this.harga,
    required this.jumlah,
    required this.diskon,
    required this.subtotal,
    required this.hpp,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.barang,
  });

  factory PenjualanDetail.fromJson(Map<String, dynamic> json) {
    return PenjualanDetail(
      id: json['id'],
      penjualanHeaderId: json['penjualan_header_id'],
      barangId: json['barang_id'],
      gudangId: json['gudang_id'],
      harga: json['harga'],
      jumlah: json['jumlah'],
      diskon: json['diskon'],
      subtotal: json['subtotal'],
      hpp: json['hpp'],
      createdAt: json['created_at'] ?? '', // Handle null case
      updatedAt: json['updated_at'] ?? '', // Handle null case
      deletedAt: json['deleted_at'],
      barang: Barang.fromJson(json['barang']),
    );
  }
}
