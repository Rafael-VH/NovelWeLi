import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Clase que contiene todas las configuraciones de tema para la aplicación móvil de lectura.
///
/// Esta clase proporciona:
/// - Temas optimizados para lectura (claro y oscuro)
/// - Paleta de colores coherente
/// - Tipografía optimizada para lectura extendida
/// - Configuraciones de componentes UI consistentes
class AppTheme {
  // Constructor privado para prevenir instanciación
  // Esta clase solo debe usarse como namespace para miembros estáticos
  AppTheme._();

  // ============================================================================
  // CONSTANTES DE DISEÑO
  // ============================================================================

  /// Border radius estándar para tarjetas y contenedores
  static const double radiusMedium = 12.0;

  /// Border radius pequeño para elementos compactos
  static const double radiusSmall = 8.0;

  /// Border radius grande para botones flotantes
  static const double radiusLarge = 16.0;

  /// Elevación estándar para tarjetas
  static const double elevationCard = 2.0;

  /// Elevación para elementos flotantes
  static const double elevationFAB = 6.0;

  /// Tamaño de iconos estándar
  static const double iconSize = 24.0;

  // ============================================================================
  // PALETA DE COLORES - TEMA CLARO
  // ============================================================================

  // Colores primarios optimizados para lectura diurna
  static const Color primaryLight = Color(0xFF2C3E50); // Azul oscuro para lectura
  static const Color primaryVariantLight = Color(0xFF34495E); // Soporte de navegación
  static const Color secondaryLight = Color(0xFFE74C3C); // Acento para marcadores
  static const Color secondaryVariantLight = Color(0xFFC0392B);

  // Colores de fondo y superficie
  static const Color backgroundLight = Color(0xFFFAFBFC); // Blanco suave para móvil
  static const Color surfaceLight = Color(0xFFFFFFFF); // Fondos de contenido limpios

  // Colores de estado
  static const Color errorLight = Color(0xFFE74C3C);
  static const Color successLight = Color(0xFF27AE60); // Completado de descargas
  static const Color warningLight = Color(0xFFF39C12); // Indicadores offline

  // Colores de texto sobre superficies
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color onBackgroundLight = Color(0xFF2C3E50);
  static const Color onSurfaceLight = Color(0xFF2C3E50);
  static const Color onErrorLight = Color(0xFFFFFFFF);

  // ============================================================================
  // PALETA DE COLORES - TEMA OSCURO
  // ============================================================================

  // Colores primarios optimizados para lectura nocturna y pantallas OLED
  static const Color primaryDark = Color(0xFF5DADE2);
  static const Color primaryVariantDark = Color(0xFF3498DB);
  static const Color secondaryDark = Color(0xFFE74C3C);
  static const Color secondaryVariantDark = Color(0xFFC0392B);

  // Colores de fondo y superficie - True dark para lectura nocturna
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color surfaceDark = Color(0xFF2C2C2C);

  // Colores de estado
  static const Color errorDark = Color(0xFFE74C3C);
  static const Color successDark = Color(0xFF27AE60);
  static const Color warningDark = Color(0xFFF39C12);

  // Colores de texto sobre superficies
  static const Color onPrimaryDark = Color(0xFF1A1A1A);
  static const Color onSecondaryDark = Color(0xFFFFFFFF);
  static const Color onBackgroundDark = Color(0xFFE8E8E8);
  static const Color onSurfaceDark = Color(0xFFE8E8E8);
  static const Color onErrorDark = Color(0xFFFFFFFF);

  // ============================================================================
  // COLORES ADICIONALES
  // ============================================================================

  // Colores de tarjetas y diálogos
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2C2C2C);
  static const Color dialogLight = Color(0xFFFFFFFF);
  static const Color dialogDark = Color(0xFF2C2C2C);

  // Colores de sombra para elevación sutil
  static const Color shadowLight = Color(0x33000000); // 20% opacidad
  static const Color shadowDark = Color(0x33FFFFFF);

  // Colores de divisor para separación de contenido
  static const Color dividerLight = Color(0x1A000000); // 10% opacidad
  static const Color dividerDark = Color(0x1AFFFFFF);

  // Colores de texto optimizados para lectura
  static const Color textPrimaryLight = Color(0xFF2C3E50); // Alto contraste
  static const Color textSecondaryLight = Color(0xFF7F8C8D); // Metadata
  static const Color textDisabledLight = Color(0xBDC3C7);
  static const Color textPrimaryDark = Color(0xFFE8E8E8);
  static const Color textSecondaryDark = Color(0xBDC3C7);
  static const Color textDisabledDark = Color(0xFF7F8C8D);

  // ============================================================================
  // TEMAS PRINCIPALES
  // ============================================================================

  /// Tema claro optimizado para lectura diurna
  ///
  /// Características:
  /// - Alto contraste para reducir fatiga visual
  /// - Fondos suaves que no cansan la vista
  /// - Tipografía optimizada para lectura extendida
  static ThemeData lightTheme = _buildTheme(
    brightness: Brightness.light,
    primary: primaryLight,
    primaryVariant: primaryVariantLight,
    secondary: secondaryLight,
    secondaryVariant: secondaryVariantLight,
    background: backgroundLight,
    surface: surfaceLight,
    card: cardLight,
    dialog: dialogLight,
    error: errorLight,
    success: successLight,
    warning: warningLight,
    onPrimary: onPrimaryLight,
    onSecondary: onSecondaryLight,
    onBackground: onBackgroundLight,
    onSurface: onSurfaceLight,
    onError: onErrorLight,
    shadow: shadowLight,
    divider: dividerLight,
    textPrimary: textPrimaryLight,
    textSecondary: textSecondaryLight,
    textDisabled: textDisabledLight,
    inverseSurface: surfaceDark,
    onInverseSurface: onSurfaceDark,
    inversePrimary: primaryDark,
  );

  /// Tema oscuro optimizado para lectura nocturna
  ///
  /// Características:
  /// - Optimizado para pantallas OLED (ahorro de batería)
  /// - Reduce fatiga visual en ambientes oscuros
  /// - Contraste suave que no deslumbra
  static ThemeData darkTheme = _buildTheme(
    brightness: Brightness.dark,
    primary: primaryDark,
    primaryVariant: primaryVariantDark,
    secondary: secondaryDark,
    secondaryVariant: secondaryVariantDark,
    background: backgroundDark,
    surface: surfaceDark,
    card: cardDark,
    dialog: dialogDark,
    error: errorDark,
    success: successDark,
    warning: warningDark,
    onPrimary: onPrimaryDark,
    onSecondary: onSecondaryDark,
    onBackground: onBackgroundDark,
    onSurface: onSurfaceDark,
    onError: onErrorDark,
    shadow: shadowDark,
    divider: dividerDark,
    textPrimary: textPrimaryDark,
    textSecondary: textSecondaryDark,
    textDisabled: textDisabledDark,
    inverseSurface: surfaceLight,
    onInverseSurface: onSurfaceLight,
    inversePrimary: primaryLight,
  );

  // ============================================================================
  // MÉTODOS HELPER PRIVADOS
  // ============================================================================

  /// Construye un tema completo con los colores proporcionados
  ///
  /// Este método centraliza la construcción de temas para evitar duplicación
  /// y facilitar el mantenimiento. Cualquier cambio en la estructura del tema
  /// solo necesita hacerse aquí.
  ///
  /// [brightness] - Brillo del tema (light o dark)
  /// [primary] - Color primario principal
  /// [primaryVariant] - Variante del color primario
  /// ... (otros parámetros de color)
  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color primaryVariant,
    required Color secondary,
    required Color secondaryVariant,
    required Color background,
    required Color surface,
    required Color card,
    required Color dialog,
    required Color error,
    required Color success,
    required Color warning,
    required Color onPrimary,
    required Color onSecondary,
    required Color onBackground,
    required Color onSurface,
    required Color onError,
    required Color shadow,
    required Color divider,
    required Color textPrimary,
    required Color textSecondary,
    required Color textDisabled,
    required Color inverseSurface,
    required Color onInverseSurface,
    required Color inversePrimary,
  }) {
    // Determinar si es tema claro
    final bool isLight = brightness == Brightness.light;

    return ThemeData(
      brightness: brightness,

      // Color Scheme - Define la paleta de colores del tema
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryVariant,
        onPrimaryContainer: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryVariant,
        onSecondaryContainer: onSecondary,
        tertiary: success,
        onTertiary: onPrimary,
        tertiaryContainer: success,
        onTertiaryContainer: onPrimary,
        error: error,
        onError: onError,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: textSecondary,
        outline: divider,
        outlineVariant: divider,
        shadow: shadow,
        scrim: shadow,
        inverseSurface: inverseSurface,
        onInverseSurface: onInverseSurface,
        inversePrimary: inversePrimary,
      ),

      // Colores base de scaffold, tarjetas y divisores
      scaffoldBackgroundColor: background,
      cardColor: card,
      dividerColor: divider,

      // AppBar Theme - Configuración de la barra de aplicación
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0, // Diseño flat moderno
        shadowColor: shadow,
        surfaceTintColor: Colors.transparent, // Evita tinte automático
        titleTextStyle: GoogleFonts.merriweather(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary),
        iconTheme: IconThemeData(color: textPrimary, size: iconSize),
      ),

      // Card Theme - Configuración de tarjetas
      cardTheme: CardThemeData(
        color: card,
        elevation: elevationCard,
        shadowColor: shadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
        margin: const EdgeInsets.all(8.0),
      ),

      // Bottom Navigation Bar Theme - Barra de navegación inferior
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        elevation: 8.0,
        type: BottomNavigationBarType.fixed, // Mantiene labels siempre visibles
        selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400),
      ),

      // Floating Action Button Theme - Botón de acción flotante
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondary,
        foregroundColor: onSecondary,
        elevation: elevationFAB,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLarge)),
      ),

      // Elevated Button Theme - Botones elevados (primarios)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: onPrimary,
          backgroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          elevation: elevationCard,
          shadowColor: shadow,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Outlined Button Theme - Botones con borde (secundarios)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          side: BorderSide(color: primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),

      // Text Button Theme - Botones de texto (terciarios)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSmall)),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),

      // Text Theme - Estilos de tipografía
      textTheme: _buildTextTheme(isLight: isLight),

      // Input Decoration Theme - Campos de texto
      inputDecorationTheme: InputDecorationTheme(
        fillColor: surface,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        // Border por defecto
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: divider),
        ),
        // Border cuando el campo está habilitado pero no enfocado
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: divider),
        ),
        // Border cuando el campo está enfocado
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: primary, width: 2.0),
        ),
        // Border cuando hay error
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: error, width: 1.5),
        ),
        // Border cuando hay error y está enfocado
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: error, width: 2.0),
        ),
        labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 16, fontWeight: FontWeight.w400),
        hintStyle: GoogleFonts.inter(color: textDisabled, fontSize: 16, fontWeight: FontWeight.w400),
      ),

      // Switch Theme - Interruptores de toggle
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return textDisabled;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            // Usar withOpacity en lugar de withValues para mejor compatibilidad
            return primary.withOpacity(0.3);
          }
          return textDisabled.withOpacity(0.2);
        }),
      ),

      // Checkbox Theme - Casillas de verificación
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(onPrimary),
        side: BorderSide(color: primary, width: 2.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      ),

      // Radio Theme - Botones de radio
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return textSecondary;
        }),
      ),

      // Progress Indicator Theme - Indicadores de progreso
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primary, linearTrackColor: divider),

      // Slider Theme - Controles deslizantes
      sliderTheme: SliderThemeData(activeTrackColor: primary, thumbColor: primary, overlayColor: primary.withOpacity(0.2), inactiveTrackColor: divider, trackHeight: 4.0),

      // Tab Bar Theme - Pestañas de navegación
      tabBarTheme: TabBarThemeData(
        labelColor: primary,
        unselectedLabelColor: textSecondary,
        indicatorColor: primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400),
      ),

      // Tooltip Theme - Tooltips informativos
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(color: textPrimary.withOpacity(0.9), borderRadius: BorderRadius.circular(radiusSmall)),
        textStyle: GoogleFonts.inter(color: isLight ? surface : background, fontSize: 14, fontWeight: FontWeight.w400),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // SnackBar Theme - Notificaciones emergentes
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: GoogleFonts.inter(color: isLight ? surface : background, fontSize: 16, fontWeight: FontWeight.w400),
        actionTextColor: secondary,
        behavior: SnackBarBehavior.floating, // Flotante en la parte inferior
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
        elevation: elevationFAB,
      ),

      // Dialog Theme - Diálogos y alertas
      dialogTheme: DialogThemeData(
        backgroundColor: dialog,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
      ),
    );
  }

  /// Construye el esquema de tipografía optimizado para lectura
  ///
  /// Utiliza dos familias de fuentes:
  /// - Merriweather: Para títulos y encabezados (serif, más formal)
  /// - Inter: Para cuerpo y UI (sans-serif, más legible en pantallas)
  /// - JetBrains Mono: Para labels pequeños y código (monospace)
  ///
  /// [isLight] - true para tema claro, false para tema oscuro
  static TextTheme _buildTextTheme({required bool isLight}) {
    // Seleccionar colores según el tema
    final Color textPrimary = isLight ? textPrimaryLight : textPrimaryDark;
    final Color textSecondary = isLight ? textSecondaryLight : textSecondaryDark;
    final Color textDisabled = isLight ? textDisabledLight : textDisabledDark;

    return TextTheme(
      // ========================================================================
      // DISPLAY - Para títulos de novelas y encabezados muy grandes
      // ========================================================================
      displayLarge: GoogleFonts.merriweather(fontSize: 57, fontWeight: FontWeight.w700, color: textPrimary, letterSpacing: -0.25, height: 1.12),
      displayMedium: GoogleFonts.merriweather(fontSize: 45, fontWeight: FontWeight.w700, color: textPrimary, letterSpacing: 0, height: 1.16),
      displaySmall: GoogleFonts.merriweather(fontSize: 36, fontWeight: FontWeight.w400, color: textPrimary, letterSpacing: 0, height: 1.22),

      // ========================================================================
      // HEADLINE - Para títulos de capítulos y encabezados de sección
      // ========================================================================
      headlineLarge: GoogleFonts.merriweather(fontSize: 32, fontWeight: FontWeight.w700, color: textPrimary, letterSpacing: 0, height: 1.25),
      headlineMedium: GoogleFonts.merriweather(fontSize: 28, fontWeight: FontWeight.w400, color: textPrimary, letterSpacing: 0, height: 1.29),
      headlineSmall: GoogleFonts.merriweather(fontSize: 24, fontWeight: FontWeight.w400, color: textPrimary, letterSpacing: 0, height: 1.33),

      // ========================================================================
      // TITLE - Para elementos de UI y navegación
      // ========================================================================
      titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: textPrimary, letterSpacing: 0, height: 1.27),
      titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary, letterSpacing: 0.15, height: 1.50),
      titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary, letterSpacing: 0.1, height: 1.43),

      // ========================================================================
      // BODY - Optimizado para lectura extendida de contenido
      // ========================================================================
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.5,
        height: 1.50, // Altura de línea cómoda para lectura
      ),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: textPrimary, letterSpacing: 0.25, height: 1.43),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: textSecondary, letterSpacing: 0.4, height: 1.33),

      // ========================================================================
      // LABEL - Para metadatos, etiquetas y elementos de UI pequeños
      // ========================================================================
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary, letterSpacing: 0.1, height: 1.43),
      labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: textSecondary, letterSpacing: 0.5, height: 1.33),
      labelSmall: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w500, color: textDisabled, letterSpacing: 0.5, height: 1.45),
    );
  }
}
