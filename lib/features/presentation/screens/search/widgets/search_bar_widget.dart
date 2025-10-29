import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:novel_we_li/core/app_export.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback? onVoicePressed;
  final VoidCallback? onClearPressed;
  final String hintText;

  const SearchBarWidget({super.key, required this.controller, required this.onChanged, this.onVoicePressed, this.onClearPressed, this.hintText = 'Buscar novelas, autores...'});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _hasFocus = hasFocus;
          });
        },
        child: TextField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6)),
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(iconName: 'search', color: _hasFocus ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6), size: 20),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.controller.text.isNotEmpty)
                  IconButton(
                    icon: CustomIconWidget(iconName: 'clear', color: colorScheme.onSurface.withValues(alpha: 0.6), size: 20),
                    onPressed: () {
                      widget.controller.clear();
                      widget.onClearPressed?.call();
                      HapticFeedback.lightImpact();
                    },
                    tooltip: 'Limpiar búsqueda',
                  ),
                IconButton(
                  icon: CustomIconWidget(iconName: 'mic', color: colorScheme.primary, size: 20),
                  onPressed: () {
                    widget.onVoicePressed?.call();
                    HapticFeedback.lightImpact();
                  },
                  tooltip: 'Búsqueda por voz',
                ),
              ],
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            filled: true,
            fillColor: colorScheme.surface,
            contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          ),
        ),
      ),
    );
  }
}
