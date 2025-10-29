import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/core/themes/app_theme.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';

class TextSelectionMenuWidget extends StatelessWidget {
  final String selectedText;
  final Offset position;
  final VoidCallback? onCopy;
  final VoidCallback? onHighlight;
  final VoidCallback? onNote;
  final VoidCallback? onDictionary;
  final VoidCallback? onClose;
  const TextSelectionMenuWidget({super.key, required this.selectedText, required this.position, this.onCopy, this.onHighlight, this.onNote, this.onDictionary, this.onClose});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx - 40.w,
      top: position.dy - 15.h,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: AppTheme.lightTheme.colorScheme.surface,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        child: Container(
          width: 80.w,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSelectedTextPreview(),
              SizedBox(height: 2.h),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedTextPreview() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(
        selectedText.length > 100 ? '${selectedText.substring(0, 100)}...' : selectedText,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: 'content_copy',
          label: 'Copiar',
          onTap: () {
            HapticFeedback.lightImpact();
            Clipboard.setData(ClipboardData(text: selectedText));
            onCopy?.call();
          },
        ),
        _buildActionButton(
          icon: 'highlight',
          label: 'Resaltar',
          onTap: () {
            HapticFeedback.lightImpact();
            onHighlight?.call();
          },
        ),
        _buildActionButton(
          icon: 'note_add',
          label: 'Nota',
          onTap: () {
            HapticFeedback.lightImpact();
            onNote?.call();
          },
        ),
        _buildActionButton(
          icon: 'search',
          label: 'Buscar',
          onTap: () {
            HapticFeedback.lightImpact();
            onDictionary?.call();
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({required String icon, required String label, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: CustomIconWidget(iconName: icon, color: AppTheme.lightTheme.colorScheme.primary, size: 5.w),
            ),
            SizedBox(height: 0.5.h),
            Text(label, style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
