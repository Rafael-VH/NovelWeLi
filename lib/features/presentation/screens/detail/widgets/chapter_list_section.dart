import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
//
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';

class ChapterListSection extends StatefulWidget {
  final List<Map<String, dynamic>> chapters;
  final Function(Map<String, dynamic>)? onChapterTap;
  final Function(Map<String, dynamic>)? onDownloadChapter;
  final Function(Map<String, dynamic>)? onMarkAsRead;

  const ChapterListSection({super.key, required this.chapters, this.onChapterTap, this.onDownloadChapter, this.onMarkAsRead});

  @override
  State<ChapterListSection> createState() => _ChapterListSectionState();
}

class _ChapterListSectionState extends State<ChapterListSection> {
  bool _isReversed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayChapters = _isReversed ? widget.chapters.reversed.toList() : widget.chapters;

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Capítulos (${widget.chapters.length})',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
                // Sort button
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isReversed = !_isReversed;
                    });
                    HapticFeedback.lightImpact();
                  },
                  icon: CustomIconWidget(iconName: _isReversed ? 'arrow_upward' : 'arrow_downward', color: colorScheme.primary, size: 24),
                  tooltip: _isReversed ? 'Más antiguos primero' : 'Más recientes primero',
                ),
              ],
            ),
          ),
          // Chapter list
          widget.chapters.isEmpty
              ? _buildEmptyState(context)
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayChapters.length,
                  separatorBuilder: (context, index) => Divider(height: 1, color: colorScheme.outline.withValues(alpha: 0.2), indent: 4.w, endIndent: 4.w),
                  itemBuilder: (context, index) {
                    final chapter = displayChapters[index];
                    return _buildChapterItem(context, chapter, index);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildChapterItem(BuildContext context, Map<String, dynamic> chapter, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isRead = chapter['isRead'] as bool? ?? false;
    final isDownloaded = chapter['isDownloaded'] as bool? ?? false;

    return Slidable(
      key: ValueKey(chapter['id']),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              HapticFeedback.lightImpact();
              if (widget.onDownloadChapter != null) {
                widget.onDownloadChapter!(chapter);
              } else {
                _downloadChapter(context, chapter);
              }
            },
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            icon: Icons.download,
            label: 'Descargar',
          ),
          SlidableAction(
            onPressed: (context) {
              HapticFeedback.lightImpact();
              if (widget.onMarkAsRead != null) {
                widget.onMarkAsRead!(chapter);
              } else {
                _markAsRead(context, chapter);
              }
            },
            backgroundColor: isRead ? Colors.orange : Colors.green,
            foregroundColor: Colors.white,
            icon: isRead ? Icons.remove_done : Icons.done,
            label: isRead ? 'No leído' : 'Leído',
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          if (widget.onChapterTap != null) {
            widget.onChapterTap!(chapter);
          } else {
            Navigator.pushNamed(context, '/reader-screen');
          }
        },
        onLongPress: () {
          HapticFeedback.mediumImpact();
          _showChapterOptions(context, chapter);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              // Chapter number/icon
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: isRead ? colorScheme.primary.withValues(alpha: 0.1) : colorScheme.outline.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isRead ? colorScheme.primary.withValues(alpha: 0.3) : colorScheme.outline.withValues(alpha: 0.3), width: 1),
                ),
                child: Center(
                  child: Text(
                    '${chapter['number'] ?? index + 1}',
                    style: theme.textTheme.labelLarge?.copyWith(color: isRead ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6), fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              // Chapter info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter['title'] ?? 'Capítulo ${chapter['number'] ?? index + 1}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isRead ? colorScheme.onSurface.withValues(alpha: 0.6) : colorScheme.onSurface,
                        fontWeight: isRead ? FontWeight.w400 : FontWeight.w500,
                        decoration: isRead ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Text(_formatReleaseDate(chapter['releaseDate'] as String?), style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5))),
                        if (chapter['wordCount'] != null) ...[
                          Text(' • ${_formatWordCount(chapter['wordCount'] as int)}', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5))),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Status indicators
              Column(
                children: [
                  if (isDownloaded) ...[CustomIconWidget(iconName: 'offline_pin', color: Colors.green, size: 20), SizedBox(height: 0.5.h)],
                  if (isRead) ...[
                    CustomIconWidget(iconName: 'check_circle', color: colorScheme.primary, size: 20),
                  ] else ...[
                    CustomIconWidget(iconName: 'radio_button_unchecked', color: colorScheme.outline, size: 20),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: [
          CustomIconWidget(iconName: 'menu_book', color: colorScheme.outline, size: 64),
          SizedBox(height: 2.h),
          Text('No hay capítulos disponibles', style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6))),
          SizedBox(height: 1.h),
          Text(
            'Los capítulos aparecerán aquí cuando estén disponibles',
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton.icon(
            onPressed: () {
              // Refresh chapters
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Actualizando capítulos...'), duration: Duration(seconds: 2)));
            },
            icon: CustomIconWidget(iconName: 'refresh', color: colorScheme.onPrimary, size: 20),
            label: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  void _showChapterOptions(BuildContext context, Map<String, dynamic> chapter) {
    final theme = Theme.of(context);
    final isRead = chapter['isRead'] as bool? ?? false;
    final isDownloaded = chapter['isDownloaded'] as bool? ?? false;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(color: theme.colorScheme.outline, borderRadius: BorderRadius.circular(2)),
            ),
            SizedBox(height: 3.h),
            Text(
              chapter['title'] ?? 'Opciones del capítulo',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(iconName: 'play_arrow', color: theme.colorScheme.primary, size: 24),
              title: const Text('Leer capítulo'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/reader-screen');
              },
            ),
            ListTile(
              leading: CustomIconWidget(iconName: isDownloaded ? 'delete' : 'download', color: isDownloaded ? Colors.red : theme.colorScheme.primary, size: 24),
              title: Text(isDownloaded ? 'Eliminar descarga' : 'Descargar'),
              onTap: () {
                Navigator.pop(context);
                _downloadChapter(context, chapter);
              },
            ),
            ListTile(
              leading: CustomIconWidget(iconName: isRead ? 'remove_done' : 'done', color: isRead ? Colors.orange : Colors.green, size: 24),
              title: Text(isRead ? 'Marcar como no leído' : 'Marcar como leído'),
              onTap: () {
                Navigator.pop(context);
                _markAsRead(context, chapter);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _downloadChapter(BuildContext context, Map<String, dynamic> chapter) {
    final isDownloaded = chapter['isDownloaded'] as bool? ?? false;
    final message = isDownloaded ? 'Descarga eliminada' : 'Capítulo descargado para lectura offline';

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }

  void _markAsRead(BuildContext context, Map<String, dynamic> chapter) {
    final isRead = chapter['isRead'] as bool? ?? false;
    final message = isRead ? 'Capítulo marcado como no leído' : 'Capítulo marcado como leído';

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }

  String _formatReleaseDate(String? releaseDate) {
    if (releaseDate == null) return 'Fecha desconocida';
    try {
      final date = DateTime.parse(releaseDate);
      final now = DateTime.now();
      final difference = now.difference(date);
      if (difference.inDays == 0) {
        return 'Hoy';
      } else if (difference.inDays == 1) {
        return 'Ayer';
      } else if (difference.inDays < 7) {
        return 'Hace ${difference.inDays}d';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return 'Hace ${weeks}sem';
      } else {
        final months = (difference.inDays / 30).floor();
        return 'Hace ${months}m';
      }
    } catch (e) {
      return 'Fecha inválida';
    }
  }

  String _formatWordCount(int wordCount) {
    if (wordCount < 1000) {
      return '${wordCount}p';
    } else {
      final k = (wordCount / 1000).toStringAsFixed(1);
      return '${k}K palabras';
    }
  }
}
