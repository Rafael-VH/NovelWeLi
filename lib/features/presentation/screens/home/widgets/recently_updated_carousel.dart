import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/core/themes/app_theme.dart';
import 'package:novel_we_li/features/domain/entities/novel.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_image_widget.dart';

class RecentlyUpdatedCarousel extends StatelessWidget {
  final List<Novel> novels;

  const RecentlyUpdatedCarousel({super.key, required this.novels});

  @override
  Widget build(BuildContext context) {
    if (novels.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Actualizaciones Recientes',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.lightTheme.colorScheme.onSurface),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to recently updated list
                },
                child: Text(
                  'Ver todos',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.lightTheme.colorScheme.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 28.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: novels.length,
            itemBuilder: (context, index) {
              final novel = novels[index];

              return Container(
                width: 35.w,
                margin: EdgeInsets.only(right: 3.w),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/novel-detail-screen', arguments: novel.id);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Novel Cover
                      Container(
                        height: 20.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(2, 0))],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              CustomImageWidget(imageUrl: novel.coverImageUrl ?? '', height: 20.h, width: double.infinity, fit: BoxFit.cover, semanticLabel: 'Portada de ${novel.title}'),
                              // Progress indicator if novel is being read
                              if (novel.progress > 0)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 0.5.h,
                                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3)),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: novel.progress,
                                      child: Container(decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.primary)),
                                    ),
                                  ),
                                ),
                              // Update indicator
                              Positioned(
                                top: 1.w,
                                right: 1.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.secondary, borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    'NUEVO',
                                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 8.sp),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      // Novel Info
                      Text(
                        novel.title,
                        style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.lightTheme.colorScheme.onSurface),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        novel.author,
                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(iconName: 'star', color: Colors.amber, size: 14),
                          SizedBox(width: 1.w),
                          Text(
                            novel.rating.toStringAsFixed(1),
                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.8), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
