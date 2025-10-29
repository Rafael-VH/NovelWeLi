import 'package:equatable/equatable.dart';

class Novel extends Equatable {
  final String id;
  final String title;
  final String author;
  final String? synopsis;
  final String? coverImageUrl;
  final List<String> genres;
  final double rating;
  final int totalChapters;
  final int readChapters;
  final DateTime? lastUpdated;
  final NovelStatus status;
  final bool isFavorite;
  final bool isDownloaded;

  const Novel({
    required this.id,
    required this.title,
    required this.author,
    this.synopsis,
    this.coverImageUrl,
    this.genres = const [],
    this.rating = 0.0,
    this.totalChapters = 0,
    this.readChapters = 0,
    this.lastUpdated,
    this.status = NovelStatus.ongoing,
    this.isFavorite = false,
    this.isDownloaded = false,
  });

  double get progress => totalChapters > 0 ? readChapters / totalChapters : 0.0;

  @override
  List<Object?> get props => [id, title, author, synopsis, coverImageUrl, genres, rating, totalChapters, readChapters, lastUpdated, status, isFavorite, isDownloaded];

  Novel copyWith({
    String? id,
    String? title,
    String? author,
    String? synopsis,
    String? coverImageUrl,
    List<String>? genres,
    double? rating,
    int? totalChapters,
    int? readChapters,
    DateTime? lastUpdated,
    NovelStatus? status,
    bool? isFavorite,
    bool? isDownloaded,
  }) {
    return Novel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      synopsis: synopsis ?? this.synopsis,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      genres: genres ?? this.genres,
      rating: rating ?? this.rating,
      totalChapters: totalChapters ?? this.totalChapters,
      readChapters: readChapters ?? this.readChapters,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      status: status ?? this.status,
      isFavorite: isFavorite ?? this.isFavorite,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }
}

enum NovelStatus { ongoing, completed, hiatus, dropped }
