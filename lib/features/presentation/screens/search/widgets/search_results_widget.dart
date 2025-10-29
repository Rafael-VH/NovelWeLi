import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_image_widget.dart';
import 'package:sizer/sizer.dart';

class SearchResultsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> searchResults;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback onLoadMore;
  final Function(Map<String, dynamic>) onNovelTapped;
  final Function(Map<String, dynamic>) onAddToLibrary;
  final Function(Map<String, dynamic>) onDownload;

  const SearchResultsWidget({
    super.key,
    required this.searchResults,
    required this.isLoading,
    required this.hasMore,
    required this.onLoadMore,
    required this.onNovelTapped,
    required this.onAddToLibrary,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (searchResults.isEmpty && !isLoading) {
      return _buildEmptyState(theme, colorScheme);
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: searchResults.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == searchResults.length) {
          return _buildLoadMoreIndicator(theme, colorScheme);
        }

        final novel = searchResults[index];

        return _buildNovelCard(novel, theme, colorScheme);
      },
    );
  }

  Widget _buildNovelCard(Map<String, dynamic> novel, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: InkWell(
        onTap: () {
          onNovelTapped(novel);
          HapticFeedback.lightImpact();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(imageUrl: novel['cover'] as String, width: 20.w, height: 12.h, fit: BoxFit.cover, semanticLabel: novel['semanticLabel'] as String),
              ),
              SizedBox(width: 3.w),
              // Novel details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      novel['title'] as String,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      novel['author'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    // Rating and chapters
                    Row(
                      children: [
                        CustomIconWidget(iconName: 'star', color: Colors.amber, size: 16),
                        SizedBox(width: 1.w),
                        Text('${novel['rating']}', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                        SizedBox(width: 3.w),
                        CustomIconWidget(iconName: 'menu_book', color: colorScheme.onSurface.withValues(alpha: 0.6), size: 16),
                        SizedBox(width: 1.w),
                        Text('${novel['chapters']} cap.', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7))),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    // Genre tags
                    Wrap(
                      spacing: 1.w,
                      children: ((novel['genres'] as List<dynamic>?) ?? [])
                          .take(2)
                          .map(
                            (genre) => Container(
                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                              decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                genre as String,
                                style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 1.h),
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              onAddToLibrary(novel);
                              HapticFeedback.lightImpact();
                            },
                            icon: CustomIconWidget(iconName: 'library_add', color: colorScheme.primary, size: 16),
                            label: Text('Biblioteca', style: theme.textTheme.labelMedium),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              onDownload(novel);
                              HapticFeedback.lightImpact();
                            },
                            icon: CustomIconWidget(iconName: 'download', color: colorScheme.onPrimary, size: 16),
                            label: Text('Descargar', style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onPrimary)),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
      ),
    );
  }

  Widget _buildLoadMoreIndicator(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : Center(
              child: ElevatedButton(
                onPressed: onLoadMore,
                child: Text('Cargar más resultados', style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onPrimary)),
              ),
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(iconName: 'search_off', color: colorScheme.onSurface.withValues(alpha: 0.4), size: 64),
          SizedBox(height: 2.h),
          Text(
            'No se encontraron resultados',
            style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Intenta con diferentes palabras clave o ajusta los filtros',
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          OutlinedButton(
            onPressed: () {
              // Show suggestions or popular categories
            },
            child: Text('Ver sugerencias'),
          ),
        ],
      ),
    );
  }
}
