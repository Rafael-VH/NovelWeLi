import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/core/themes/app_theme.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_image_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final String illustrationUrl;
  final String semanticLabel;
  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onButtonPressed,
    required this.illustrationUrl,
    required this.semanticLabel,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 60.w,
              height: 40.w,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
              child: CustomImageWidget(imageUrl: illustrationUrl, width: 60.w, height: 40.w, fit: BoxFit.contain, semanticLabel: semanticLabel),
            ),
            SizedBox(height: 4.h),
            // Title
            Text(
              title,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: AppTheme.lightTheme.colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            // Description
            Text(
              description,
              style: TextStyle(fontSize: 14.sp, color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7), height: 1.5),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            // Action Button
            SizedBox(
              width: 70.w,
              child: ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
