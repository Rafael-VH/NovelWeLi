import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SkeletonLoadingWidget extends StatefulWidget {
  final int itemCount;

  const SkeletonLoadingWidget({super.key, this.itemCount = 5});

  @override
  State<SkeletonLoadingWidget> createState() => _SkeletonLoadingWidgetState();
}

class _SkeletonLoadingWidgetState extends State<SkeletonLoadingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cover skeleton
                    Container(
                      width: 20.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: colorScheme.outline.withValues(alpha: _animation.value * 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    // Content skeleton
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title skeleton
                          Container(
                            width: double.infinity,
                            height: 2.h,
                            decoration: BoxDecoration(
                              color: colorScheme.outline.withValues(alpha: _animation.value * 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          // Author skeleton
                          Container(
                            width: 40.w,
                            height: 1.5.h,
                            decoration: BoxDecoration(
                              color: colorScheme.outline.withValues(alpha: _animation.value * 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          // Rating and chapters skeleton
                          Row(
                            children: [
                              Container(
                                width: 15.w,
                                height: 1.5.h,
                                decoration: BoxDecoration(
                                  color: colorScheme.outline.withValues(alpha: _animation.value * 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Container(
                                width: 20.w,
                                height: 1.5.h,
                                decoration: BoxDecoration(
                                  color: colorScheme.outline.withValues(alpha: _animation.value * 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          // Genre tags skeleton
                          Row(
                            children: [
                              Container(
                                width: 15.w,
                                height: 2.h,
                                decoration: BoxDecoration(
                                  color: colorScheme.outline.withValues(alpha: _animation.value * 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Container(
                                width: 18.w,
                                height: 2.h,
                                decoration: BoxDecoration(
                                  color: colorScheme.outline.withValues(alpha: _animation.value * 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          // Buttons skeleton
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 4.h,
                                  decoration: BoxDecoration(
                                    color: colorScheme.outline.withValues(alpha: _animation.value * 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Container(
                                  height: 4.h,
                                  decoration: BoxDecoration(
                                    color: colorScheme.outline.withValues(alpha: _animation.value * 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
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
        );
      },
    );
  }
}
