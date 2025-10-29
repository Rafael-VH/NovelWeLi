import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_image_widget.dart';

class NovelHeroSection extends StatelessWidget {
  final Map<String, dynamic> novelData;

  const NovelHeroSection({super.key, required this.novelData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 50.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Background cover image
          Positioned.fill(
            child: CustomImageWidget(
              imageUrl: novelData['coverImage'] ?? '',
              width: double.infinity,
              height: 50.h,
              fit: BoxFit.cover,
              semanticLabel: novelData['coverImageSemanticLabel'] ?? 'Novel cover image',
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.3), Colors.black.withValues(alpha: 0.8)],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          // Content overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Novel title
                  Text(
                    novelData['title'] ?? 'Título no disponible',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(offset: const Offset(0, 1), blurRadius: 3, color: Colors.black.withValues(alpha: 0.5))],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  // Author name
                  Text(
                    'Por ${novelData['author'] ?? 'Autor desconocido'}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      shadows: [Shadow(offset: const Offset(0, 1), blurRadius: 2, color: Colors.black.withValues(alpha: 0.5))],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.5.h),
                  // Rating row
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        final rating = (novelData['rating'] as double?) ?? 0.0;
                        final isFullStar = index < rating.floor();
                        final isHalfStar = index == rating.floor() && rating % 1 >= 0.5;
                        return CustomIconWidget(
                          iconName: isFullStar
                              ? 'star'
                              : isHalfStar
                              ? 'star_half'
                              : 'star_border',
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                      SizedBox(width: 2.w),
                      Text(
                        '${novelData['rating']?.toStringAsFixed(1) ?? '0.0'} (${novelData['reviewCount'] ?? 0} reseñas)',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          shadows: [Shadow(offset: const Offset(0, 1), blurRadius: 2, color: Colors.black.withValues(alpha: 0.5))],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
