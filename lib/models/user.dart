import 'dart:convert';

  class User {
    final int id;
    final String username;
    final int statusAktif;
    final int hakAkses;
    final String imei;
    final String lastLogin;
    final int createdBy;
    final int updatedBy;
    final int? deletedBy;
    final String createdAt;
    final String updatedAt;
    final String? deletedAt;

    User({
      required this.id,
      required this.username,
      required this.statusAktif,
      required this.hakAkses,
      required this.imei,
      required this.lastLogin,
      required this.createdBy,
      required this.updatedBy,
      this.deletedBy,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
    });

    // Mendapatkan peran berdasarkan hak akses: 1 untuk Owner, 2 untuk Admin
    String get role => hakAkses == 1 ? 'Owner' : 'Admin';

    // Konversi JSON ke objek User
    static User fromJson(Map<String, dynamic> json) {
      return User(
        id: _toInt(json['id']),
        username: _toString(json['username']),
        statusAktif: _toInt(json['status_aktif']),
        hakAkses: _toInt(json['hak_akses']),
        imei: _toString(json['imei']),
        lastLogin: _toString(json['last_login']),
        createdBy: _toInt(json['created_by']),
        updatedBy: _toInt(json['updated_by']),
        deletedBy: _toIntNullable(json['deleted_by']),
        createdAt: _toString(json['created_at']),
        updatedAt: _toString(json['updated_at']),
        deletedAt: _toStringNullable(json['deleted_at']),
      );
    }

    // Konversi ke tipe int
    static int _toInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.parse(value);
      throw Exception("Tipe data tidak valid untuk tipe int yang diharapkan.");
    }

    // Konversi ke tipe int atau null
    static int? _toIntNullable(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.parse(value);
      throw Exception("Tipe data tidak valid untuk tipe int? yang diharapkan.");
    }

    // Konversi ke tipe String
    static String _toString(dynamic value) {
      if (value is String) return value;
      throw Exception("Tipe data tidak valid untuk tipe String yang diharapkan.");
    }

    // Konversi ke tipe String atau null
    static String? _toStringNullable(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      throw Exception("Tipe data tidak valid untuk tipe String? yang diharapkan.");
    }
  }
