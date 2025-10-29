import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
//
import 'package:novel_we_li/core/app_export.dart';

class NovelCardWidget extends StatelessWidget {
  final Map<String, dynamic> novel;
  final VoidCallback onTap;
  final VoidCallback onContinueReading;
  final VoidCallback onDownloadChapters;
  final VoidCallback onRemoveFromLibrary;
  final VoidCallback onMarkCompleted;
  final VoidCallback onChangeCategory;
  final VoidCallback onExport;

  const NovelCardWidget({
    super.key,
    required this.novel,
    required this.onTap,
    required this.onContinueReading,
    required this.onDownloadChapters,
    required this.onRemoveFromLibrary,
    required this.onMarkCompleted,
    required this.onChangeCategory,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (novel['progress'] as double?) ?? 0.0;
    final isDownloaded = (novel['isDownloaded'] as bool?) ?? false;
    final storageSize = novel['storageSize'] as String? ?? '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(novel['id']),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onContinueReading(),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              icon: Icons.play_arrow_rounded,
              label: 'Continuar',
            ),
            SlidableAction(
              onPressed: (_) => onDownloadChapters(),
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              icon: Icons.download_rounded,
              label: 'Descargar',
            ),
            SlidableAction(
              onPressed: (_) => onRemoveFromLibrary(),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.onError,
              icon: Icons.delete_rounded,
              label: 'Eliminar',
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          onLongPress: () => _showContextMenu(context),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Row(
                children: [
                  // Cover Image
                  Container(
                    width: 15.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(imageUrl: novel['coverUrl'] as String, width: 15.w, height: 20.w, fit: BoxFit.cover, semanticLabel: novel['semanticLabel'] as String),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  // Novel Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Status Badges
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                novel['title'] as String,
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppTheme.lightTheme.colorScheme.onSurface),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isDownloaded) ...[
                              SizedBox(width: 2.w),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomIconWidget(iconName: 'offline_pin', color: AppTheme.lightTheme.colorScheme.tertiary, size: 12),
                                    SizedBox(width: 1.w),
                                    Text(
                                      'Offline',
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500, color: AppTheme.lightTheme.colorScheme.tertiary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),

                        SizedBox(height: 1.h),

                        // Author
                        Text(
                          'por ${novel['author'] as String}',
                          style: TextStyle(fontSize: 12.sp, color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.5.h),
                        // Progress Bar
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(3)),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: progress,
                                  child: Container(
                                    decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.primary, borderRadius: BorderRadius.circular(3)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  '${(progress * 100).toInt()}%',
                                  style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppTheme.lightTheme.colorScheme.primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        // Last Read and Storage Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Última lectura: ${novel['lastRead'] as String}',
                              style: TextStyle(fontSize: 11.sp, color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6)),
                            ),
                            if (storageSize.isNotEmpty)
                              Text(
                                storageSize,
                                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500, color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6)),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 4,
              decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.outline, borderRadius: BorderRadius.circular(2)),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(iconName: 'check_circle', color: AppTheme.lightTheme.colorScheme.tertiary, size: 24),
              title: const Text('Marcar como Completado'),
              onTap: () {
                Navigator.pop(context);
                onMarkCompleted();
              },
            ),
            ListTile(
              leading: CustomIconWidget(iconName: 'category', color: AppTheme.lightTheme.colorScheme.primary, size: 24),
              title: const Text('Cambiar Categoría'),
              onTap: () {
                Navigator.pop(context);
                onChangeCategory();
              },
            ),
            ListTile(
              leading: CustomIconWidget(iconName: 'share', color: AppTheme.lightTheme.colorScheme.secondary, size: 24),
              title: const Text('Exportar'),
              onTap: () {
                Navigator.pop(context);
                onExport();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
