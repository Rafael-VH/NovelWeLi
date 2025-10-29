import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Enum que define las variantes visuales de la barra de navegación
enum CustomBottomBarVariant {
  reading, // Barra para lectura con controles de navegación
  floating, // Barra flotante con pill design (moderna)
  standard, // Barra estándar tradicional
}

/// Clase pública que representa un item de navegación
/// Ahora es configurable desde fuera del widget
class BottomBarItem {
  final IconData icon; // Icono en estado normal
  final IconData activeIcon; // Icono en estado activo/seleccionado
  final String label; // Etiqueta de texto
  final String? route; // Ruta de navegación asociada (opcional)

  const BottomBarItem({required this.icon, required this.activeIcon, required this.label, this.route});
}

/// CustomBottomBar: Barra de navegación inferior personalizable
///
/// Soporta tres variantes visuales, animaciones y configuración flexible
/// Los items ahora son completamente configurables desde el constructor
class CustomBottomBar extends StatefulWidget {
  // Constantes para valores numéricos reutilizables
  static const double _standardElevation = 8.0;
  static const double _floatingElevation = 20.0;
  static const double _standardHeight = 60.0;
  static const double _floatingHeight = 70.0;
  static const double _floatingMargin = 16.0;
  static const double _floatingBorderRadius = 25.0;
  static const double _itemBorderRadius = 20.0;
  static const double _iconSize = 24.0;
  static const double _animationOffset = 80.0;
  static const double _shadowOpacity = 0.1;
  static const double _floatingShadowOpacity = 0.15;
  static const double _surfaceOpacity = 0.95;
  static const double _borderOpacity = 0.2;
  static const double _inactiveIconOpacity = 0.6;
  static const double _sliderInactiveOpacity = 0.3;

  final int currentIndex; // Índice del item actualmente seleccionado
  final ValueChanged<int>? onTap; // Callback cuando se toca un item
  final List<BottomBarItem> items; // Items configurables
  final CustomBottomBarVariant variant; // Variante visual de la barra
  final bool showLabels; // Mostrar etiquetas de texto
  final double? elevation; // Elevación de la barra
  final Color? backgroundColor; // Color de fondo personalizado
  final Color? selectedItemColor; // Color del item seleccionado
  final Color? unselectedItemColor; // Color de items no seleccionados

  // Parámetros para variante reading
  final double? readingProgress; // Progreso de lectura (0.0-1.0)
  final ValueChanged<double>? onProgressChanged; // Callback para cambio de progreso
  final VoidCallback? onPreviousChapter; // Callback para capítulo anterior
  final VoidCallback? onNextChapter; // Callback para siguiente capítulo

  // Control de visibilidad
  final bool isVisible; // Controlar visibilidad de la barra

  CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.items,
    this.onTap,
    this.variant = CustomBottomBarVariant.standard,
    this.showLabels = true,
    this.elevation,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    // Parámetros de lectura
    this.readingProgress,
    this.onProgressChanged,
    this.onPreviousChapter,
    this.onNextChapter,
    // Control de visibilidad
    this.isVisible = true,
  }) : assert(items.isEmpty || (currentIndex >= 0 && currentIndex < items.length), 'currentIndex debe estar entre 0 y ${items.length - 1}');

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> with SingleTickerProviderStateMixin {
  // Controlador de animación para mostrar/ocultar la barra
  late AnimationController _animationController;
  // Animación con curva para suavizar el movimiento
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Inicializar controlador de animación
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    // Crear animación con curva easeInOut
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    // Solo iniciar animación si debe ser visible
    if (widget.isVisible) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CustomBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Animar cuando cambia la visibilidad
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    // Liberar recursos del controlador de animación
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Switch expression - más conciso y moderno
    return switch (widget.variant) {
      CustomBottomBarVariant.reading => _buildReadingBottomBar(context),
      CustomBottomBarVariant.floating => _buildFloatingBottomBar(context),
      CustomBottomBarVariant.standard => _buildStandardBottomBar(context),
    };
  }

  /// Construye la barra de navegación estándar
  /// Usa un Container personalizado con los items configurados
  Widget _buildStandardBottomBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: CustomBottomBar._shadowOpacity),
            blurRadius: widget.elevation ?? CustomBottomBar._standardElevation,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: CustomBottomBar._standardHeight,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widget.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == widget.currentIndex;

              return Expanded(
                child: InkWell(
                  onTap: () => _handleItemTap(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected ? item.activeIcon : item.icon,
                        size: CustomBottomBar._iconSize,
                        color: isSelected
                            ? (widget.selectedItemColor ?? colorScheme.primary)
                            : (widget.unselectedItemColor ?? colorScheme.onSurface.withValues(alpha: CustomBottomBar._inactiveIconOpacity)),
                      ),
                      if (widget.showLabels) ...[
                        const SizedBox(height: 4.0),
                        Text(
                          item.label,
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? (widget.selectedItemColor ?? colorScheme.primary)
                                : (widget.unselectedItemColor ?? colorScheme.onSurface.withValues(alpha: CustomBottomBar._inactiveIconOpacity)),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Construye la barra de lectura con controles de navegación
  /// Incluye botones para capítulo anterior/siguiente y slider de progreso
  Widget _buildReadingBottomBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          // Animación de deslizamiento vertical (ocultar/mostrar)
          offset: Offset(0, CustomBottomBar._animationOffset * (1 - _animation.value)),
          child: Container(
            decoration: BoxDecoration(
              // Fondo semi-transparente para efecto glassmorphism
              color: (widget.backgroundColor ?? colorScheme.surface).withValues(alpha: CustomBottomBar._surfaceOpacity),
              border: Border(
                top: BorderSide(color: colorScheme.onSurface.withValues(alpha: CustomBottomBar._borderOpacity), width: 1.0),
              ),
            ),
            child: SafeArea(
              child: Container(
                height: CustomBottomBar._standardHeight,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón para capítulo anterior
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: widget.onPreviousChapter != null
                          ? () {
                              HapticFeedback.lightImpact();
                              widget.onPreviousChapter!();
                            }
                          : null,
                      tooltip: 'Capítulo anterior',
                      color: widget.selectedItemColor ?? colorScheme.primary,
                    ),
                    // Slider para mostrar y cambiar el progreso de lectura
                    Expanded(
                      child: Slider(
                        value: (widget.readingProgress ?? 0.0).clamp(0.0, 1.0),
                        onChanged: widget.onProgressChanged,
                        activeColor: widget.selectedItemColor ?? colorScheme.primary,
                        inactiveColor: colorScheme.outline.withValues(alpha: CustomBottomBar._sliderInactiveOpacity),
                      ),
                    ),
                    // Botón para próximo capítulo
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_rounded),
                      onPressed: widget.onNextChapter != null
                          ? () {
                              HapticFeedback.lightImpact();
                              widget.onNextChapter!();
                            }
                          : null,
                      tooltip: 'Próximo capítulo',
                      color: widget.selectedItemColor ?? colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Construye la barra flotante moderna con diseño tipo "pill"
  /// Items se expanden al seleccionarse mostrando etiqueta
  Widget _buildFloatingBottomBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, CustomBottomBar._animationOffset * (1 - _animation.value)),
          child: Container(
            margin: const EdgeInsets.all(CustomBottomBar._floatingMargin),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(CustomBottomBar._floatingBorderRadius),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? colorScheme.surface,
                  borderRadius: BorderRadius.circular(CustomBottomBar._floatingBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: CustomBottomBar._floatingShadowOpacity),
                      blurRadius: CustomBottomBar._floatingElevation,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Container(
                    height: CustomBottomBar._floatingHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: widget.items.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        final isSelected = index == widget.currentIndex;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () => _handleItemTap(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: isSelected ? (widget.selectedItemColor ?? colorScheme.primary) : Colors.transparent,
                                borderRadius: BorderRadius.circular(CustomBottomBar._itemBorderRadius),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icono - cambia entre normal y activo
                                  Icon(
                                    isSelected ? item.activeIcon : item.icon,
                                    size: CustomBottomBar._iconSize,
                                    color: isSelected ? colorScheme.onPrimary : (widget.unselectedItemColor ?? colorScheme.onSurface.withValues(alpha: CustomBottomBar._inactiveIconOpacity)),
                                  ),
                                  // Etiqueta - solo visible cuando está seleccionado
                                  if (isSelected && widget.showLabels) ...[
                                    const SizedBox(width: 8.0),
                                    Flexible(
                                      child: Text(
                                        item.label,
                                        style: GoogleFonts.inter(fontSize: 14.0, fontWeight: FontWeight.w600, color: colorScheme.onPrimary),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Maneja el tap en cualquier item de navegación
  /// Ejecuta callback y navega solo si hay ruta configurada
  void _handleItemTap(int index) {
    // No hacer nada si ya está seleccionado
    if (index == widget.currentIndex) return;

    // Feedback háptico para mejor UX
    HapticFeedback.lightImpact();

    // Ejecutar callback si existe (el padre maneja el cambio de estado)
    if (widget.onTap != null) {
      widget.onTap!(index);
    }

    // Navegar solo si hay ruta y NO hay callback onTap
    // (si hay callback, el padre debe manejar la navegación)
    if (widget.onTap == null && widget.items[index].route != null) {
      Navigator.pushReplacementNamed(context, widget.items[index].route!);
    }
  }
}
