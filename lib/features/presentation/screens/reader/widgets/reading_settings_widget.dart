import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:novel_we_li/core/themes/app_theme.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';

class ReadingSettingsWidget extends StatefulWidget {
  final double fontSize;
  final String fontFamily;
  final Color backgroundColor;
  final double lineSpacing;
  final ValueChanged<double>? onFontSizeChanged;
  final ValueChanged<String>? onFontFamilyChanged;
  final ValueChanged<Color>? onBackgroundColorChanged;
  final ValueChanged<double>? onLineSpacingChanged;
  final VoidCallback? onClose;
  const ReadingSettingsWidget({
    super.key,
    required this.fontSize,
    required this.fontFamily,
    required this.backgroundColor,
    required this.lineSpacing,
    this.onFontSizeChanged,
    this.onFontFamilyChanged,
    this.onBackgroundColorChanged,
    this.onLineSpacingChanged,
    this.onClose,
  });
  @override
  State<ReadingSettingsWidget> createState() => _ReadingSettingsWidgetState();
}

class _ReadingSettingsWidgetState extends State<ReadingSettingsWidget> {
  final List<String> _fontFamilies = ['Inter', 'Merriweather', 'Georgia', 'Times New Roman', 'Arial'];
  final List<Color> _backgroundColors = [
    Colors.white,
    const Color(0xFFF5F5DC), // Beige
    const Color(0xFF2C2C2C), // Dark gray
    Colors.black, const Color(0xFFFFF8DC), // Cornsilk
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFontSizeSection(),
                  SizedBox(height: 3.h),
                  _buildFontFamilySection(),
                  SizedBox(height: 3.h),
                  _buildBackgroundColorSection(),
                  SizedBox(height: 3.h),
                  _buildLineSpacingSection(),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text('Configuración de Lectura', style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onClose?.call();
            },
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: CustomIconWidget(iconName: 'close', color: AppTheme.lightTheme.colorScheme.onSurface, size: 5.w),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFontSizeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tamaño de Fuente', style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: 2.h),
        Row(
          children: [
            Text('A', style: AppTheme.lightTheme.textTheme.bodySmall),
            Expanded(
              child: Slider(
                value: widget.fontSize,
                min: 12.0,
                max: 24.0,
                divisions: 12,
                onChanged: (value) {
                  HapticFeedback.selectionClick();
                  widget.onFontSizeChanged?.call(value);
                },
                activeColor: AppTheme.lightTheme.colorScheme.primary,
                inactiveColor: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            Text('A', style: AppTheme.lightTheme.textTheme.titleLarge),
          ],
        ),
        Center(
          child: Text(
            'Texto de ejemplo con tamaño ${widget.fontSize.toInt()}sp',
            style: TextStyle(fontSize: widget.fontSize, fontFamily: widget.fontFamily),
          ),
        ),
      ],
    );
  }

  Widget _buildFontFamilySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Familia de Fuente', style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _fontFamilies.map((font) {
            final isSelected = font == widget.fontFamily;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                widget.onFontFamilyChanged?.call(font);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.lightTheme.colorScheme.primary : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isSelected ? AppTheme.lightTheme.colorScheme.primary : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3)),
                ),
                child: Text(
                  font,
                  style: TextStyle(
                    fontFamily: font,
                    color: isSelected ? AppTheme.lightTheme.colorScheme.onPrimary : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBackgroundColorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color de Fondo', style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _backgroundColors.map((color) {
            final isSelected = color == widget.backgroundColor;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                widget.onBackgroundColorChanged?.call(color);
              },
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isSelected ? AppTheme.lightTheme.colorScheme.primary : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3), width: isSelected ? 3 : 1),
                ),
                child: isSelected
                    ? Center(
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: color == Colors.white || color == const Color(0xFFF5F5DC) || color == const Color(0xFFFFF8DC) ? AppTheme.lightTheme.colorScheme.primary : Colors.white,
                          size: 5.w,
                        ),
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLineSpacingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Espaciado de Línea', style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: 2.h),
        Slider(
          value: widget.lineSpacing,
          min: 1.0,
          max: 2.5,
          divisions: 15,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            widget.onLineSpacingChanged?.call(value);
          },
          activeColor: AppTheme.lightTheme.colorScheme.primary,
          inactiveColor: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        Center(child: Text('Espaciado: ${widget.lineSpacing.toStringAsFixed(1)}', style: AppTheme.lightTheme.textTheme.bodyMedium)),
      ],
    );
  }
}
