import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class AdvancedFilterSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;
  const AdvancedFilterSheet({super.key, required this.currentFilters, required this.onFiltersApplied});
  @override
  State<AdvancedFilterSheet> createState() => _AdvancedFilterSheetState();
}

class _AdvancedFilterSheetState extends State<AdvancedFilterSheet> {
  late Map<String, dynamic> _filters;
  final List<String> _genres = ['Romance', 'Fantasía', 'Acción', 'Drama', 'Comedia', 'Misterio', 'Ciencia Ficción', 'Horror', 'Aventura', 'Histórico', 'Slice of Life'];
  final List<String> _statuses = ['En curso', 'Completado', 'Pausado', 'Cancelado'];
  final List<String> _languages = ['Español', 'Inglés', 'Japonés', 'Chino', 'Coreano'];
  final List<String> _updateFrequencies = ['Diario', 'Semanal', 'Mensual', 'Irregular'];
  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(color: colorScheme.outline, borderRadius: BorderRadius.circular(2)),
          ),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filtros avanzados', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filters.clear();
                    });
                    HapticFeedback.lightImpact();
                  },
                  child: Text('Limpiar', style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.primary)),
                ),
              ],
            ),
          ),
          // Filters content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  _buildFilterSection('Género', 'genres', _genres, theme, colorScheme, isMultiSelect: true),
                  _buildFilterSection('Estado', 'status', _statuses, theme, colorScheme),
                  _buildRatingFilter(theme, colorScheme),
                  _buildFilterSection('Idioma', 'language', _languages, theme, colorScheme),
                  _buildFilterSection('Frecuencia de actualización', 'updateFrequency', _updateFrequencies, theme, colorScheme),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),

          // Apply button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            child: ElevatedButton(
              onPressed: () {
                widget.onFiltersApplied(_filters);
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Aplicar filtros',
                style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, String key, List<String> options, ThemeData theme, ColorScheme colorScheme, {bool isMultiSelect = false}) {
    return ExpansionTile(
      title: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: options.map((option) {
              final isSelected = isMultiSelect ? (_filters[key] as List<String>?)?.contains(option) ?? false : _filters[key] == option;
              return FilterChip(
                label: Text(option, style: theme.textTheme.labelMedium?.copyWith(color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (isMultiSelect) {
                      _filters[key] ??= <String>[];
                      final list = _filters[key] as List<String>;
                      if (selected) {
                        list.add(option);
                      } else {
                        list.remove(option);
                      }
                      if (list.isEmpty) {
                        _filters.remove(key);
                      }
                    } else {
                      if (selected) {
                        _filters[key] = option;
                      } else {
                        _filters.remove(key);
                      }
                    }
                  });
                  HapticFeedback.lightImpact();
                },
                backgroundColor: colorScheme.surface,
                selectedColor: colorScheme.primary,
                checkmarkColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: isSelected ? colorScheme.primary : colorScheme.outline),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingFilter(ThemeData theme, ColorScheme colorScheme) {
    return ExpansionTile(
      title: Text('Calificación mínima', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1.0', style: theme.textTheme.bodyMedium),
                  Text(
                    '${(_filters['minRating'] ?? 1.0).toStringAsFixed(1)} estrellas',
                    style: theme.textTheme.titleSmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600),
                  ),
                  Text('5.0', style: theme.textTheme.bodyMedium),
                ],
              ),
              Slider(
                value: (_filters['minRating'] ?? 1.0).toDouble(),
                min: 1.0,
                max: 5.0,
                divisions: 8,
                onChanged: (value) {
                  setState(() {
                    _filters['minRating'] = value;
                  });
                },
                activeColor: colorScheme.primary,
                inactiveColor: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
