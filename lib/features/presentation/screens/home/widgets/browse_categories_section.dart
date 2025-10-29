import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/core/themes/app_theme.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';

class BrowseCategoriesSection extends StatelessWidget {
  const BrowseCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {"id": 1, "name": "Fantasía", "icon": "auto_awesome", "color": const Color(0xFF9C27B0), "novelCount": "2.5K"},
      {"id": 2, "name": "Romance", "icon": "favorite", "color": const Color(0xFFE91E63), "novelCount": "1.8K"},
      {"id": 3, "name": "Acción", "icon": "flash_on", "color": const Color(0xFFFF5722), "novelCount": "1.2K"},
      {"id": 4, "name": "Misterio", "icon": "search", "color": const Color(0xFF607D8B), "novelCount": "950"},
      {"id": 5, "name": "Ciencia Ficción", "icon": "rocket_launch", "color": const Color(0xFF2196F3), "novelCount": "1.1K"},
      {"id": 6, "name": "Histórica", "icon": "castle", "color": const Color(0xFF795548), "novelCount": "680"},
      {"id": 7, "name": "Aventura", "icon": "explore", "color": const Color(0xFF4CAF50), "novelCount": "890"},
      {"id": 8, "name": "Drama", "icon": "theater_comedy", "color": const Color(0xFFFF9800), "novelCount": "720"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Explorar Categorías',
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 3.w, mainAxisSpacing: 2.h, childAspectRatio: 2.5),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, '/search-screen');
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [(category["color"] as Color).withValues(alpha: 0.8), (category["color"] as Color).withValues(alpha: 0.6)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: (category["color"] as Color).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -10,
                        right: -10,
                        child: Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle),
                        ),
                      ),
                      Positioned(
                        bottom: -15,
                        left: -15,
                        child: Container(
                          width: 15.w,
                          height: 15.w,
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), shape: BoxShape.circle),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                                  child: CustomIconWidget(iconName: category["icon"] as String, color: Colors.white, size: 24),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                                  child: Text(
                                    category["novelCount"] as String,
                                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 10.sp),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category["name"] as String,
                                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  'Novelas disponibles',
                                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.8), fontSize: 10.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
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
