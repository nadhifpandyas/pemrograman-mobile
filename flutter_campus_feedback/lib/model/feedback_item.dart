// lib/model/feedback_item.dart
class FeedbackItem {
  final String nama;
  final String nim;
  final String fakultas;
  final List<String> fasilitas;
  final int nilaiKepuasan;
  final String jenisFeedback;
  final bool setuju;
  final DateTime createdAt;
  final String? pesanTambahan;

  FeedbackItem({
    required this.nama,
    required this.nim,
    required this.fakultas,
    required this.fasilitas,
    required this.nilaiKepuasan,
    required this.jenisFeedback,
    required this.setuju,
    this.pesanTambahan,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'nim': nim,
    'fakultas': fakultas,
    'fasilitas': fasilitas,
    'nilaiKepuasan': nilaiKepuasan,
    'jenisFeedback': jenisFeedback,
    'setuju': setuju,
    'pesanTambahan': pesanTambahan,
    'createdAt': createdAt.toIso8601String(),
  };

  factory FeedbackItem.fromJson(Map<String, dynamic> json) => FeedbackItem(
    nama: json['nama'] ?? '',
    nim: json['nim'] ?? '',
    fakultas: json['fakultas'] ?? '',
    fasilitas: List<String>.from(json['fasilitas'] ?? []),
    nilaiKepuasan: (json['nilaiKepuasan'] ?? 1) as int,
    jenisFeedback: json['jenisFeedback'] ?? 'Saran',
    setuju: json['setuju'] ?? false,
    pesanTambahan: json['pesanTambahan'],
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
  );
}
