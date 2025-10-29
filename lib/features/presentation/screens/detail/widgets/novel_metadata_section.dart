import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';

class NovelMetadataSection extends StatelessWidget {
  final Map<String, dynamic> novelData;
  const NovelMetadataSection({super.key, required this.novelData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Información',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          SizedBox(height: 2.h),
          // Genre tags
          if (novelData['genres'] != null && (novelData['genres'] as List).isNotEmpty) ...[
            _buildMetadataRow(
              context: context,
              icon: 'category',
              label: 'Géneros',
              child: Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: (novelData['genres'] as List).map<Widget>((dynamic genre) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3), width: 1),
                    ),
                    child: Text(
                      genre as String,
                      style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 2.h),
          ],
          // Status
          _buildMetadataRow(
            context: context,
            icon: 'info',
            label: 'Estado',
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: _getStatusColor(novelData['status'] as String? ?? 'unknown').withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _getStatusColor(novelData['status'] as String? ?? 'unknown').withValues(alpha: 0.3), width: 1),
              ),
              child: Text(
                _getStatusText(novelData['status'] as String? ?? 'unknown'),
                style: theme.textTheme.labelMedium?.copyWith(color: _getStatusColor(novelData['status'] as String? ?? 'unknown'), fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          // Chapter count
          _buildMetadataRow(
            context: context,
            icon: 'menu_book',
            label: 'Capítulos',
            child: Text(
              '${novelData['chapterCount'] ?? 0} capítulos',
              style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: 2.h),
          // Last update
          _buildMetadataRow(
            context: context,
            icon: 'schedule',
            label: 'Última actualización',
            child: Text(_formatLastUpdate(novelData['lastUpdate'] as String?), style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7))),
          ),
          SizedBox(height: 2.h),
          // Reading progress (if in library)
          if (novelData['isInLibrary'] == true && novelData['readingProgress'] != null) ...[
            _buildMetadataRow(
              context: context,
              icon: 'trending_up',
              label: 'Progreso de lectura',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${((novelData['readingProgress'] as double) * 100).toInt()}% completado',
                    style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 1.h),
                  LinearProgressIndicator(
                    value: novelData['readingProgress'] as double,
                    backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
          ],
          // Word count (if available)
          if (novelData['wordCount'] != null) ...[
            _buildMetadataRow(
              context: context,
              icon: 'text_fields',
              label: 'Palabras',
              child: Text(_formatWordCount(novelData['wordCount'] as int), style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7))),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetadataRow({required BuildContext context, required String icon, required String label, required Widget child}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8.w,
          child: CustomIconWidget(iconName: icon, color: colorScheme.primary, size: 20),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6), fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 0.5.h),
              child,
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ongoing':
      case 'en_curso':
        return Colors.green;
      case 'completed':
      case 'completada':
        return Colors.blue;
      case 'hiatus':
      case 'pausa':
        return Colors.orange;
      case 'dropped':
      case 'abandonada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'ongoing':
        return 'En curso';
      case 'completed':
        return 'Completada';
      case 'hiatus':
        return 'En pausa';
      case 'dropped':
        return 'Abandonada';
      default:
        return 'Desconocido';
    }
  }

  String _formatLastUpdate(String? lastUpdate) {
    if (lastUpdate == null) return 'Desconocido';
    try {
      final date = DateTime.parse(lastUpdate);
      final now = DateTime.now();
      final difference = now.difference(date);
      if (difference.inDays == 0) {
        return 'Hoy';
      } else if (difference.inDays == 1) {
        return 'Ayer';
      } else if (difference.inDays < 7) {
        return 'Hace ${difference.inDays} días';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return 'Hace ${weeks} semana${weeks > 1 ? 's' : ''}';
      } else {
        final months = (difference.inDays / 30).floor();
        return 'Hace ${months} mes${months > 1 ? 'es' : ''}';
      }
    } catch (e) {
      return lastUpdate;
    }
  }

  String _formatWordCount(int wordCount) {
    if (wordCount < 1000) {
      return '$wordCount palabras';
    } else if (wordCount < 1000000) {
      final k = (wordCount / 1000).toStringAsFixed(1);
      return '${k}K palabras';
    } else {
      final m = (wordCount / 1000000).toStringAsFixed(1);
      return '${m}M palabras';
    }
  }
}
