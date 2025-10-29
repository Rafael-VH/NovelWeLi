import 'package:equatable/equatable.dart';

class Chapter extends Equatable {
  final String id;
  final String novelId;
  final String title;
  final int chapterNumber;
  final String? content;
  final DateTime? publishedDate;
  final bool isRead;
  final bool isDownloaded;
  final int wordCount;

  const Chapter({
    required this.id,
    required this.novelId,
    required this.title,
    required this.chapterNumber,
    this.content,
    this.publishedDate,
    this.isRead = false,
    this.isDownloaded = false,
    this.wordCount = 0,
  });

  @override
  List<Object?> get props => [id, novelId, title, chapterNumber, content, publishedDate, isRead, isDownloaded, wordCount];

  Chapter copyWith({String? id, String? novelId, String? title, int? chapterNumber, String? content, DateTime? publishedDate, bool? isRead, bool? isDownloaded, int? wordCount}) {
    return Chapter(
      id: id ?? this.id,
      novelId: novelId ?? this.novelId,
      title: title ?? this.title,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      content: content ?? this.content,
      publishedDate: publishedDate ?? this.publishedDate,
      isRead: isRead ?? this.isRead,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      wordCount: wordCount ?? this.wordCount,
    );
  }
}
