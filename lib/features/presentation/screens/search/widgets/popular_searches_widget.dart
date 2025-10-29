import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:novel_we_li/core/app_export.dart';

class PopularSearchesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> popularSearches;
  final Function(String) onSearchTapped;
  const PopularSearchesWidget({super.key, required this.popularSearches, required this.onSearchTapped});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Búsquedas populares', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 2.h),
          SizedBox(
            height: 20.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popularSearches.length,
              itemBuilder: (context, index) {
                final search = popularSearches[index];
                return GestureDetector(
                  onTap: () {
                    onSearchTapped(search['title'] as String);
                    HapticFeedback.lightImpact();
                  },
                  child: Container(
                    width: 35.w,
                    margin: EdgeInsets.only(right: 3.w),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: CustomImageWidget(imageUrl: search['image'] as String, width: 35.w, height: 12.h, fit: BoxFit.cover, semanticLabel: search['semanticLabel'] as String),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(2.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  search['title'] as String,
                                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  search['author'] as String,
                                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    CustomIconWidget(iconName: 'trending_up', color: colorScheme.primary, size: 14),
                                    SizedBox(width: 1.w),
                                    Text(
                                      'Tendencia',
                                      style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w500),
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
                );
              },
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
