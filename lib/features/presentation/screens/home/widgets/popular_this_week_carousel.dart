import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/core/themes/app_theme.dart';
import 'package:novel_we_li/features/domain/entities/novel.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_image_widget.dart';

class PopularThisWeekCarousel extends StatelessWidget {
  final List<Novel> novels;

  const PopularThisWeekCarousel({super.key, required this.novels});

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
                'Popular Esta Semana',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.lightTheme.colorScheme.onSurface),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to popular list
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
          height: 32.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: novels.length,
            itemBuilder: (context, index) {
              final novel = novels[index];
              return Container(
                width: 40.w,
                margin: EdgeInsets.only(right: 3.w),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/novel-detail-screen', arguments: novel.id);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Novel Cover with Ranking Badge
                      Container(
                        height: 22.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 6, offset: const Offset(0, 3))],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              CustomImageWidget(imageUrl: novel.coverImageUrl ?? '', height: 22.h, width: double.infinity, fit: BoxFit.cover, semanticLabel: 'Portada de ${novel.title}'),
                              // Ranking badge
                              Positioned(
                                top: 1.h,
                                left: 2.w,
                                child: Container(
                                  width: 8.w,
                                  height: 8.w,
                                  decoration: BoxDecoration(
                                    color: AppTheme.lightTheme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2))],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '#${index + 1}',
                                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10.sp),
                                    ),
                                  ),
                                ),
                              ),
                              // Favorite button
                              Positioned(
                                top: 1.h,
                                right: 2.w,
                                child: Container(
                                  padding: EdgeInsets.all(1.5.w),
                                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
                                  child: CustomIconWidget(iconName: novel.isFavorite ? 'favorite' : 'favorite_border', color: novel.isFavorite ? Colors.red : Colors.white, size: 18),
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
                          const Spacer(),
                          CustomIconWidget(iconName: 'trending_up', color: AppTheme.lightTheme.colorScheme.secondary, size: 16),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      // Genres
                      Text(
                        novel.genres.take(2).join(' • '),
                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 9.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
