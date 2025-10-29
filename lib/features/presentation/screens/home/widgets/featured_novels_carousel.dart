import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/core/themes/app_theme.dart';
import 'package:novel_we_li/features/domain/entities/novel.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_image_widget.dart';

class FeaturedNovelsCarousel extends StatefulWidget {
  final List<Novel> novels;

  const FeaturedNovelsCarousel({super.key, required this.novels});

  @override
  State<FeaturedNovelsCarousel> createState() => _FeaturedNovelsCarouselState();
}

class _FeaturedNovelsCarouselState extends State<FeaturedNovelsCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.novels.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Destacados',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.lightTheme.colorScheme.onSurface),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to featured list
                },
                child: Text(
                  'Ver todos',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.lightTheme.colorScheme.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 25.h,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.novels.length,
            itemBuilder: (context, index) {
              final novel = widget.novels[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Background Image
                      CustomImageWidget(imageUrl: novel.coverImageUrl ?? '', height: 25.h, width: double.infinity, fit: BoxFit.cover, semanticLabel: 'Portada de ${novel.title}'),
                      // Gradient Overlay
                      Container(
                        height: 25.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)]),
                        ),
                      ),
                      // Content
                      Positioned(
                        bottom: 3.h,
                        left: 4.w,
                        right: 4.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              novel.title,
                              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(novel.author, style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9))),
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                CustomIconWidget(iconName: 'star', color: Colors.amber, size: 16),
                                SizedBox(width: 1.w),
                                Text(
                                  novel.rating.toStringAsFixed(1),
                                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Text(
                                    novel.genres.take(2).join(', '),
                                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 2.h),
        // Page Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.novels.length,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              width: _currentPage == index ? 4.w : 2.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: _currentPage == index ? AppTheme.lightTheme.colorScheme.primary : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
