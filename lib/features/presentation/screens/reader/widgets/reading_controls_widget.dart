import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/core/themes/app_theme.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';

class ReadingControlsWidget extends StatelessWidget {
  final String chapterTitle;
  final double readingProgress;
  final VoidCallback? onClosePressed;
  final VoidCallback? onPreviousChapter;
  final VoidCallback? onNextChapter;
  final VoidCallback? onBookmarkToggle;
  final VoidCallback? onSettingsPressed;
  final bool isBookmarked;
  final bool showControls;
  const ReadingControlsWidget({
    super.key,
    required this.chapterTitle,
    required this.readingProgress,
    this.onClosePressed,
    this.onPreviousChapter,
    this.onNextChapter,
    this.onBookmarkToggle,
    this.onSettingsPressed,
    this.isBookmarked = false,
    this.showControls = true,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Top controls
            Positioned(top: 0, left: 0, right: 0, child: _buildTopControls(context)),
            // Bottom controls
            Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomControls(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopControls(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent]),
      ),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onClosePressed?.call();
                },
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8)),
                  child: CustomIconWidget(iconName: 'close', color: Colors.white, size: 6.w),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapterTitle,
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      height: 0.5.h,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: readingProgress,
                        child: Container(
                          decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.primary, borderRadius: BorderRadius.circular(2)),
                        ),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text('${(readingProgress * 100).toInt()}% completado', style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent]),
      ),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(icon: 'arrow_back_ios', onTap: onPreviousChapter, tooltip: 'Capítulo anterior'),
              _buildControlButton(
                icon: isBookmarked ? 'bookmark' : 'bookmark_border',
                onTap: () {
                  HapticFeedback.lightImpact();
                  onBookmarkToggle?.call();
                },
                tooltip: isBookmarked ? 'Quitar marcador' : 'Añadir marcador',
                isActive: isBookmarked,
              ),
              _buildControlButton(icon: 'settings', onTap: onSettingsPressed, tooltip: 'Configuración de lectura'),
              _buildControlButton(icon: 'arrow_forward_ios', onTap: onNextChapter, tooltip: 'Siguiente capítulo'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({required String icon, VoidCallback? onTap, String? tooltip, bool isActive = false}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(color: isActive ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8) : Colors.black.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(12)),
        child: CustomIconWidget(iconName: icon, color: Colors.white, size: 6.w),
      ),
    );
  }
}
