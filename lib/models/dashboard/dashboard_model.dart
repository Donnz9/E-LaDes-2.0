class StatusPengajuan {
  final int masuk;
  final int selesai;
  final int tolak;

  StatusPengajuan({
    required this.masuk,
    required this.selesai,
    required this.tolak,
  });

  factory StatusPengajuan.fromJson(Map<String, dynamic> json) {
    // More robust parsing to handle various data types
    return StatusPengajuan(
      masuk: _parseIntSafely(json['Masuk']),
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
      id: json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      gambar: json['gambar'] ?? '',
      tanggal: DateTime.parse(json['tanggal']),
    );
  }
}