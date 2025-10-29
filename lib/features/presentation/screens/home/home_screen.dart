import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/core/themes/app_theme.dart';
import 'package:novel_we_li/features/presentation/screens/home/widgets/browse_categories_section.dart';
import 'package:novel_we_li/features/presentation/screens/home/widgets/featured_novels_carousel.dart';
import 'package:novel_we_li/features/presentation/screens/home/widgets/popular_this_week_carousel.dart';
import 'package:novel_we_li/features/presentation/screens/home/widgets/recently_updated_carousel.dart';
import 'package:novel_we_li/features/presentation/screens/home/widgets/recommended_for_you_carousel.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_app_bar.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_bottom_bar.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;
  late AnimationController _fabAnimationController;
  bool _showFab = true;
  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _fabAnimationController.forward();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && _showFab) {
      setState(() => _showFab = false);
      _fabAnimationController.reverse();
    } else if (_scrollController.offset <= 100 && !_showFab) {
      setState(() => _showFab = true);
      _fabAnimationController.forward();
    }
  }

  Future<void> _onRefresh() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);
    HapticFeedback.mediumImpact();

    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isRefreshing = false);
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'NovelReader',
        variant: CustomAppBarVariant.standard,
        showSearchIcon: true,
        onSearchPressed: () {
          HapticFeedback.lightImpact();
          Navigator.pushNamed(context, '/search-screen');
        },
        actions: [
          IconButton(
            icon: CustomIconWidget(iconName: 'notifications_outlined', color: AppTheme.lightTheme.colorScheme.onSurface, size: 24),
            onPressed: () {
              HapticFeedback.lightImpact();
              _showNotificationsBottomSheet();
            },
            tooltip: 'Notificaciones',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppTheme.lightTheme.colorScheme.primary,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            if (_isRefreshing)
              SliverToBoxAdapter(
                child: Container(
                  height: 4,
                  child: LinearProgressIndicator(
                    backgroundColor: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.lightTheme.colorScheme.primary),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),

                  // Welcome Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡Bienvenido de vuelta!',
                          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.lightTheme.colorScheme.onSurface),
                        ),
                        SizedBox(height: 0.5.h),
                        Text('Descubre nuevas historias increíbles', style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7))),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Featured Novels Carousel
                  const FeaturedNovelsCarousel(),

                  SizedBox(height: 3.h),

                  // Recently Updated Carousel
                  const RecentlyUpdatedCarousel(),

                  SizedBox(height: 3.h),

                  // Popular This Week Carousel
                  const PopularThisWeekCarousel(),

                  SizedBox(height: 3.h),

                  // Recommended For You Carousel
                  const RecommendedForYouCarousel(),

                  SizedBox(height: 3.h),

                  // Browse Categories Section
                  const BrowseCategoriesSection(),

                  SizedBox(height: 10.h), // Extra space for bottom navigation
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnimationController.value,
            child: FloatingActionButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pushNamed(context, '/search-screen');
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              foregroundColor: Colors.white,
              elevation: 6,
              child: CustomIconWidget(iconName: 'search', color: Colors.white, size: 28),
            ),
          );
        },
      ),

      bottomNavigationBar: CustomBottomBar(currentIndex: 0, variant: CustomBottomBarVariant.standard, items: []),
    );
  }

  void _showNotificationsBottomSheet() {
    final List<Map<String, dynamic>> notifications = [
      {"id": 1, "title": "Nueva actualización", "message": "El Último Emperador Inmortal tiene un nuevo capítulo disponible", "time": "Hace 2 horas", "type": "update", "isRead": false},
      {
        "id": 2,
        "title": "Recomendación personalizada",
        "message": "Basado en tus lecturas, te podría gustar 'El Camino del Samurái'",
        "time": "Hace 5 horas",
        "type": "recommendation",
        "isRead": false,
      },
      {"id": 3, "title": "Descarga completada", "message": "Academia de Magia Moderna se ha descargado correctamente", "time": "Hace 1 día", "type": "download", "isRead": true},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Container(
                    width: 10.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.outline, borderRadius: BorderRadius.circular(2)),
                  ),

                  SizedBox(height: 2.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Notificaciones', style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                      TextButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                        },
                        child: Text(
                          'Marcar como leídas',
                          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.lightTheme.colorScheme.primary, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(iconName: 'notifications_off', color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.4), size: 48),

                          SizedBox(height: 2.h),

                          Text('No hay notificaciones', style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6))),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemCount: notifications.length,
                      separatorBuilder: (context, index) => Divider(color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2), height: 1),
                      itemBuilder: (context, index) {
                        final notification = notifications[index];

                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 1.h),
                          leading: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(color: _getNotificationColor(notification["type"] as String).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                            child: CustomIconWidget(iconName: _getNotificationIcon(notification["type"] as String), color: _getNotificationColor(notification["type"] as String), size: 20),
                          ),
                          title: Text(
                            notification["title"] as String,
                            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                              fontWeight: (notification["isRead"] as bool) ? FontWeight.w500 : FontWeight.w700,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 0.5.h),

                              Text(
                                notification["message"] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7)),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              SizedBox(height: 0.5.h),

                              Text(
                                notification["time"] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 10.sp),
                              ),
                            ],
                          ),
                          trailing: !(notification["isRead"] as bool)
                              ? Container(
                                  width: 2.w,
                                  height: 2.w,
                                  decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.primary, shape: BoxShape.circle),
                                )
                              : null,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _getNotificationIcon(String type) {
    switch (type) {
      case 'update':
        return 'new_releases';
      case 'recommendation':
        return 'auto_awesome';
      case 'download':
        return 'download_done';
      default:
        return 'notifications';
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'update':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'recommendation':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'download':
        return AppTheme.successLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurface;
    }
  }
}
