import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activeFilters;
  final Function(String) onFilterRemoved;
  final VoidCallback onClearAll;
  const FilterChipsWidget({super.key, required this.activeFilters, required this.onFilterRemoved, required this.onClearAll});
  @override
  Widget build(BuildContext context) {
    if (activeFilters.isEmpty) return const SizedBox.shrink();
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
              Text('Filtros activos (${activeFilters.length})', style: theme.textTheme.titleSmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.8))),
              TextButton(
                onPressed: () {
                  onClearAll();
                  HapticFeedback.lightImpact();
                },
                child: Text('Limpiar todo', style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.primary)),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: activeFilters
                .map((filter) {
                  return FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(filter['label'] as String, style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onPrimary)),
                        if (filter['count'] != null) ...[
                          SizedBox(width: 1.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.2.h),
                            decoration: BoxDecoration(color: colorScheme.onPrimary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              '${filter['count']}',
                              style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onPrimary, fontSize: 10.sp),
                            ),
                          ),
                        ],
                      ],
                    ),
                    onSelected: (bool value) {},
                    // Add this required parameter
                    onDeleted: () {
                      onFilterRemoved(filter['key'] as String);
                      HapticFeedback.lightImpact();
                    },
                    deleteIcon: CustomIconWidget(iconName: 'close', color: colorScheme.onPrimary, size: 16),
                    backgroundColor: colorScheme.primary,
                    selectedColor: colorScheme.primary,
                    selected: true,
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  );
                })
                .toList()
                .cast<Widget>(),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
