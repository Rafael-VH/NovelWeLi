import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';

class RecentSearchesWidget extends StatelessWidget {
  final List<String> recentSearches;
  final Function(String) onSearchTapped;
  final VoidCallback onClearHistory;
  const RecentSearchesWidget({super.key, required this.recentSearches, required this.onSearchTapped, required this.onClearHistory});
  @override
  Widget build(BuildContext context) {
    if (recentSearches.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Búsquedas recientes', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              TextButton(
                onPressed: () {
                  onClearHistory();
                  HapticFeedback.lightImpact();
                },
                child: Text('Limpiar', style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.primary)),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: recentSearches.take(5).map((search) {
              return GestureDetector(
                onTap: () {
                  onSearchTapped(search);
                  HapticFeedback.lightImpact();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(iconName: 'history', color: colorScheme.onSurface.withValues(alpha: 0.6), size: 16),
                      SizedBox(width: 2.w),
                      Flexible(
                        child: Text(search, style: theme.textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
