import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_image_widget.dart';

class ReviewsSection extends StatefulWidget {
  final List<Map<String, dynamic>> reviews;
  final double averageRating;
  final int totalReviews;

  const ReviewsSection({super.key, required this.reviews, required this.averageRating, required this.totalReviews});

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  bool _showAllReviews = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayReviews = _showAllReviews ? widget.reviews : widget.reviews.take(3).toList();

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reseñas',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to all reviews screen
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navegando a todas las reseñas...'), duration: Duration(seconds: 1)));
                  },
                  child: Text(
                    'Ver todas',
                    style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          // Rating summary
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                // Average rating
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Text(
                        widget.averageRating.toStringAsFixed(1),
                        style: theme.textTheme.headlineMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (index) {
                          final isFullStar = index < widget.averageRating.floor();
                          final isHalfStar = index == widget.averageRating.floor() && widget.averageRating % 1 >= 0.5;

                          return CustomIconWidget(
                            iconName: isFullStar
                                ? 'star'
                                : isHalfStar
                                ? 'star_half'
                                : 'star_border',
                            color: Colors.amber,
                            size: 16,
                          );
                        }),
                      ),
                      SizedBox(height: 0.5.h),
                      Text('${widget.totalReviews} reseñas', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6))),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                // Rating breakdown
                Expanded(
                  child: Column(
                    children: List.generate(5, (index) {
                      final starCount = 5 - index;
                      final percentage = _calculateRatingPercentage(starCount);

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 0.5.h),
                        child: Row(
                          children: [
                            Text('$starCount', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6))),
                            SizedBox(width: 1.w),
                            CustomIconWidget(iconName: 'star', color: Colors.amber, size: 12),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: percentage / 100,
                                backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text('${percentage.toInt()}%', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6))),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          // Reviews list
          widget.reviews.isEmpty
              ? _buildEmptyReviews(context)
              : Column(
                  children: [
                    ...displayReviews.map((review) => _buildReviewItem(context, review)),
                    if (widget.reviews.length > 3 && !_showAllReviews) ...[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _showAllReviews = true;
                            });
                          },
                          child: Text(
                            'Ver ${widget.reviews.length - 3} reseñas más',
                            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(BuildContext context, Map<String, dynamic> review) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer info and rating
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                child: review['avatar'] != null
                    ? CustomImageWidget(imageUrl: review['avatar'] as String, width: 40, height: 40, fit: BoxFit.cover, semanticLabel: review['avatarSemanticLabel'] ?? 'User avatar')
                    : Text(
                        (review['username'] as String? ?? 'U')[0].toUpperCase(),
                        style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
                      ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['username'] ?? 'Usuario anónimo',
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          final rating = (review['rating'] as double?) ?? 0.0;

                          return CustomIconWidget(iconName: index < rating.floor() ? 'star' : 'star_border', color: Colors.amber, size: 14);
                        }),
                        SizedBox(width: 2.w),
                        Text(_formatReviewDate(review['date'] as String?), style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Review text
          Text(
            review['comment'] ?? 'Sin comentario',
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.8), height: 1.5),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          // Helpful votes
          if (review['helpfulVotes'] != null && (review['helpfulVotes'] as int) > 0) ...[
            Row(
              children: [
                CustomIconWidget(iconName: 'thumb_up', color: colorScheme.primary, size: 16),
                SizedBox(width: 1.w),
                Text('${review['helpfulVotes']} personas encontraron esto útil', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6))),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyReviews(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: [
          CustomIconWidget(iconName: 'rate_review', color: colorScheme.outline, size: 48),
          SizedBox(height: 2.h),
          Text('No hay reseñas aún', style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6))),
          SizedBox(height: 1.h),
          Text(
            'Sé el primero en dejar una reseña de esta novela',
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  double _calculateRatingPercentage(int starCount) {
    if (widget.totalReviews == 0) return 0.0;
    // Mock calculation - in real app, this would come from actual data
    switch (starCount) {
      case 5:
        return 45.0;
      case 4:
        return 30.0;
      case 3:
        return 15.0;
      case 2:
        return 7.0;
      case 1:
        return 3.0;
      default:
        return 0.0;
    }
  }

  String _formatReviewDate(String? date) {
    if (date == null) return 'Fecha desconocida';
    try {
      final reviewDate = DateTime.parse(date);
      final now = DateTime.now();
      final difference = now.difference(reviewDate);
      if (difference.inDays == 0) {
        return 'Hoy';
      } else if (difference.inDays == 1) {
        return 'Ayer';
      } else if (difference.inDays < 30) {
        return 'Hace ${difference.inDays} días';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return 'Hace ${months} mes${months > 1 ? 'es' : ''}';
      } else {
        final years = (difference.inDays / 365).floor();
        return 'Hace ${years} año${years > 1 ? 's' : ''}';
      }
    } catch (e) {
      return 'Fecha inválida';
    }
  }
}
