import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/core/app_export.dart';

class LibrarySegmentControl extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSegmentChanged;

  const LibrarySegmentControl({super.key, required this.selectedIndex, required this.onSegmentChanged});

  @override
  Widget build(BuildContext context) {
    final segments = ['Leyendo', 'Descargados', 'Favoritos'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: segments.asMap().entries.map((entry) {
          final index = entry.key;
          final segment = entry.value;
          final isSelected = index == selectedIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onSegmentChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                decoration: BoxDecoration(color: isSelected ? AppTheme.lightTheme.colorScheme.primary : Colors.transparent, borderRadius: BorderRadius.circular(10)),
                child: Text(
                  segment,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? AppTheme.lightTheme.colorScheme.onPrimary : AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
