import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/core/themes/app_theme.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';

class AutoScrollWidget extends StatefulWidget {
  final ScrollController scrollController;
  final bool isAutoScrolling;
  final double scrollSpeed;
  final ValueChanged<bool>? onAutoScrollToggle;
  final ValueChanged<double>? onSpeedChanged;
  const AutoScrollWidget({super.key, required this.scrollController, required this.isAutoScrolling, required this.scrollSpeed, this.onAutoScrollToggle, this.onSpeedChanged});
  @override
  State<AutoScrollWidget> createState() => _AutoScrollWidgetState();
}

class _AutoScrollWidgetState extends State<AutoScrollWidget> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void show() {
    _fadeController.forward();
  }

  void hide() {
    _fadeController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            margin: EdgeInsets.all(4.w),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 2))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                SizedBox(height: 2.h),
                _buildControls(),
                if (widget.isAutoScrolling) ...[SizedBox(height: 2.h), _buildSpeedControl()],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CustomIconWidget(iconName: 'auto_stories', color: AppTheme.lightTheme.colorScheme.primary, size: 6.w),
        SizedBox(width: 3.w),
        Expanded(
          child: Text('Desplazamiento Automático', style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            hide();
          },
          child: Container(
            padding: EdgeInsets.all(1.w),
            child: CustomIconWidget(iconName: 'close', color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6), size: 5.w),
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          icon: widget.isAutoScrolling ? 'pause' : 'play_arrow',
          label: widget.isAutoScrolling ? 'Pausar' : 'Iniciar',
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onAutoScrollToggle?.call(!widget.isAutoScrolling);
          },
          isPrimary: true,
        ),
        _buildControlButton(
          icon: 'fast_rewind',
          label: 'Más Lento',
          onTap: () {
            HapticFeedback.lightImpact();
            final newSpeed = (widget.scrollSpeed - 0.5).clamp(0.5, 5.0);
            widget.onSpeedChanged?.call(newSpeed);
          },
        ),
        _buildControlButton(
          icon: 'fast_forward',
          label: 'Más Rápido',
          onTap: () {
            HapticFeedback.lightImpact();
            final newSpeed = (widget.scrollSpeed + 0.5).clamp(0.5, 5.0);
            widget.onSpeedChanged?.call(newSpeed);
          },
        ),
      ],
    );
  }

  Widget _buildSpeedControl() {
    return Column(
      children: [
        Text('Velocidad: ${widget.scrollSpeed.toStringAsFixed(1)}x', style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        SizedBox(height: 1.h),
        Slider(
          value: widget.scrollSpeed,
          min: 0.5,
          max: 5.0,
          divisions: 9,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            widget.onSpeedChanged?.call(value);
          },
          activeColor: AppTheme.lightTheme.colorScheme.primary,
          inactiveColor: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ],
    );
  }

  Widget _buildControlButton({required String icon, required String label, VoidCallback? onTap, bool isPrimary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isPrimary ? AppTheme.lightTheme.colorScheme.primary : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isPrimary ? AppTheme.lightTheme.colorScheme.primary : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(iconName: icon, color: isPrimary ? AppTheme.lightTheme.colorScheme.onPrimary : AppTheme.lightTheme.colorScheme.onSurface, size: 6.w),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isPrimary ? AppTheme.lightTheme.colorScheme.onPrimary : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
