import 'dart:convert';

class BarangResponse {
  final FilterResult? filterResult;
  final List<BarangCategory>? barangCategories;
  final List<Barang>? barangs;

  BarangResponse({this.filterResult, this.barangCategories, this.barangs});

  factory BarangResponse.fromJson(Map<String, dynamic> json) {
    return BarangResponse(
      filterResult: FilterResult.fromJson(json['filter_result']),
      barangCategories: (json['barang_categories'] as List)
          .map((e) => BarangCategory.fromJson(e))
          .toList(),
      barangs: (json['barangs'] as List)
          .map((e) => Barang.fromJson(e))
          .toList(),
    );
  }
}

class FilterResult {
  final Filters? filters;
  final TeksFilter? teksFilter;

  FilterResult({this.filters, this.teksFilter});

  factory FilterResult.fromJson(Map<String, dynamic> json) {
    return FilterResult(
      filters: Filters.fromJson(json['filters']),
      teksFilter: TeksFilter.fromJson(json['teks_filter']),
    );
  }
}

class Filters {
  final String? barangCategoryId;

  Filters({this.barangCategoryId});

  factory Filters.fromJson(Map<String, dynamic> json) {
    return Filters(
      barangCategoryId: json['barang_category_id'],
    );
  }
}

class TeksFilter {
  final String? barangCategory;

  TeksFilter({this.barangCategory});

  factory TeksFilter.fromJson(Map<String, dynamic> json) {
    return TeksFilter(
      barangCategory: json['barang_category'],
    );
  }
}

class BarangCategory {
  final int? id;
  final String? alias;
  final String? nama;

  BarangCategory({this.id, this.alias, this.nama});

  factory BarangCategory.fromJson(Map<String, dynamic> json) {
    return BarangCategory(
      id: json['id'],
      alias: json['alias'],
      nama: json['nama'],
    );
  }
}

class Barang {
  final int? id;
  final String? kodeBarang;
  final String? nama;
  final String? satuan;
  final int? hpp;
  final int? hp;
  final int? h1;
  final int? h2;
  final int? h3;

  Barang({
    this.id,
    this.kodeBarang,
    this.nama,
    this.satuan,
    this.hpp,
    this.hp,
    this.h1,
    this.h2,
    this.h3,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: int.tryParse(json['id'].toString()) ?? 0,
      kodeBarang: json['kode_barang'],
      nama: json['nama'],
      satuan: json['satuan'],
      hpp: int.tryParse(json['hpp'].toString()) ?? 0,
      hp: int.tryParse(json['hp'].toString()) ?? 0,
      h1: int.tryParse(json['h1'].toString()) ?? 0,
      h2: int.tryParse(json['h2'].toString()) ?? 0,
      h3: int.tryParse(json['h3'].toString()) ?? 0,
    );
  }

  @override
  String toString() {
    return 'Barang: {id: $id, kodeBarang: $kodeBarang, nama: $nama, satuan: $satuan, hpp: $hpp, hp: $hp, h1: $h1, h2: $h2, h3: $h3}';
  }
}
