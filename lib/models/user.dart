class User {
  final int id;
  final String username;
  final int statusAktif;
  final int hakAkses;
  final String lastLogin;
  final int createdBy;
  final int? updatedBy;
  final int? deletedBy;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String imei;

  User({
    required this.id,
    required this.username,
    required this.statusAktif,
    required this.hakAkses,
    required this.lastLogin,
    required this.createdBy,
    this.updatedBy,
    this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.imei,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      statusAktif: json['status_aktif'],
      hakAkses: json['hak_akses'],
      lastLogin: json['last_login'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      imei: json['imei'],
    );
  }
}
