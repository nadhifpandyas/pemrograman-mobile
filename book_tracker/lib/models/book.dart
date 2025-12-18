import 'dart:convert';

class Book {
  int? id; // local DB id
  String title;
  String authors; // comma separated
  String description;
  String thumbnail;
  String publishedDate;
  int pageCount;
  String status; // to-read, reading, finished
  int rating; // 0-5
  String notes;
  String remoteId; // id from API (optional)

  Book({
    this.id,
    required this.title,
    this.authors = '',
    this.description = '',
    this.thumbnail = '',
    this.publishedDate = '',
    this.pageCount = 0,
    this.status = 'to-read',
    this.rating = 0,
    this.notes = '',
    this.remoteId = '',
  });

  factory Book.fromMap(Map<String, dynamic> m) => Book(
    id: m['id'] as int?,
    title: m['title'] ?? '',
    authors: m['authors'] ?? '',
    description: m['description'] ?? '',
    thumbnail: m['thumbnail'] ?? '',
    publishedDate: m['publishedDate'] ?? '',
    pageCount: m['pageCount'] ?? 0,
    status: m['status'] ?? 'to-read',
    rating: m['rating'] ?? 0,
    notes: m['notes'] ?? '',
    remoteId: m['remoteId'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'authors': authors,
    'description': description,
    'thumbnail': thumbnail,
    'publishedDate': publishedDate,
    'pageCount': pageCount,
    'status': status,
    'rating': rating,
    'notes': notes,
    'remoteId': remoteId,
  };

  factory Book.fromGoogleJson(Map<String, dynamic> j) {
    final volumeInfo = j['volumeInfo'] ?? {};
    return Book(
      title: volumeInfo['title'] ?? 'No title',
      authors: (volumeInfo['authors'] as List?)?.join(', ') ?? '',
      description: volumeInfo['description'] ?? '',
      thumbnail: (volumeInfo['imageLinks'] != null) ? (volumeInfo['imageLinks']['thumbnail'] ?? '') : '',
      publishedDate: volumeInfo['publishedDate'] ?? '',
      pageCount: volumeInfo['pageCount'] ?? 0,
      remoteId: j['id'] ?? '',
    );
  }
}