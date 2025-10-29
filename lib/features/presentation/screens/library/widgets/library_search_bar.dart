import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/core/themes/app_theme.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';

class LibrarySearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final String hintText;

  const LibrarySearchBar({super.key, required this.onSearchChanged, this.hintText = 'Buscar en biblioteca...'});

  @override
  State<LibrarySearchBar> createState() => _LibrarySearchBarState();
}

class _LibrarySearchBarState extends State<LibrarySearchBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _isSearchActive = value.isNotEmpty;
          });
          widget.onSearchChanged(value);
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(iconName: 'search', color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6), size: 20),
          ),
          suffixIcon: _isSearchActive
              ? IconButton(
                  icon: CustomIconWidget(iconName: 'close', color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6), size: 20),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _isSearchActive = false;
                    });
                    widget.onSearchChanged('');
                  },
                )
              : null,
          filled: true,
          fillColor: AppTheme.lightTheme.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.lightTheme.colorScheme.primary, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        ),
      ),
    );
  }
}
