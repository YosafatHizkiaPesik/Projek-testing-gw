import 'dart:convert';

class PenjualanHeader {
  int id;
  int cabangId;
  int customerId;
  int salesId;
  String aliasCabang;
  String noInvoice;
  String tanggalInvoice;
  String tanggalJatuhTempoInvoice;
  String? tanggalKirim;
  String total;
  String totalOngkir;
  String payment;
  String? keterangan;
  int statusPenjualan;
  int statusKirim;
  int createdBy;
  int updatedBy;
  int? deletedBy;
  String createdAt;
  String updatedAt;
  String? deletedAt;
  String? ipAddress;
  String? kotaCreatedIn;
  int statusPosting;
  UserKirim? userKirim;
  Cabang cabang;
  Customer customer;
  Sales sales;

  PenjualanHeader({
    required this.id,
    required this.cabangId,
    required this.customerId,
    required this.salesId,
    required this.aliasCabang,
    required this.noInvoice,
    required this.tanggalInvoice,
    required this.tanggalJatuhTempoInvoice,
    this.tanggalKirim,
    required this.total,
    required this.totalOngkir,
    required this.payment,
    this.keterangan,
    required this.statusPenjualan,
    required this.statusKirim,
    required this.createdBy,
    required this.updatedBy,
    this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.ipAddress,
    this.kotaCreatedIn,
    required this.statusPosting,
    this.userKirim,
    required this.cabang,
    required this.customer,
    required this.sales,
  });

  factory PenjualanHeader.fromJson(Map<String, dynamic> json) {
    return PenjualanHeader(
      id: json['id'],
      cabangId: int.parse(json['cabang_id']),
      customerId: int.parse(json['customer_id']),
      salesId: int.parse(json['sales_id']),
      aliasCabang: json['alias_cabang'],
      noInvoice: json['no_invoice'],
      tanggalInvoice: json['tanggal_invoice'],
      tanggalJatuhTempoInvoice: json['tanggal_jatuh_tempo_invoice'],
      tanggalKirim: json['tanggal_kirim'],
      total: json['total'],
      totalOngkir: json['total_ongkir'],
      payment: json['payment'],
      keterangan: json['keterangan'],
      statusPenjualan: int.parse(json['status_penjualan']),
      statusKirim: int.parse(json['status_kirim']),
      createdBy: int.parse(json['created_by']),
      updatedBy: int.parse(json['updated_by']),
      deletedBy: json['deleted_by'] != null ? int.parse(json['deleted_by']) : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      ipAddress: json['ip_address'],
      kotaCreatedIn: json['kota_created_in'],
      statusPosting: json['status_posting'],
      userKirim: json['user_kirim'] != null ? UserKirim.fromJson(json['user_kirim']) : null,
      cabang: Cabang.fromJson(json['cabang']),
      customer: Customer.fromJson(json['customer']),
      sales: Sales.fromJson(json['sales']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cabang_id': cabangId,
      'customer_id': customerId,
      'sales_id': salesId,
      'alias_cabang': aliasCabang,
      'no_invoice': noInvoice,
      'tanggal_invoice': tanggalInvoice,
      'tanggal_jatuh_tempo_invoice': tanggalJatuhTempoInvoice,
      'tanggal_kirim': tanggalKirim,
      'total': total,
      'total_ongkir': totalOngkir,
      'payment': payment,
      'keterangan': keterangan,
      'status_penjualan': statusPenjualan,
      'status_kirim': statusKirim,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'ip_address': ipAddress,
      'kota_created_in': kotaCreatedIn,
      'status_posting': statusPosting,
      'user_kirim': userKirim?.toJson(),
      'cabang': cabang.toJson(),
      'customer': customer.toJson(),
      'sales': sales.toJson(),
    };
  }
}

class UserKirim {
  int? id;
  String? nama;

  UserKirim({
    this.id,
    this.nama,
  });

  factory UserKirim.fromJson(Map<String, dynamic> json) {
    return UserKirim(
      id: json['id'],
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
    };
  }
}

class Cabang {
  int id;
  String nama;

  Cabang({required this.id, required this.nama});

  factory Cabang.fromJson(Map<String, dynamic> json) {
    return Cabang(
      id: json['id'],
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
    };
  }
}

class Customer {
  int id;
  String nama;

  Customer({required this.id, required this.nama});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
    };
  }
}

class Sales {
  int id;
  String nama;

  Sales({required this.id, required this.nama});

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      id: json['id'],
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
    };
  }
}
