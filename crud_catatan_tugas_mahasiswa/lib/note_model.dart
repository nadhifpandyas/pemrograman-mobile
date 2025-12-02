// lib/note_model.dart
class Note {
  String id;
  String title;
  String description;
  String category; // 'Kuliah' | 'Organisasi' | 'Pribadi' | 'Lain-lain'
  DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.createdAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'createdAt': createdAt.toIso8601String(),
  };
}
