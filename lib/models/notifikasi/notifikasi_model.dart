class NotifikasiModel {
  final int id;
  final String pesan;
  final String statusLama;
  final String statusBaru;
  final DateTime tanggalNotifikasi;
  final bool dibaca;
  final String kodeSurat;
  final String nama;
  final String username; 

  NotifikasiModel({
    required this.id,
    required this.pesan,
    required this.statusLama,
    required this.statusBaru,
    required this.tanggalNotifikasi,
    required this.dibaca,
    required this.kodeSurat,
    required this.nama,
    required this.username,
  });

  factory NotifikasiModel.fromJson(Map<String, dynamic> json) {
    return NotifikasiModel(
      id: json['id'] ?? 0,
      pesan: json['pesan'] ?? '',
      statusLama: json['status_lama'] ?? '',
      statusBaru: json['status_baru'] ?? '',
      tanggalNotifikasi: DateTime.parse(json['tanggal_notifikasi'] ?? DateTime.now().toString()),
      dibaca: json['dibaca'] == 1 || json['dibaca'] == true,
      kodeSurat: json['kode_surat'] ?? '',
      nama: json['nama'] ?? '',
      username: json['username'] ?? '',
    );
  }
}
