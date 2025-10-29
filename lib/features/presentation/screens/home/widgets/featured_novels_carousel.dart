import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/core/themes/app_theme.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_image_widget.dart';

class FeaturedNovelsCarousel extends StatelessWidget {
  const FeaturedNovelsCarousel({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> featuredNovels = [
      {
        "id": 1,
        "title": "El Reino de las Sombras Eternas",
        "author": "María Elena Vásquez",
        "rating": 4.8,
        "coverImage": "https://images.unsplash.com/photo-1626027006699-04c9fb7f08d5",
        "semanticLabel": "Mystical book cover featuring a dark castle silhouette against a starry purple night sky with golden magical particles floating around",
        "genre": "Fantasía",
        "chapters": 245,
        "status": "Completada",
      },
      {
        "id": 2,
        "title": "Academia de Magia Moderna",
        "author": "Carlos Mendoza",
        "rating": 4.6,
        "coverImage": "https://images.unsplash.com/photo-1458835200921-dbfef42ae3e8",
        "semanticLabel": "Modern fantasy book cover showing a contemporary school building with magical blue energy swirling around it and students in uniforms",
        "genre": "Fantasía Urbana",
        "chapters": 189,
        "status": "En progreso",
      },
      {
        "id": 3,
        "title": "El Último Emperador Inmortal",
        "author": "Ana Sofía Ruiz",
        "rating": 4.9,
        "coverImage": "https://images.unsplash.com/photo-1586640162563-fc0a01074e22",
        "semanticLabel": "Epic fantasy cover depicting a golden throne room with ornate pillars and a figure in imperial robes standing before a massive window",
        "genre": "Fantasía Épica",
        "chapters": 312,
        "status": "Completada",
      },
      {
        "id": 4,
        "title": "Cazadores de Demonios",
        "author": "Roberto Silva",
        "rating": 4.7,
        "coverImage": "https://images.unsplash.com/photo-1613253089386-a6a9cdcd1018",
        "semanticLabel": "Dark action book cover featuring silhouettes of warriors with glowing weapons against a red apocalyptic sky with demonic shadows",
        "genre": "Acción",
        "chapters": 156,
        "status": "En progreso",
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
                'Novelas Destacadas',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.lightTheme.colorScheme.onSurface),
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, '/search-screen');
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
          height: 32.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            itemCount: featuredNovels.length,
            itemBuilder: (context, index) {
              final novel = featuredNovels[index];
              return Container(
                width: 70.w,
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
                          colors: [AppTheme.lightTheme.colorScheme.surface, AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.8)],
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
                                        decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomIconWidget(iconName: 'star', color: AppTheme.warningLight, size: 16),
                                            SizedBox(width: 1.w),
                                            Text(
                                              novel["rating"].toString(),
                                              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.lightTheme.colorScheme.onSurface),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 2.w,
                                      left: 2.w,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                                        decoration: BoxDecoration(
                                          color: novel["status"] == "Completada" ? AppTheme.successLight.withValues(alpha: 0.9) : AppTheme.warningLight.withValues(alpha: 0.9),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          novel["status"] as String,
                                          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 10.sp),
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
                                  SizedBox(height: 1.h),
                                  Text(
                                    'Por ${novel["author"]}',
                                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                        decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                                        child: Text(
                                          novel["genre"] as String,
                                          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: AppTheme.lightTheme.colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 10.sp),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${novel["chapters"]} cap.',
                                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 10.sp),
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
              leading: CustomIconWidget(iconName: 'library_add', color: AppTheme.lightTheme.colorScheme.primary, size: 24),
              title: const Text('Añadir a Biblioteca'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
            ListTile(
              leading: CustomIconWidget(iconName: 'download', color: AppTheme.successLight, size: 24),
              title: const Text('Descargar'),
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
