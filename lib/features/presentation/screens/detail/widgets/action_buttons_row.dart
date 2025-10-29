import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';
import 'package:sizer/sizer.dart';

class ActionButtonsRow extends StatelessWidget {
  final Map<String, dynamic> novelData;
  final VoidCallback? onStartReading;
  final VoidCallback? onDownload;
  final VoidCallback? onAddToLibrary;
  final VoidCallback? onShare;

  const ActionButtonsRow({super.key, required this.novelData, this.onStartReading, this.onDownload, this.onAddToLibrary, this.onShare});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isInLibrary = novelData['isInLibrary'] as bool? ?? false;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Primary CTA button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                if (onStartReading != null) {
                  onStartReading!();
                } else {
                  Navigator.pushNamed(context, '/reader-screen');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(iconName: 'play_arrow', color: colorScheme.onPrimary, size: 24),
                  SizedBox(width: 2.w),
                  Text(
                    'Comenzar a Leer',
                    style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          // Secondary action buttons
          Row(
            children: [
              // Download button
              Expanded(
                child: _buildSecondaryButton(
                  context: context,
                  icon: 'download',
                  label: 'Descargar',
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (onDownload != null) {
                      onDownload!();
                    } else {
                      _showDownloadDialog(context);
                    }
                  },
                ),
              ),
              SizedBox(width: 2.w),
              // Add to library button
              Expanded(
                child: _buildSecondaryButton(
                  context: context,
                  icon: isInLibrary ? 'bookmark' : 'bookmark_border',
                  label: isInLibrary ? 'En Biblioteca' : 'Añadir',
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (onAddToLibrary != null) {
                      onAddToLibrary!();
                    } else {
                      _toggleLibrary(context);
                    }
                  },
                ),
              ),
              SizedBox(width: 2.w),
              // Share button
              Expanded(
                child: _buildSecondaryButton(
                  context: context,
                  icon: 'share',
                  label: 'Compartir',
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (onShare != null) {
                      onShare!();
                    } else {
                      _shareNovel(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton({required BuildContext context, required String icon, required String label, required VoidCallback onPressed}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      height: 5.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(horizontal: 2.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(iconName: icon, color: colorScheme.primary, size: 18),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.primary, fontSize: 10.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showDownloadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Descargar Novela'),
        content: const Text('¿Deseas descargar todos los capítulos disponibles para lectura offline?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Descarga iniciada en segundo plano'), duration: Duration(seconds: 2)));
            },
            child: const Text('Descargar'),
          ),
        ],
      ),
    );
  }

  void _toggleLibrary(BuildContext context) {
    final isInLibrary = novelData['isInLibrary'] as bool? ?? false;
    final message = isInLibrary ? 'Novela eliminada de la biblioteca' : 'Novela añadida a la biblioteca';

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }

  void _shareNovel(BuildContext context) {
    final title = novelData['title'] ?? 'Novela increíble';
    final author = novelData['author'] ?? 'Autor desconocido';

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Compartiendo "$title" por $author'), duration: const Duration(seconds: 2)));
  }
}
