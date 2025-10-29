import 'package:novel_we_li/features/domain/entities/novel.dart';

class NovelModel extends Novel {
  const NovelModel({
    required super.id,
    required super.title,
    required super.author,
    super.synopsis,
    super.coverImageUrl,
    super.genres,
    super.rating,
    super.totalChapters,
    super.readChapters,
    super.lastUpdated,
    super.status,
    super.isFavorite,
    super.isDownloaded,
  });

  factory NovelModel.fromJson(Map<String, dynamic> json) {
    return NovelModel(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      synopsis: json['synopsis'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalChapters: json['total_chapters'] as int? ?? 0,
      readChapters: json['read_chapters'] as int? ?? 0,
      lastUpdated: json['last_updated'] != null ? DateTime.parse(json['last_updated'] as String) : null,
      status: NovelStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => NovelStatus.ongoing),
      isFavorite: json['is_favorite'] as bool? ?? false,
      isDownloaded: json['is_downloaded'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'synopsis': synopsis,
      'cover_image_url': coverImageUrl,
      'genres': genres,
      'rating': rating,
      'total_chapters': totalChapters,
      'read_chapters': readChapters,
      'last_updated': lastUpdated?.toIso8601String(),
      'status': status.name,
      'is_favorite': isFavorite,
      'is_downloaded': isDownloaded,
    };
  }

  Novel toEntity() => Novel(
    id: id,
    title: title,
    author: author,
    synopsis: synopsis,
    coverImageUrl: coverImageUrl,
    genres: genres,
    rating: rating,
    totalChapters: totalChapters,
    readChapters: readChapters,
    lastUpdated: lastUpdated,
    status: status,
    isFavorite: isFavorite,
    isDownloaded: isDownloaded,
  );
}
