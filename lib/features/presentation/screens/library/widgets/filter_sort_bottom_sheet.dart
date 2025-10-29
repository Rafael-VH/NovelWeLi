import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:novel_we_li/core/app_export.dart';

class FilterSortBottomSheet extends StatefulWidget {
  final String currentSortOption;
  final Function(String) onSortChanged;

  const FilterSortBottomSheet({super.key, required this.currentSortOption, required this.onSortChanged});

  @override
  State<FilterSortBottomSheet> createState() => _FilterSortBottomSheetState();
}

class _FilterSortBottomSheetState extends State<FilterSortBottomSheet> {
  late String selectedSort;
  final List<Map<String, dynamic>> sortOptions = [
    {'key': 'recent', 'title': 'Leído Recientemente', 'subtitle': 'Ordenar por última lectura', 'icon': 'schedule'},
    {'key': 'alphabetical', 'title': 'Alfabético', 'subtitle': 'Ordenar por título A-Z', 'icon': 'sort_by_alpha'},
    {'key': 'progress', 'title': 'Progreso', 'subtitle': 'Ordenar por porcentaje leído', 'icon': 'trending_up'},
    {'key': 'date_added', 'title': 'Fecha Agregado', 'subtitle': 'Ordenar por fecha de adición', 'icon': 'calendar_today'},
  ];
  @override
  void initState() {
    super.initState();
    selectedSort = widget.currentSortOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 10.w,
            height: 4,
            decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.outline, borderRadius: BorderRadius.circular(2)),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ordenar y Filtrar',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: AppTheme.lightTheme.colorScheme.onSurface),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(iconName: 'close', color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6), size: 24),
                ),
              ],
            ),
          ),
          // Sort Options
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ordenar por',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppTheme.lightTheme.colorScheme.onSurface),
                ),
                SizedBox(height: 2.h),
                ...sortOptions.map((option) {
                  final isSelected = selectedSort == option['key'];
                  return Container(
                    margin: EdgeInsets.only(bottom: 1.h),
                    child: ListTile(
                      leading: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1) : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: option['icon'] as String,
                            color: isSelected ? AppTheme.lightTheme.colorScheme.primary : AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                            size: 20,
                          ),
                        ),
                      ),
                      title: Text(
                        option['title'] as String,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: isSelected ? AppTheme.lightTheme.colorScheme.primary : AppTheme.lightTheme.colorScheme.onSurface),
                      ),
                      subtitle: Text(
                        option['subtitle'] as String,
                        style: TextStyle(fontSize: 12.sp, color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6)),
                      ),
                      trailing: isSelected ? CustomIconWidget(iconName: 'check_circle', color: AppTheme.lightTheme.colorScheme.primary, size: 24) : null,
                      onTap: () {
                        setState(() {
                          selectedSort = option['key'] as String;
                        });
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      tileColor: isSelected ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05) : Colors.transparent,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          // Apply Button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            child: ElevatedButton(
              onPressed: () {
                widget.onSortChanged(selectedSort);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              child: Text(
                'Aplicar',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
