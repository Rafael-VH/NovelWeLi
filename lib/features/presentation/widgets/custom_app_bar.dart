import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Enum que define las variantes visuales del AppBar
// Permite cambiar el comportamiento y estilo según el contexto
enum CustomAppBarVariant {
  standard, // AppBar normal para la mayoría de pantallas
  reading, // Optimizado para lectura (menos distracciones)
  search, // Con funcionalidades de búsqueda
  minimal, // Mínimo (transparente, sin elevación)
}

/// CustomAppBar: AppBar reutilizable con múltiples variantes
///
/// Implementa PreferredSizeWidget para ser usado como appBar en Scaffold
/// Soporta diferentes estilos, progreso, búsqueda y navegación
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Constantes para valores numéricos reutilizables
  static const double _defaultIconSize = 24.0;
  static const double _progressIndicatorHeight = 4.0;
  static const double _bottomSheetBorderRadius = 20.0;
  static const double _bottomSheetPadding = 20.0;
  static const double _handleWidth = 40.0;
  static const double _handleHeight = 4.0;
  static const double _readingOpacity = 0.8;
  static const double _backgroundOpacity = 0.95;
  static const double _outlineOpacity = 0.2;

  // Propiedades del AppBar
  final String? title; // Título opcional
  final CustomAppBarVariant variant; // Estilo visual
  final List<Widget>? actions; // Acciones personalizadas adicionales
  final Widget? leading; // Widget personalizado al inicio
  final bool automaticallyImplyLeading; // Mostrar botón back automático
  final VoidCallback? onBackPressed; // Callback personalizado para back
  final bool showSearchIcon; // Mostrar icono de búsqueda
  final VoidCallback? onSearchPressed; // Callback para búsqueda
  final bool centerTitle; // Centrar el título
  final double? elevation; // Elevación personalizada
  final Color? backgroundColor; // Color de fondo personalizado
  final Color? foregroundColor; // Color de texto/iconos personalizado
  final bool showProgress; // Mostrar barra de progreso
  final double? progressValue; // Valor del progreso (null = indeterminado)

  // Callbacks para las acciones de lectura
  final VoidCallback? onBookmarkPressed; // Callback para marcador
  final VoidCallback? onTextSizePressed; // Callback para tamaño de texto
  final VoidCallback? onBrightnessPressed; // Callback para brillo
  final VoidCallback? onThemePressed; // Callback para tema de lectura
  final VoidCallback? onFilterPressed; // Callback para filtros de búsqueda

  const CustomAppBar({
    super.key,
    this.title,
    this.variant = CustomAppBarVariant.standard,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.onBackPressed,
    this.showSearchIcon = false,
    this.onSearchPressed,
    this.centerTitle = true,
    this.elevation,
    this.backgroundColor,
    this.foregroundColor,
    this.showProgress = false,
    this.progressValue,
    this.onBookmarkPressed,
    this.onTextSizePressed,
    this.onBrightnessPressed,
    this.onThemePressed,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener tema y esquema de colores del contexto
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: _buildTitle(context),
      leading: _buildLeading(context),
      actions: _buildActions(context),
      centerTitle: centerTitle,
      elevation: _getElevation(),
      backgroundColor: _getBackgroundColor(colorScheme),
      foregroundColor: _getForegroundColor(colorScheme),
      surfaceTintColor: Colors.transparent, // Elimina el tinte automático de Material 3
      systemOverlayStyle: _getSystemUiOverlayStyle(context), // Estilo de status bar
      bottom: showProgress ? _buildProgressIndicator(context) : null, // Barra de progreso opcional
      titleTextStyle: _getTitleTextStyle(context),
      iconTheme: IconThemeData(color: _getForegroundColor(colorScheme), size: _defaultIconSize),
    );
  }

  /// Construye el widget del título según la variante
  /// En modo lectura aplica una animación de opacidad para crear un efecto visual sutil
  Widget? _buildTitle(BuildContext context) {
    if (title == null) return null;

    switch (variant) {
      case CustomAppBarVariant.reading:
        // En modo lectura: título con animación de opacidad para efecto sutil
        return AnimatedOpacity(
          opacity: _readingOpacity,
          duration: const Duration(milliseconds: 300),
          child: Text(
            title!,
            style: _getTitleTextStyle(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Evita overflow en títulos largos
          ),
        );
      default:
        // Título estándar sin animación
        return Text(title!, style: _getTitleTextStyle(context), maxLines: 1, overflow: TextOverflow.ellipsis);
    }
  }

  /// Construye el widget leading (lado izquierdo del AppBar)
  /// Muestra un botón de retroceso si hay navegación disponible
  Widget? _buildLeading(BuildContext context) {
    // Si hay leading personalizado, usarlo con prioridad
    if (leading != null) return leading;

    // Si está habilitado y hay navegación previa, mostrar botón back
    if (automaticallyImplyLeading && Navigator.of(context).canPop()) {
      return IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: onBackPressed ?? () => Navigator.of(context).pop(), tooltip: 'Atrás');
    }

    return null;
  }

  /// Construye la lista de acciones (lado derecho del AppBar)
  /// Incluye iconos según la variante y acciones personalizadas
  List<Widget>? _buildActions(BuildContext context) {
    final List<Widget> actionWidgets = [];

    // Agregar icono de búsqueda si está habilitado
    if (showSearchIcon) {
      actionWidgets.add(
        IconButton(
          icon: const Icon(Icons.search_rounded),
          // Ahora requiere que se proporcione el callback onSearchPressed
          onPressed: onSearchPressed,
          tooltip: 'Buscar',
        ),
      );
    }

    // Agregar acciones específicas según la variante
    switch (variant) {
      case CustomAppBarVariant.reading:
        // Variante de lectura: marcador y menú de opciones
        actionWidgets.addAll([
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            onPressed: () {
              // Ejecuta el callback si existe
              if (onBookmarkPressed != null) {
                HapticFeedback.lightImpact(); // Feedback háptico
                onBookmarkPressed!();
              }
            },
            tooltip: 'Marcador',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {
              // Muestra bottom sheet con opciones de lectura
              _showReadingOptions(context);
            },
            tooltip: 'Opciones',
          ),
        ]);
        break;

      case CustomAppBarVariant.search:
        // Variante de búsqueda: botón de filtros
        actionWidgets.add(IconButton(icon: const Icon(Icons.filter_list_rounded), onPressed: onFilterPressed, tooltip: 'Filtros'));
        break;

      default:
        break;
    }

    // Agregar acciones personalizadas adicionales al final
    if (actions != null) {
      actionWidgets.addAll(actions!);
    }

    return actionWidgets.isNotEmpty ? actionWidgets : null;
  }

  /// Retorna la elevación según la variante o valor personalizado
  /// Las variantes reading y minimal tienen elevación 0 para un diseño más limpio
  double _getElevation() {
    if (elevation != null) return elevation!;

    switch (variant) {
      case CustomAppBarVariant.reading:
      case CustomAppBarVariant.minimal:
        return 0.0; // Sin sombra para lectura y mínimo
      default:
        return 0.0; // Por defecto sin elevación (flat design)
    }
  }

  /// Retorna el color de fondo según la variante
  /// Usa colores del tema para mantener consistencia visual
  Color? _getBackgroundColor(ColorScheme colorScheme) {
    if (backgroundColor != null) return backgroundColor;

    switch (variant) {
      case CustomAppBarVariant.reading:
        // ✅ CORRECTO: Usar withValues(alpha:) - Flutter 3.27+
        // Acepta valores flotantes de 0.0 (transparente) a 1.0 (opaco)
        return colorScheme.surface.withValues(alpha: _backgroundOpacity);
      case CustomAppBarVariant.minimal:
        return Colors.transparent; // Transparente para diseño minimalista
      default:
        return colorScheme.surface; // Color de superficie del tema
    }
  }

  /// Retorna el color del texto e iconos
  /// Usa el color onSurface del tema para contraste adecuado
  Color? _getForegroundColor(ColorScheme colorScheme) {
    if (foregroundColor != null) return foregroundColor;
    return colorScheme.onSurface; // Color contrastante con surface
  }

  /// Define el estilo de la barra de estado del sistema (status bar)
  /// Ajusta los iconos según el brillo del tema para máxima visibilidad
  SystemUiOverlayStyle _getSystemUiOverlayStyle(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    // Iconos oscuros en tema claro, iconos claros en tema oscuro
    return brightness == Brightness.light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;
  }

  /// Define el estilo del texto del título según la variante
  /// Usa Google Fonts para una tipografía elegante
  TextStyle _getTitleTextStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (variant) {
      case CustomAppBarVariant.reading:
        // Fuente serif para lectura (más elegante y legible en textos largos)
        return GoogleFonts.merriweather(
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
          // ✅ CORRECTO: withValues(alpha:) con valor flotante 0.0-1.0
          color: colorScheme.onSurface.withValues(alpha: _readingOpacity),
        );
      default:
        // Fuente estándar con mayor peso para títulos
        return GoogleFonts.merriweather(fontSize: 20.0, fontWeight: FontWeight.w700, color: colorScheme.onSurface);
    }
  }

  /// Construye el indicador de progreso lineal debajo del AppBar
  /// Útil para mostrar carga de contenido o progreso de lectura
  PreferredSizeWidget? _buildProgressIndicator(BuildContext context) {
    if (!showProgress) return null;

    return PreferredSize(
      preferredSize: const Size.fromHeight(_progressIndicatorHeight),
      child: LinearProgressIndicator(
        value: progressValue, // null = indeterminado, 0.0-1.0 = determinado
        // ✅ CORRECTO: withValues(alpha:) con valor flotante
        backgroundColor: Theme.of(context).colorScheme.outline.withValues(alpha: _outlineOpacity),
        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
      ),
    );
  }

  /// Muestra bottom sheet con opciones de lectura
  /// Presenta controles para personalizar la experiencia de lectura
  void _showReadingOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Transparente para bordes redondeados
      // Guardamos el contexto en una variable para evitar problemas
      builder: (BuildContext sheetContext) {
        final theme = Theme.of(context);

        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(_bottomSheetBorderRadius)),
          ),
          padding: const EdgeInsets.all(_bottomSheetPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Altura mínima necesaria
            children: [
              // Handle visual para indicar que se puede arrastrar
              Container(
                width: _handleWidth,
                height: _handleHeight,
                decoration: BoxDecoration(color: theme.colorScheme.outline, borderRadius: BorderRadius.circular(_handleHeight / 2)),
              ),
              const SizedBox(height: _bottomSheetPadding),

              // ListTiles con keys y callbacks funcionales
              ListTile(
                key: const ValueKey('text_size_option'),
                leading: const Icon(Icons.text_fields_rounded),
                title: const Text('Tamaño de texto'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  // Ejecutar callback si existe
                  if (onTextSizePressed != null) {
                    onTextSizePressed!();
                  }
                },
              ),
              ListTile(
                key: const ValueKey('brightness_option'),
                leading: const Icon(Icons.brightness_6_rounded),
                title: const Text('Brillo'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  if (onBrightnessPressed != null) {
                    onBrightnessPressed!();
                  }
                },
              ),
              ListTile(
                key: const ValueKey('theme_option'),
                leading: const Icon(Icons.palette_rounded),
                title: const Text('Tema de lectura'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  if (onThemePressed != null) {
                    onThemePressed!();
                  }
                },
              ),
              const SizedBox(height: _bottomSheetPadding),
            ],
          ),
        );
      },
    );
  }

  /// Define el tamaño preferido del AppBar
  /// Calcula la altura total incluyendo barra de progreso si está visible
  @override
  Size get preferredSize {
    double height = kToolbarHeight; // Altura estándar del AppBar (56.0)
    if (showProgress) {
      height += _progressIndicatorHeight; // Agregar altura del indicador
    }
    return Size.fromHeight(height);
  }
}
