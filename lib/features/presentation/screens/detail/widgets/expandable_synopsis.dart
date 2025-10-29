import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/core/app_export.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';

class ExpandableSynopsis extends StatefulWidget {
  final String synopsis;

  const ExpandableSynopsis({super.key, required this.synopsis});

  @override
  State<ExpandableSynopsis> createState() => _ExpandableSynopsisState();
}

class _ExpandableSynopsisState extends State<ExpandableSynopsis> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final shouldShowToggle = widget.synopsis.length > 200;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Sinopsis',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),

          SizedBox(height: 1.h),
          // Synopsis content
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.synopsis.isEmpty ? 'No hay sinopsis disponible para esta novela.' : widget.synopsis,
                    style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.8), height: 1.6),
                    maxLines: shouldShowToggle ? (_isExpanded ? null : 4) : null,
                    overflow: shouldShowToggle ? (_isExpanded ? TextOverflow.visible : TextOverflow.ellipsis) : TextOverflow.visible,
                  ),
                  if (shouldShowToggle) ...[
                    SizedBox(height: 1.h),
                    // Read more/less button
                    GestureDetector(
                      onTap: _toggleExpansion,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _isExpanded ? 'Leer menos' : 'Leer más',
                              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 1.w),
                            AnimatedRotation(
                              turns: _isExpanded ? 0.5 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: CustomIconWidget(iconName: 'keyboard_arrow_down', color: colorScheme.primary, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
