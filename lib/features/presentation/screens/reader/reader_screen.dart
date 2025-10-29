import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:screen_brightness/screen_brightness.dart';
//
import 'package:novel_we_li/core/themes/app_theme.dart';
import './widgets/auto_scroll_widget.dart';
import './widgets/reading_controls_widget.dart';
import './widgets/reading_settings_widget.dart';
import './widgets/text_selection_menu_widget.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> with TickerProviderStateMixin {
  // Controllers
  late ScrollController _scrollController;
  late AnimationController _controlsAnimationController;
  late AnimationController _pageTransitionController;
  late Animation<Offset> _slideAnimation;
  // Reading state
  bool _showControls = false;
  bool _isBookmarked = false;
  bool _isDarkMode = false;
  bool _isAutoScrolling = false;
  bool _showTextSelection = false;
  bool _showAutoScrollWidget = false;
  double _readingProgress = 0.0;
  double _fontSize = 16.0;
  String _fontFamily = 'Inter';
  Color _backgroundColor = Colors.white;
  double _lineSpacing = 1.5;
  double _autoScrollSpeed = 1.0;
  String _selectedText = '';
  Offset _selectionPosition = Offset.zero;
  // Mock novel data
  final Map<String, dynamic> _novelData = {
    "id": 1,
    "title": "El Despertar del Dragón Celestial",
    "author": "María Elena Vásquez",
    "currentChapter": 15,
    "totalChapters": 120,
    "chapterTitle": "Capítulo 15: El Encuentro con el Maestro",
    "content":
        """En las profundidades de la montaña sagrada, donde los vientos susurran secretos ancestrales y las nubes danzan entre los picos nevados, se alzaba el templo del Dragón Celestial. Sus muros de jade brillaban con una luz etérea que parecía emanar del mismo corazón de la tierra.Lin Wei avanzó por el sendero serpenteante, cada paso resonando en el silencio místico que envolvía el lugar. Sus ropas ondeaban suavemente con la brisa montañosa, y en sus ojos se reflejaba una determinación inquebrantable. Había viajado durante meses para llegar hasta aquí, siguiendo las pistas dejadas por su maestro antes de desaparecer.El templo se alzaba majestuoso ante él, sus torres puntiagudas perdiéndose entre las nubes. Dragones de piedra custodiaban la entrada, sus ojos de rubí parecían seguir cada movimiento del joven cultivador. Lin Wei sintió un escalofrío recorrer su espina dorsal, no de miedo, sino de reverencia ante la antigua sabiduría que emanaba del lugar."Has llegado lejos, joven Lin Wei," resonó una voz profunda desde las sombras del templo. Una figura emergió lentamente, envuelta en túnicas doradas que brillaban como el sol del amanecer. Era un anciano de barba blanca como la nieve, pero sus ojos conservaban la vivacidad de la juventud eterna."Maestro Tianlong," murmuró Lin Wei, inclinándose respetuosamente. "He venido buscando respuestas sobre el paradero de mi maestro, y sobre el poder que despierta en mi interior."El anciano sonrió, y en esa sonrisa había siglos de sabiduría acumulada. "Las respuestas que buscas no se encuentran en palabras, sino en la comprensión que nace del corazón. Ven, sígueme al Salón de los Espejos Celestiales."Mientras caminaban por los pasillos del templo, Lin Wei observó las pinturas murales que narraban la historia de los dragones celestiales. Cada imagen parecía cobrar vida bajo la luz dorada que emanaba de cristales incrustados en el techo. Los dragones pintados se movían con gracia etérea, sus escamas brillando como estrellas en la noche."Tu maestro estuvo aquí hace tres lunas," dijo Tianlong sin voltear a mirarlo. "Buscaba el mismo conocimiento que tú buscas ahora. Pero el camino del dragón celestial no es para todos. Requiere sacrificio, comprensión y, sobre todo, la capacidad de enfrentar la oscuridad que habita en el propio corazón."Lin Wei sintió que su pulso se aceleraba. "¿Dónde está ahora? ¿Qué le sucedió?""Eso," respondió el maestro, deteniéndose ante una puerta ornamentada con símbolos antiguos, "es algo que deberás descubrir por ti mismo. Pero antes, debes demostrar que eres digno de tal conocimiento."La puerta se abrió con un suave susurro, revelando una cámara circular donde la luz parecía danzar en patrones hipnóticos. En el centro se alzaba un altar de cristal, y sobre él, una esfera de energía pura que pulsaba con el ritmo de un corazón gigantesco."Esta es la Esfera del Despertar," explicó Tianlong. "Contiene la esencia de mil dragones celestiales que ascendieron antes que nosotros. Si tu espíritu es puro y tu determinación inquebrantable, te mostrará el camino. Pero si hay oscuridad en tu corazón, puede consumirte."Lin Wei se acercó lentamente al altar, sintiendo cómo la energía de la esfera resonaba con algo profundo en su interior. Sus manos temblaron ligeramente mientras las extendía hacia la luz pulsante."Recuerda," murmuró Tianlong, "el verdadero poder no viene de dominar a otros, sino de dominarse a uno mismo. El dragón celestial no es una bestia de destrucción, sino un guardián de la armonía universal."Cuando los dedos de Lin Wei tocaron la superficie de la esfera, el mundo a su alrededor se transformó. Visiones de dragones ancestrales llenaron su mente, mostrándole secretos que habían permanecido ocultos durante milenios. Vio a su maestro, no como el hombre que conocía, sino como un ser de luz pura que había trascendido los límites mortales.Y en ese momento de revelación, Lin Wei comprendió que su verdadero viaje apenas comenzaba.""",
    "readingPosition": 0.3,
    "bookmarks": [
      {"position": 0.15, "note": "Descripción hermosa del templo"},
      {"position": 0.45, "note": "Aparición del Maestro Tianlong"},
    ],
    "highlights": [
      {"start": 150, "end": 200, "color": "yellow"},
      {"start": 800, "end": 850, "color": "blue"},
    ],
  };
  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeReading();
    _setSystemUIOverlay();
  }

  void _initializeControllers() {
    _scrollController = ScrollController();
    _controlsAnimationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _pageTransitionController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _slideAnimation = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(CurvedAnimation(parent: _pageTransitionController, curve: Curves.easeInOut));
    _scrollController.addListener(_onScroll);
    _pageTransitionController.forward();
  }

  void _initializeReading() {
    _readingProgress = (_novelData["readingPosition"] as double);
    _isBookmarked = (_novelData["bookmarks"] as List).isNotEmpty;
    // Set initial scroll position based on reading progress
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        _scrollController.jumpTo(maxScroll * _readingProgress);
      }
    });
  }

  void _setSystemUIOverlay() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final progress = _scrollController.offset / _scrollController.position.maxScrollExtent;
      setState(() {
        _readingProgress = progress.clamp(0.0, 1.0);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controlsAnimationController.dispose();
    _pageTransitionController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SlideTransition(
        position: _slideAnimation,
        child: Stack(
          children: [_buildReadingContent(), if (_showControls) _buildReadingControls(), if (_showTextSelection) _buildTextSelectionMenu(), if (_showAutoScrollWidget) _buildAutoScrollWidget()],
        ),
      ),
    );
  }

  Widget _buildReadingContent() {
    return GestureDetector(
      onTap: _toggleControls,
      onDoubleTap: _toggleTheme,
      onLongPressStart: _onLongPressStart,
      onLongPressEnd: _onLongPressEnd,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: _backgroundColor,
        child: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: SelectableText(
              _novelData["content"] as String,
              style: TextStyle(fontSize: _fontSize, fontFamily: _fontFamily, height: _lineSpacing, color: _isDarkMode ? Colors.white : Colors.black87),
              onSelectionChanged: _onTextSelectionChanged,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadingControls() {
    return ReadingControlsWidget(
      chapterTitle: _novelData["chapterTitle"] as String,
      readingProgress: _readingProgress,
      isBookmarked: _isBookmarked,
      showControls: _showControls,
      onClosePressed: _closeReader,
      onPreviousChapter: _previousChapter,
      onNextChapter: _nextChapter,
      onBookmarkToggle: _toggleBookmark,
      onSettingsPressed: _showReadingSettings,
    );
  }

  Widget _buildTextSelectionMenu() {
    return TextSelectionMenuWidget(
      selectedText: _selectedText,
      position: _selectionPosition,
      onCopy: _hideTextSelection,
      onHighlight: _highlightText,
      onNote: _addNote,
      onDictionary: _searchText,
      onClose: _hideTextSelection,
    );
  }

  Widget _buildAutoScrollWidget() {
    return Positioned(
      bottom: 20.h,
      right: 4.w,
      child: AutoScrollWidget(
        scrollController: _scrollController,
        isAutoScrolling: _isAutoScrolling,
        scrollSpeed: _autoScrollSpeed,
        onAutoScrollToggle: _toggleAutoScroll,
        onSpeedChanged: _changeAutoScrollSpeed,
      ),
    );
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _controlsAnimationController.forward();
      // Auto-hide controls after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _showControls) {
          setState(() {
            _showControls = false;
          });
          _controlsAnimationController.reverse();
        }
      });
    } else {
      _controlsAnimationController.reverse();
    }
  }

  void _toggleTheme() {
    HapticFeedback.lightImpact();
    setState(() {
      _isDarkMode = !_isDarkMode;
      _backgroundColor = _isDarkMode ? Colors.black : Colors.white;
    });
    // Adjust screen brightness for night mode
    if (_isDarkMode) {
      ScreenBrightness().setScreenBrightness(0.3);
    } else {
      ScreenBrightness().resetScreenBrightness();
    }
  }

  void _onLongPressStart(LongPressStartDetails details) {
    HapticFeedback.mediumImpact();
    setState(() {
      _showAutoScrollWidget = true;
    });
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    // Keep auto scroll widget visible
  }
  void _onTextSelectionChanged(TextSelection selection, SelectionChangedCause? cause) {
    if (selection.isValid && !selection.isCollapsed) {
      final text = (_novelData["content"] as String).substring(selection.start, selection.end);
      setState(() {
        _selectedText = text;
        _showTextSelection = true;
        _selectionPosition = Offset(50.w, 30.h); // Center position
      });
    } else {
      _hideTextSelection();
    }
  }

  void _hideTextSelection() {
    setState(() {
      _showTextSelection = false;
      _selectedText = '';
    });
  }

  void _highlightText() {
    HapticFeedback.lightImpact();
    // Add highlight logic here
    _hideTextSelection();
  }

  void _addNote() {
    HapticFeedback.lightImpact();
    // Show note dialog
    _showNoteDialog();
    _hideTextSelection();
  }

  void _searchText() {
    HapticFeedback.lightImpact();
    // Open dictionary or search
    _hideTextSelection();
  }

  void _closeReader() {
    HapticFeedback.lightImpact();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Navigator.pop(context);
  }

  void _previousChapter() {
    HapticFeedback.lightImpact();
    if ((_novelData["currentChapter"] as int) > 1) {
      // Navigate to previous chapter
      _animatePageTransition(isNext: false);
    }
  }

  void _nextChapter() {
    HapticFeedback.lightImpact();
    if ((_novelData["currentChapter"] as int) < (_novelData["totalChapters"] as int)) {
      // Navigate to next chapter
      _animatePageTransition(isNext: true);
    }
  }

  void _animatePageTransition({required bool isNext}) {
    _pageTransitionController.reset();
    _slideAnimation = Tween<Offset>(begin: Offset(isNext ? 1.0 : -1.0, 0.0), end: Offset.zero).animate(CurvedAnimation(parent: _pageTransitionController, curve: Curves.easeInOut));
    _pageTransitionController.forward();
  }

  void _toggleBookmark() {
    HapticFeedback.lightImpact();
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  void _showReadingSettings() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ReadingSettingsWidget(
        fontSize: _fontSize,
        fontFamily: _fontFamily,
        backgroundColor: _backgroundColor,
        lineSpacing: _lineSpacing,
        onFontSizeChanged: (size) {
          setState(() {
            _fontSize = size;
          });
        },
        onFontFamilyChanged: (family) {
          setState(() {
            _fontFamily = family;
          });
        },
        onBackgroundColorChanged: (color) {
          setState(() {
            _backgroundColor = color;
            _isDarkMode = color == Colors.black || color == const Color(0xFF2C2C2C);
          });
        },
        onLineSpacingChanged: (spacing) {
          setState(() {
            _lineSpacing = spacing;
          });
        },
        onClose: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _toggleAutoScroll(bool enabled) {
    setState(() {
      _isAutoScrolling = enabled;
    });
    if (enabled) {
      _startAutoScroll();
    } else {
      _stopAutoScroll();
    }
  }

  void _startAutoScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      final remainingScroll = maxScroll - currentScroll;
      if (remainingScroll > 0) {
        final duration = Duration(milliseconds: (remainingScroll / _autoScrollSpeed * 10).round());
        _scrollController.animateTo(maxScroll, duration: duration, curve: Curves.linear);
      }
    }
  }

  void _stopAutoScroll() {
    _scrollController.animateTo(_scrollController.offset, duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
  }

  void _changeAutoScrollSpeed(double speed) {
    setState(() {
      _autoScrollSpeed = speed;
    });
    if (_isAutoScrolling) {
      _stopAutoScroll();
      Future.delayed(const Duration(milliseconds: 100), () {
        _startAutoScroll();
      });
    }
  }

  void _showNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Añadir Nota', style: AppTheme.lightTheme.textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Texto seleccionado:', style: AppTheme.lightTheme.textTheme.bodySmall),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(_selectedText.length > 100 ? '${_selectedText.substring(0, 100)}...' : _selectedText, style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: const InputDecoration(hintText: 'Escribe tu nota aquí...', border: OutlineInputBorder()),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              // Save note logic
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
