class StatusPengajuan {
  final int diproses;
  final int selesai;
  final int tolak;

  StatusPengajuan({
    required this.diproses,
    required this.selesai,
    required this.tolak,
  });

  factory StatusPengajuan.fromJson(Map<String, dynamic> json) {
    // More robust parsing to handle various data types
    return StatusPengajuan(
      diproses: _parseIntSafely(json['Diproses']),
      selesai: _parseIntSafely(json['Selesai']),
      tolak: _parseIntSafely(json['Tolak']),
    );
  }
  
  // Helper method to safely parse integers from various types
  static int _parseIntSafely(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        return 0;
      }
    }
    return 0;
  }
}

class KabarDesaModel {
  final int id;
  final String judul;
  final String deskripsi;
  final String gambar;
  final DateTime tanggal;

  KabarDesaModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.gambar,
    required this.tanggal,
  });

  factory KabarDesaModel.fromJson(Map<String, dynamic> json) {
    return KabarDesaModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      gambar: json['gambar'] ?? '',
      tanggal: DateTime.parse(json['tanggal']),
    );
  }
}