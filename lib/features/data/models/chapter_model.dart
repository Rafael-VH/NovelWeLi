import 'package:novel_we_li/features/domain/entities/chapter.dart';

class ChapterModel extends Chapter {
  const ChapterModel({
    required super.id,
    required super.novelId,
    required super.title,
    required super.chapterNumber,
    super.content,
    super.publishedDate,
    super.isRead,
    super.isDownloaded,
    super.wordCount,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: json['id'] as String,
      novelId: json['novel_id'] as String,
      title: json['title'] as String,
      chapterNumber: json['chapter_number'] as int,
      content: json['content'] as String?,
      publishedDate: json['published_date'] != null ? DateTime.parse(json['published_date'] as String) : null,
      isRead: json['is_read'] as bool? ?? false,
      isDownloaded: json['is_downloaded'] as bool? ?? false,
      wordCount: json['word_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'novel_id': novelId,
      'title': title,
      'chapter_number': chapterNumber,
      'content': content,
      'published_date': publishedDate?.toIso8601String(),
      'is_read': isRead,
      'is_downloaded': isDownloaded,
      'word_count': wordCount,
    };
  }

  Chapter toEntity() =>
      Chapter(id: id, novelId: novelId, title: title, chapterNumber: chapterNumber, content: content, publishedDate: publishedDate, isRead: isRead, isDownloaded: isDownloaded, wordCount: wordCount);
}
