import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _progressAnimation;
  bool _isInitialized = false;
  double _initializationProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    // Progress animation controller
    _progressAnimationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    // Logo scale animation
    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _logoAnimationController, curve: Curves.elasticOut));
    // Logo fade animation
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Progress animation
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _progressAnimationController, curve: Curves.easeInOut));
    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Start progress animation
      _progressAnimationController.forward();
      // Simulate initialization steps with realistic timing
      await _performInitializationSteps();
      // Mark as initialized
      setState(() {
        _isInitialized = true;
      });
      // Wait a moment before navigation
      await Future.delayed(const Duration(milliseconds: 500));
      // Navigate to home screen
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home-screen', (route) => false);
      }
    } catch (e) {
      // Handle initialization errors gracefully
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home-screen', (route) => false);
      }
    }
  }

  Future<void> _performInitializationSteps() async {
    // Step 1: Check authentication status
    await _updateProgress(0.2, 'Verificando autenticación...');
    await Future.delayed(const Duration(milliseconds: 400));
    // Step 2: Load user preferences
    await _updateProgress(0.4, 'Cargando preferencias...');
    await Future.delayed(const Duration(milliseconds: 300));
    // Step 3: Fetch novel metadata cache
    await _updateProgress(0.6, 'Sincronizando biblioteca...');
    await Future.delayed(const Duration(milliseconds: 500));
    // Step 4: Prepare offline reading data
    await _updateProgress(0.8, 'Preparando lectura offline...');
    await Future.delayed(const Duration(milliseconds: 400));
    // Step 5: Finalize initialization
    await _updateProgress(1.0, 'Completando inicialización...');
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _updateProgress(double progress, String message) async {
    if (mounted) {
      setState(() {
        _initializationProgress = progress;
      });
    }
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.lightTheme.primaryColor, AppTheme.lightTheme.colorScheme.primaryContainer, AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8)],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo section
                Expanded(
                  flex: 3,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _logoAnimationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: FadeTransition(
                            opacity: _logoFadeAnimation,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // App logo with book icon
                                Container(
                                  width: 35.w,
                                  height: 35.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                                  ),
                                  child: Center(
                                    child: CustomIconWidget(iconName: 'menu_book', size: 18.w, color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                // App name
                                Text(
                                  'NovelReader',
                                  style: AppTheme.lightTheme.textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 24.sp, letterSpacing: 1.2),
                                ),
                                SizedBox(height: 1.h),
                                // App tagline
                                Text(
                                  'Tu biblioteca de novelas favoritas',
                                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.9), fontSize: 14.sp, fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Loading section
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Progress indicator
                      Container(
                        width: 60.w,
                        height: 4,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2)),
                        child: AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _progressAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2),
                                  boxShadow: [BoxShadow(color: Colors.white.withValues(alpha: 0.3), blurRadius: 4, spreadRadius: 1)],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 2.h),
                      // Loading text
                      Text(
                        _isInitialized ? 'Iniciando aplicación...' : 'Cargando...',
                        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.8), fontSize: 12.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                // Version info
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Text(
                    'Versión 1.0.0',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.6), fontSize: 10.sp, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
