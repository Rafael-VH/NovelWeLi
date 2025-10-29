import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novel_we_li/core/themes/app_theme.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_image_widget.dart';
import 'package:sizer/sizer.dart';

class RecommendedForYouCarousel extends StatelessWidget {
  const RecommendedForYouCarousel({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recommendedNovels = [
      {
        "id": 1,
        "title": "El Camino del Samurái",
        "author": "Hiroshi Tanaka",
        "rating": 4.9,
        "coverImage": "https://images.unsplash.com/photo-1485096063981-ebe59dce0f6e",
        "semanticLabel": "Traditional Japanese book cover featuring a samurai warrior in black armor holding a katana sword against a backdrop of cherry blossoms and Mount Fuji",
        "matchPercentage": 95,
        "genre": "Histórica",
        "readingTime": "12h 30m",
        "reason": "Te gusta la ficción histórica",
      },
      {
        "id": 2,
        "title": "Amor en Tiempos Modernos",
        "author": "Sofia Delgado",
        "rating": 4.4,
        "coverImage": "https://images.unsplash.com/photo-1654901015752-c841ad9cccc0",
        "semanticLabel": "Contemporary romance cover showing a couple silhouetted against a city skyline at sunset with warm orange and pink colors",
        "matchPercentage": 88,
        "genre": "Romance Contemporáneo",
        "readingTime": "8h 45m",
        "reason": "Basado en tus lecturas recientes",
      },
      {
        "id": 3,
        "title": "El Secreto del Alquimista",
        "author": "Gabriel Mendoza",
        "rating": 4.6,
        "coverImage": "https://images.unsplash.com/photo-1710549149023-6854304d4dbf",
        "semanticLabel": "Medieval fantasy cover depicting an alchemist's laboratory with glowing potions, ancient books, and mystical symbols carved into stone walls",
        "matchPercentage": 92,
        "genre": "Fantasía Medieval",
        "readingTime": "15h 20m",
        "reason": "Autores similares que sigues",
      },
      {
        "id": 4,
        "title": "Viaje a las Estrellas",
        "author": "Elena Cosmos",
        "rating": 4.7,
        "coverImage": "https://images.unsplash.com/photo-1711560706081-e8e9402530fc",
        "semanticLabel": "Space exploration book cover showing a sleek spaceship traveling through a nebula with colorful cosmic gases and distant stars",
        "matchPercentage": 85,
        "genre": "Ciencia Ficción",
        "readingTime": "11h 15m",
        "reason": "Género favorito",
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
                    'Recomendado Para Ti',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.lightTheme.colorScheme.onSurface),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(iconName: 'auto_awesome', color: AppTheme.lightTheme.colorScheme.primary, size: 20),
                ],
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, '/search-screen');
                },
                child: Text(
                  'Personalizar',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.lightTheme.colorScheme.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            itemCount: recommendedNovels.length,
            itemBuilder: (context, index) {
              final novel = recommendedNovels[index];
              return Container(
                width: 65.w,
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
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppTheme.lightTheme.colorScheme.surface, AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05)],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                boxShadow: [BoxShadow(color: AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))],
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                                      right: 2.w,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                                        decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.primary, borderRadius: BorderRadius.circular(12)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${novel["matchPercentage"]}%',
                                              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11.sp),
                                            ),
                                            SizedBox(width: 1.w),
                                            CustomIconWidget(iconName: 'favorite', color: Colors.white, size: 12),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 2.w,
                                      left: 2.w,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                                        decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(8)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomIconWidget(iconName: 'access_time', color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7), size: 12),
                                            SizedBox(width: 1.w),
                                            Text(
                                              novel["readingTime"] as String,
                                              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 10.sp),
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
                                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.lightTheme.colorScheme.onSurface),
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
                                  SizedBox(height: 1.h),
                                  Row(
                                    children: [
                                      CustomIconWidget(iconName: 'star', color: AppTheme.warningLight, size: 14),
                                      SizedBox(width: 1.w),
                                      Text(
                                        novel["rating"].toString(),
                                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.lightTheme.colorScheme.onSurface),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                        decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                                        child: Text(
                                          novel["genre"] as String,
                                          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: AppTheme.lightTheme.colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 9.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                    decoration: BoxDecoration(
                                      color: AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3), width: 1),
                                    ),
                                    child: Row(
                                      children: [
                                        CustomIconWidget(iconName: 'lightbulb', color: AppTheme.lightTheme.colorScheme.secondary, size: 12),
                                        SizedBox(width: 1.w),
                                        Expanded(
                                          child: Text(
                                            novel["reason"] as String,
                                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: AppTheme.lightTheme.colorScheme.secondary, fontSize: 9.sp),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${novel["matchPercentage"]}%',
                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(width: 1.w),
                      CustomIconWidget(iconName: 'favorite', color: Colors.white, size: 12),
                    ],
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
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  CustomIconWidget(iconName: 'lightbulb', color: AppTheme.lightTheme.colorScheme.secondary, size: 16),
                  SizedBox(width: 2.w),
                  Text(
                    novel["reason"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: AppTheme.lightTheme.colorScheme.secondary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
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
              leading: CustomIconWidget(iconName: 'thumb_down', color: AppTheme.lightTheme.colorScheme.error, size: 24),
              title: const Text('No me interesa'),
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
