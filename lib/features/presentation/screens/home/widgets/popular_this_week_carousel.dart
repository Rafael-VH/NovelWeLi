import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/core/themes/app_theme.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_image_widget.dart';

class PopularThisWeekCarousel extends StatelessWidget {
  const PopularThisWeekCarousel({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> popularNovels = [
      {
        "id": 1,
        "title": "El Héroe Invencible",
        "author": "Luis Fernando García",
        "rating": 4.8,
        "coverImage": "https://images.unsplash.com/photo-1709745438996-ddf62587ea10",
        "semanticLabel": "Epic fantasy book cover featuring a heroic warrior in golden armor standing on a cliff overlooking a vast battlefield with armies below",
        "weeklyReads": "125K",
        "trend": "up",
        "genre": "Aventura",
        "rank": 1,
      },
      {
        "id": 2,
        "title": "Romance en la Universidad",
        "author": "Valentina Moreno",
        "rating": 4.6,
        "coverImage": "https://images.unsplash.com/photo-1617882526477-6149b6bd4cde",
        "semanticLabel": "Romantic book cover showing a young couple sitting under cherry blossom trees on a university campus with pink petals falling around them",
        "weeklyReads": "98K",
        "trend": "up",
        "genre": "Romance",
        "rank": 2,
      },
      {
        "id": 3,
        "title": "Misterio en la Mansión",
        "author": "Eduardo Ramírez",
        "rating": 4.5,
        "coverImage": "https://images.unsplash.com/photo-1573747288400-13c9c285f352",
        "semanticLabel": "Mystery thriller cover depicting a dark Victorian mansion at night with a single lit window and fog surrounding the building",
        "weeklyReads": "87K",
        "trend": "stable",
        "genre": "Misterio",
        "rank": 3,
      },
      {
        "id": 4,
        "title": "Guerra de los Mundos",
        "author": "Patricia Vega",
        "rating": 4.7,
        "coverImage": "https://images.unsplash.com/photo-1592996416093-02dca5712beb",
        "semanticLabel": "Sci-fi book cover showing spaceships battling above a futuristic city with laser beams and explosions lighting up the night sky",
        "weeklyReads": "76K",
        "trend": "up",
        "genre": "Ciencia Ficción",
        "rank": 4,
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Popular Esta Semana',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.lightTheme.colorScheme.onSurface),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(iconName: 'trending_up', color: AppTheme.successLight, size: 20),
                ],
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, '/search-screen');
                },
                child: Text(
                  'Ver ranking',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.lightTheme.colorScheme.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 26.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            itemCount: popularNovels.length,
            itemBuilder: (context, index) {
              final novel = popularNovels[index];
              return Container(
                width: 55.w,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pushNamed(context, '/novel-detail-screen');
                  },
                  onLongPress: () {
                    HapticFeedback.mediumImpact();
                    _showQuickActions(context, novel);
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppTheme.lightTheme.colorScheme.surface),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                boxShadow: [BoxShadow(color: AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Stack(
                                  children: [
                                    CustomImageWidget(
                                      imageUrl: novel["coverImage"] as String,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      semanticLabel: novel["semanticLabel"] as String,
                                    ),
                                    Positioned(
                                      top: 2.w,
                                      left: 2.w,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                                        decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.primary, borderRadius: BorderRadius.circular(12)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '#${novel["rank"]}',
                                              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 2.w,
                                      right: 2.w,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 1.w),
                                        decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(8)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomIconWidget(
                                              iconName: novel["trend"] == "up" ? 'trending_up' : 'trending_flat',
                                              color: novel["trend"] == "up" ? AppTheme.successLight : AppTheme.warningLight,
                                              size: 12,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    novel["title"] as String,
                                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.lightTheme.colorScheme.onSurface),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    'Por ${novel["author"]}',
                                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CustomIconWidget(iconName: 'star', color: AppTheme.warningLight, size: 14),
                                          SizedBox(width: 1.w),
                                          Text(
                                            novel["rating"].toString(),
                                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.lightTheme.colorScheme.onSurface),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CustomIconWidget(iconName: 'visibility', color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6), size: 12),
                                          SizedBox(width: 1.w),
                                          Text(
                                            novel["weeklyReads"] as String,
                                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 10.sp),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 1.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                    decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                                    child: Text(
                                      novel["genre"] as String,
                                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: AppTheme.lightTheme.colorScheme.secondary, fontWeight: FontWeight.w600, fontSize: 9.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showQuickActions(BuildContext context, Map<String, dynamic> novel) {
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
              height: 0.5.h,
              decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.outline, borderRadius: BorderRadius.circular(2)),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.primary, borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    '#${novel["rank"]}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    novel["title"] as String,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(iconName: 'menu_book', color: AppTheme.lightTheme.colorScheme.primary, size: 24),
              title: const Text('Leer Ahora'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/reader-screen');
                HapticFeedback.lightImpact();
              },
            ),
            ListTile(
              leading: CustomIconWidget(iconName: 'library_add', color: AppTheme.successLight, size: 24),
              title: const Text('Añadir a Biblioteca'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
            ListTile(
              leading: CustomIconWidget(iconName: 'share', color: AppTheme.lightTheme.colorScheme.secondary, size: 24),
              title: const Text('Compartir'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
