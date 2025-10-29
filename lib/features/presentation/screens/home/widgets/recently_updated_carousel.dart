import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/core/themes/app_theme.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_image_widget.dart';

class RecentlyUpdatedCarousel extends StatelessWidget {
  const RecentlyUpdatedCarousel({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recentlyUpdated = [
      {
        "id": 1,
        "title": "Cultivador Supremo",
        "author": "Diego Herrera",
        "rating": 4.5,
        "coverImage": "https://images.unsplash.com/photo-1628632094802-911b59fa909d",
        "semanticLabel": "Ancient martial arts book cover with golden dragon motifs and traditional Chinese calligraphy on dark red background",
        "lastUpdate": "Hace 2 horas",
        "newChapters": 3,
        "genre": "Xianxia",
      },
      {
        "id": 2,
        "title": "Reencarnación del Mago",
        "author": "Isabella Torres",
        "rating": 4.4,
        "coverImage": "https://images.unsplash.com/photo-1625675039797-0663c0aa76d5",
        "semanticLabel": "Magical fantasy book cover featuring a glowing staff surrounded by swirling blue and purple magical energy against a starry background",
        "lastUpdate": "Hace 4 horas",
        "newChapters": 2,
        "genre": "Fantasía",
      },
      {
        "id": 3,
        "title": "Sistema de Evolución",
        "author": "Alejandro Morales",
        "rating": 4.6,
        "coverImage": "https://images.unsplash.com/photo-1660554253786-63fa532248bd",
        "semanticLabel": "Futuristic sci-fi book cover with holographic interface displays and digital code patterns in blue and green colors",
        "lastUpdate": "Hace 6 horas",
        "newChapters": 1,
        "genre": "Ciencia Ficción",
      },
      {
        "id": 4,
        "title": "El Señor de los Dragones",
        "author": "Carmen Jiménez",
        "rating": 4.7,
        "coverImage": "https://images.unsplash.com/photo-1663009891740-a1e0dd992c59",
        "semanticLabel": "Epic fantasy cover showing a massive red dragon perched on a mountain peak with a medieval castle in the background under stormy skies",
        "lastUpdate": "Hace 8 horas",
        "newChapters": 4,
        "genre": "Fantasía Épica",
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
              Text(
                'Actualizadas Recientemente',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.lightTheme.colorScheme.onSurface),
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, '/library-screen');
                },
                child: Text(
                  'Ver todas',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.lightTheme.colorScheme.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 28.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            itemCount: recentlyUpdated.length,
            itemBuilder: (context, index) {
              final novel = recentlyUpdated[index];
              return Container(
                width: 60.w,
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
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                                boxShadow: [BoxShadow(color: AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(2, 0))],
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                                child: Stack(
                                  children: [
                                    CustomImageWidget(
                                      imageUrl: novel["coverImage"] as String,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      semanticLabel: novel["semanticLabel"] as String,
                                    ),
                                    if ((novel["newChapters"] as int) > 0)
                                      Positioned(
                                        top: 2.w,
                                        right: 2.w,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.5.w),
                                          decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.secondary, borderRadius: BorderRadius.circular(8)),
                                          child: Text(
                                            '+${novel["newChapters"]}',
                                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10.sp),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
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
                                      SizedBox(height: 1.h),
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
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                        decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                                        child: Text(
                                          novel["genre"] as String,
                                          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: AppTheme.lightTheme.colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 9.sp),
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                      Row(
                                        children: [
                                          CustomIconWidget(iconName: 'access_time', color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6), size: 12),
                                          SizedBox(width: 1.w),
                                          Text(
                                            novel["lastUpdate"] as String,
                                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 9.sp),
                                          ),
                                        ],
                                      ),
                                    ],
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
            Text(
              novel["title"] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(iconName: 'menu_book', color: AppTheme.lightTheme.colorScheme.primary, size: 24),
              title: const Text('Continuar Leyendo'),
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
