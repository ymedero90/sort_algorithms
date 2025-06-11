import 'dart:math';

import 'package:flutter/material.dart';

import 'models/sort_step.dart';
import 'models/sorting_algorithm.dart';
import 'services/sorting_service.dart';
import 'widgets/array_visualizer.dart';
import 'widgets/pseudocode_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sorting Algorithms Visualizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E), // VSCode background
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF007ACC), // VSCode blue
          secondary: Color(0xFF4FC3F7),
          surface: Color(0xFF252526),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Color(0xFFCCCCCC),
        ),
        useMaterial3: true,
        fontFamily: 'Segoe UI',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFFCCCCCC)),
          bodyLarge: TextStyle(color: Color(0xFFCCCCCC)),
          titleMedium: TextStyle(color: Color(0xFFCCCCCC), fontWeight: FontWeight.w500),
          headlineSmall: TextStyle(color: Color(0xFFCCCCCC), fontWeight: FontWeight.w600),
        ),
        cardTheme: const CardTheme(color: Color(0xFF252526), elevation: 0, margin: EdgeInsets.zero),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF3C3C3C),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF007ACC), width: 1)),
        ),
      ),
      home: const SortingVisualizerPage(),
    );
  }
}

class SortingVisualizerPage extends StatefulWidget {
  const SortingVisualizerPage({super.key});

  @override
  State<SortingVisualizerPage> createState() => _SortingVisualizerPageState();
}

class _SortingVisualizerPageState extends State<SortingVisualizerPage> with TickerProviderStateMixin {
  List<int> _array = [];
  List<SortStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  bool _isPaused = false; // Nuevo estado para pausar/reanudar
  SortingAlgorithm? _selectedAlgorithm;
  double _animationSpeed = 1.0;
  int _arraySize = 8;
  late AnimationController _pulseController;
  final TextEditingController _arraySizeController = TextEditingController();
  int _activeTabIndex = 0;

  bool _isVisualizationCollapsed = false;
  bool _isPseudocodeCollapsed = false;
  bool _isSidebarCollapsed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _arraySizeController.text = _arraySize.toString();
    _generateRandomArray();
    _selectedAlgorithm = SortingService.algorithms.first;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _arraySizeController.dispose();
    super.dispose();
  }

  void _generateRandomArray() {
    // Validar que _arraySize sea válido antes de generar
    if (_arraySize < 3 || _arraySize == 0) {
      _arraySize = 8; // Valor por defecto seguro
      _arraySizeController.text = '8';
    }

    final random = Random();
    setState(() {
      _array = List.generate(_arraySize, (_) => random.nextInt(50) + 5);
      _steps = [SortStep(array: List.from(_array), description: '🎯 Initial array generated')];
      _currentStepIndex = 0;
      _isPlaying = false;
      _isPaused = false; // Reset pause state
    });
  }

  void _resetVisualization() {
    setState(() {
      _currentStepIndex = 0;
      _isPlaying = false;
      _isPaused = false; // Reset pause state
    });
    _stopAnimation();
  }

  void _startOrPauseAnimation() async {
    // Validar que el campo de array size no esté vacío
    if (_arraySizeController.text.trim().isEmpty) {
      _arraySizeController.text = '8';
      setState(() {
        _arraySize = 8;
      });
      _generateRandomArray();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Array size was empty, set to default value of 8'),
          backgroundColor: Color(0xFFDCDCAA),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Validar el valor actual del campo antes de proceder
    final currentSize = int.tryParse(_arraySizeController.text.trim());
    if (currentSize == null || currentSize < 3 || currentSize == 0) {
      _arraySizeController.text = '8';
      setState(() {
        _arraySize = 8;
      });
      _generateRandomArray();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid array size detected, set to default value of 8'),
          backgroundColor: Color(0xFFDCDCAA),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Validar que el array tenga elementos válidos
    if (_array.isEmpty || _arraySize < 3 || _arraySize == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid array size (minimum 3 elements)'),
          backgroundColor: Color(0xFFF44747),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (_isPlaying) {
      // Si está ejecutándose, pausar
      _pauseAnimation();
      return;
    }

    if (_isPaused) {
      // Si está pausado, reanudar
      _resumeAnimation();
      return;
    }

    // Si no ha comenzado, comenzar desde el principio (reiniciar todo)
    _startFromBeginning();
  }

  void _startFromBeginning() async {
    // Reiniciar completamente: historial, pseudocódigo, todo
    setState(() {
      _currentStepIndex = 0;
      _isPlaying = false;
      _isPaused = false;
      // Forzar reinicio del historial estableciendo el paso inicial
      _steps = [SortStep(array: List.from(_array), description: '🎯 Initial array generated')];
    });

    // Pequeña pausa para que el widget se actualice
    await Future.delayed(const Duration(milliseconds: 50));

    // Regenerar los pasos del algoritmo
    if (_selectedAlgorithm != null) {
      _steps = SortingService.executeAlgorithm(_selectedAlgorithm!, _array);
    }

    // Comenzar la animación desde el paso 0
    setState(() {
      _isPlaying = true;
      _isPaused = false;
    });

    _pulseController.repeat();

    for (int i = 0; i < _steps.length && _isPlaying; i++) {
      setState(() {
        _currentStepIndex = i;
      });
      await Future.delayed(Duration(milliseconds: (1000 / _animationSpeed).round()));
    }

    _pulseController.stop();

    // Solo cambiar el estado si realmente terminó la animación (no fue pausada)
    if (_isPlaying) {
      setState(() {
        _isPlaying = false;
        _isPaused = false;
      });
    }
  }

  void _startAnimation() async {
    // Execute sort if not done yet
    if (_selectedAlgorithm != null && _steps.length == 1) {
      _steps = SortingService.executeAlgorithm(_selectedAlgorithm!, _array);
    }

    setState(() {
      _isPlaying = true;
      _isPaused = false;
    });

    _pulseController.repeat();

    for (int i = _currentStepIndex; i < _steps.length && _isPlaying; i++) {
      setState(() {
        _currentStepIndex = i;
      });
      await Future.delayed(Duration(milliseconds: (1000 / _animationSpeed).round()));
    }

    _pulseController.stop();

    // Solo cambiar el estado si realmente terminó la animación (no fue pausada)
    if (_isPlaying) {
      setState(() {
        _isPlaying = false;
        _isPaused = false;
      });
    }
  }

  void _pauseAnimation() {
    _pulseController.stop();
    setState(() {
      _isPlaying = false;
      _isPaused = true; // Mantener el estado de pausa
    });
  }

  void _resumeAnimation() async {
    setState(() {
      _isPlaying = true;
      _isPaused = false;
    });

    _pulseController.repeat();

    for (int i = _currentStepIndex; i < _steps.length && _isPlaying; i++) {
      setState(() {
        _currentStepIndex = i;
      });
      await Future.delayed(Duration(milliseconds: (1000 / _animationSpeed).round()));
    }

    _pulseController.stop();

    // Solo cambiar el estado si realmente terminó la animación (no fue pausada)
    if (_isPlaying) {
      setState(() {
        _isPlaying = false;
        _isPaused = false;
      });
    }
  }

  void _stopAnimation() {
    _pulseController.stop();
    setState(() {
      _isPlaying = false;
      _isPaused = false;
    });
  }

  void _nextStep() {
    if (_currentStepIndex < _steps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
    }
  }

  void _previousStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
      });
    }
  }

  String _getPlayButtonText() {
    if (_isPlaying) {
      return 'Pause';
    } else if (_isPaused) {
      return 'Resume';
    } else {
      return 'Start';
    }
  }

  IconData _getPlayButtonIcon() {
    if (_isPlaying) {
      return Icons.pause;
    } else if (_isPaused) {
      return Icons.play_arrow;
    } else {
      return Icons.play_arrow;
    }
  }

  Color _getPlayButtonColor() {
    if (_isPlaying) {
      return const Color(0xFFF44747); // Rojo para pausar
    } else if (_isPaused) {
      return const Color(0xFFDCDCAA); // Amarillo para reanudar
    } else {
      return const Color(0xFF4EC9B0); // Verde para comenzar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Column(
        children: [
          // Top bar similar to VSCode
          Container(
            height: 35,
            color: const Color(0xFF2D2D30),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Icon(Icons.sort, color: Color(0xFF007ACC), size: 16),
                const SizedBox(width: 8),
                const Text(
                  'Sorting Algorithms Visualizer',
                  style: TextStyle(color: Color(0xFFCCCCCC), fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const Spacer(),

                // Window controls placeholder
              ],
            ),
          ),

          // Main content area
          Expanded(
            child: Row(
              children: [
                // Left sidebar - Algorithm selection
                if (!_isSidebarCollapsed)
                  Container(
                    width: 300,
                    color: const Color(0xFF252526),
                    child: Column(
                      children: [
                        // Sidebar header
                        Container(
                          height: 35,
                          color: const Color(0xFF2D2D30),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Icon(Icons.settings, color: Color(0xFFCCCCCC), size: 16),
                              const SizedBox(width: 8),
                              const Text(
                                'CONFIGURATION',
                                style: TextStyle(
                                  color: Color(0xFFCCCCCC),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _isSidebarCollapsed = true;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(Icons.chevron_left, color: Color(0xFF858585), size: 16),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Sidebar content
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Algorithm selection
                                _buildSidebarSection(
                                  'Algorithm',
                                  DropdownButtonFormField<SortingAlgorithm>(
                                    value: _selectedAlgorithm,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                    dropdownColor: const Color(0xFF3C3C3C),
                                    style: const TextStyle(color: Color(0xFFCCCCCC)),
                                    items:
                                        SortingService.algorithms.map((algorithm) {
                                          return DropdownMenuItem(value: algorithm, child: Text(algorithm.name));
                                        }).toList(),
                                    onChanged: (algorithm) {
                                      setState(() {
                                        _selectedAlgorithm = algorithm;
                                        // Limpiar estado cuando se cambia algoritmo
                                        _currentStepIndex = 0;
                                        _isPlaying = false;
                                        _isPaused = false;
                                        _steps = [
                                          SortStep(array: List.from(_array), description: '🎯 Initial array generated'),
                                        ];
                                      });
                                    },
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Array size
                                _buildSidebarSection(
                                  'Array Size',
                                  TextFormField(
                                    controller: _arraySizeController,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: Color(0xFFCCCCCC)),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      hintText: 'e.g: 8 (max: 64)',
                                      hintStyle: TextStyle(color: Color(0xFF858585)),
                                    ),
                                    onChanged: (value) {
                                      // Si el campo está vacío, no procesar
                                      if (value.trim().isEmpty) {
                                        return;
                                      }

                                      final size = int.tryParse(value);
                                      if (size != null && size >= 3 && size <= 64) {
                                        setState(() {
                                          _arraySize = size;
                                        });
                                      } else if (size != null && size > 64) {
                                        // Si el usuario ingresa más de 64, automáticamente lo limitamos a 64
                                        _arraySizeController.text = '64';
                                        setState(() {
                                          _arraySize = 64;
                                        });
                                        // Mostrar mensaje de advertencia
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Maximum array size is 64 elements'),
                                            backgroundColor: Color(0xFFDCDCAA),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      } else if (size != null && (size < 3 || size == 0)) {
                                        // Si el usuario ingresa menos de 3 o 0, NO actualizar _arraySize
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Minimum array size is 3 elements'),
                                            backgroundColor: Color(0xFFF44747),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                    onEditingComplete: () {
                                      // Validar cuando termina de editar
                                      final value = _arraySizeController.text.trim();
                                      if (value.isEmpty) {
                                        _arraySizeController.text = '8';
                                        setState(() {
                                          _arraySize = 8;
                                        });
                                        _generateRandomArray();
                                      } else {
                                        final size = int.tryParse(value);
                                        if (size == null || size < 3 || size == 0) {
                                          _arraySizeController.text = '8';
                                          setState(() {
                                            _arraySize = 8;
                                          });
                                          _generateRandomArray();
                                        }
                                      }
                                    },
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Speed control
                                _buildSidebarSection(
                                  'Speed: ${_animationSpeed.toStringAsFixed(1)}x',
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: const Color(0xFF007ACC),
                                      thumbColor: const Color(0xFF007ACC),
                                      inactiveTrackColor: const Color(0xFF3C3C3C),
                                    ),
                                    child: Slider(
                                      value: _animationSpeed,
                                      min: 0.5,
                                      max: 3.0,
                                      divisions: 5,
                                      onChanged: (value) {
                                        setState(() {
                                          _animationSpeed = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Action buttons
                                _buildActionButton(
                                  'New Array',
                                  Icons.refresh,
                                  const Color(0xFF4EC9B0),
                                  _generateRandomArray,
                                ),
                                const SizedBox(height: 8),
                                _buildActionButton(
                                  _getPlayButtonText(),
                                  _getPlayButtonIcon(),
                                  _getPlayButtonColor(),
                                  _startOrPauseAnimation,
                                ),
                                const SizedBox(height: 8),
                                _buildActionButton('Reset', Icons.replay, const Color(0xFF569CD6), _resetVisualization),

                                const Spacer(),

                                // Algorithm info
                                if (_selectedAlgorithm != null) ...[_buildComplexityInfo()],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Collapsed sidebar button
                if (_isSidebarCollapsed)
                  Container(
                    width: 35,
                    color: const Color(0xFF252526),
                    child: Column(
                      children: [
                        // Header with expand button
                        Container(
                          height: 35,
                          color: const Color(0xFF2D2D30),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isSidebarCollapsed = false;
                              });
                            },
                            child: const Center(child: Icon(Icons.chevron_right, color: Color(0xFF858585), size: 16)),
                          ),
                        ),

                        // Vertical text
                        Expanded(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Center(
                              child: Text(
                                'CONFIG',
                                style: TextStyle(
                                  color: Color(0xFF858585),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Quick action buttons (collapsed)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          child: Column(
                            children: [
                              Tooltip(
                                message: 'New Array',
                                child: InkWell(
                                  onTap: _generateRandomArray,
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4EC9B0),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(Icons.refresh, color: Colors.black, size: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Tooltip(
                                message: _getPlayButtonText(),
                                child: InkWell(
                                  onTap: _startOrPauseAnimation,
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: _getPlayButtonColor(),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Icon(_getPlayButtonIcon(), color: Colors.black, size: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Tooltip(
                                message: 'Reset',
                                child: InkWell(
                                  onTap: _resetVisualization,
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF569CD6),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(Icons.replay, color: Colors.black, size: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Vertical divider
                Container(width: 1, color: const Color(0xFF3C3C3C)),

                // Main editor area
                Expanded(
                  child: Column(
                    children: [
                      // Tab bar
                      Container(
                        height: 35,
                        color: const Color(0xFF2D2D30),
                        child: Row(children: [_buildTab('Visualization', 0), _buildTab('Information', 1)]),
                      ),

                      // Content area
                      Expanded(
                        child: IndexedStack(
                          index: _activeTabIndex,
                          children: [
                            // Visualization tab
                            Row(
                              children: [
                                // Array visualization
                                if (!_isVisualizationCollapsed)
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      color: const Color(0xFF1E1E1E),
                                      child: Column(
                                        children: [
                                          // Header with collapse button
                                          Container(
                                            height: 35,
                                            color: const Color(0xFF252526),
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.bar_chart, color: Color(0xFF569CD6), size: 16),
                                                const SizedBox(width: 8),
                                                const Text(
                                                  'ARRAY VISUALIZATION',
                                                  style: TextStyle(
                                                    color: Color(0xFFCCCCCC),
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                                const Spacer(),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      _isVisualizationCollapsed = true;
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.chevron_left,
                                                    color: Color(0xFF858585),
                                                    size: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Legend
                                          Container(
                                            height: 40,
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            child: Row(
                                              children: [
                                                _buildLegendItem(const Color(0xFF569CD6), 'Normal'),
                                                const SizedBox(width: 20),
                                                _buildLegendItem(const Color(0xFFDCDCAA), 'Comparing'),
                                                const SizedBox(width: 20),
                                                _buildLegendItem(const Color(0xFFF44747), 'Swapping'),
                                                const SizedBox(width: 20),
                                                _buildLegendItem(const Color(0xFF4EC9B0), 'Sorted'),
                                              ],
                                            ),
                                          ),

                                          // Array visualization
                                          Expanded(
                                            child:
                                                _steps.isNotEmpty
                                                    ? ArrayVisualizer(
                                                      step: _steps[_currentStepIndex],
                                                      animationController: _pulseController,
                                                    )
                                                    : const Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            Icons.bar_chart_outlined,
                                                            size: 48,
                                                            color: Color(0xFF858585),
                                                          ),
                                                          SizedBox(height: 16),
                                                          Text(
                                                            'Generate an array to start',
                                                            style: TextStyle(color: Color(0xFF858585), fontSize: 16),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                // Collapsed visualization button
                                if (_isVisualizationCollapsed)
                                  Container(
                                    width: 35,
                                    color: const Color(0xFF252526),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _isVisualizationCollapsed = false;
                                            });
                                          },
                                          child: SizedBox(
                                            height: 35,
                                            child: const Center(
                                              child: Icon(Icons.chevron_right, color: Color(0xFF858585), size: 16),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: RotatedBox(
                                            quarterTurns: 3,
                                            child: Center(
                                              child: Text(
                                                'VISUALIZATION',
                                                style: TextStyle(
                                                  color: Color(0xFF858585),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                // Vertical divider
                                Container(width: 1, color: const Color(0xFF3C3C3C)),

                                // Pseudocode panel
                                if (!_isPseudocodeCollapsed)
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      color: const Color(0xFF1E1E1E),
                                      child: Column(
                                        children: [
                                          // Header with collapse button
                                          Container(
                                            height: 35,
                                            color: const Color(0xFF252526),
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.code, color: Color(0xFF569CD6), size: 16),
                                                const SizedBox(width: 8),
                                                const Text(
                                                  'PSEUDOCODE',
                                                  style: TextStyle(
                                                    color: Color(0xFFCCCCCC),
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                                const Spacer(),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      _isPseudocodeCollapsed = true;
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.chevron_right,
                                                    color: Color(0xFF858585),
                                                    size: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Pseudocode content
                                          Expanded(
                                            child:
                                                _selectedAlgorithm != null
                                                    ? PseudocodeViewer(
                                                      algorithm: _selectedAlgorithm!,
                                                      currentLine:
                                                          _steps.isNotEmpty
                                                              ? _steps[_currentStepIndex].currentPseudocodeLine
                                                              : null,
                                                      showHeader: false, // No mostrar header duplicado
                                                    )
                                                    : const Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(Icons.code, size: 48, color: Color(0xFF858585)),
                                                          SizedBox(height: 16),
                                                          Text(
                                                            'Select an algorithm',
                                                            style: TextStyle(color: Color(0xFF858585), fontSize: 16),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                // Collapsed pseudocode button
                                if (_isPseudocodeCollapsed)
                                  Container(
                                    width: 35,
                                    color: const Color(0xFF252526),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _isPseudocodeCollapsed = false;
                                            });
                                          },
                                          child: SizedBox(
                                            height: 35,
                                            child: const Center(
                                              child: Icon(Icons.chevron_left, color: Color(0xFF858585), size: 16),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: RotatedBox(
                                            quarterTurns: 1,
                                            child: Center(
                                              child: Text(
                                                'PSEUDOCODE',
                                                style: TextStyle(
                                                  color: Color(0xFF858585),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),

                            // Information tab
                            _buildInformationTab(),
                          ],
                        ),
                      ),

                      // Bottom status bar
                      Container(
                        height: 25,
                        color: const Color(0xFF007ACC),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              'Step ${_currentStepIndex + 1} of ${_steps.length}',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            const Spacer(),
                            // Step controls
                            InkWell(
                              onTap: _currentStepIndex > 0 ? _previousStep : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                child: Icon(
                                  Icons.skip_previous,
                                  color: _currentStepIndex > 0 ? Colors.white : Colors.white54,
                                  size: 16,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: _currentStepIndex < _steps.length - 1 ? _nextStep : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                child: Icon(
                                  Icons.skip_next,
                                  color: _currentStepIndex < _steps.length - 1 ? Colors.white : Colors.white54,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF858585),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildComplexityInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'COMPLEXITY',
          style: TextStyle(color: Color(0xFF858585), fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildComplexityItem('Time', _selectedAlgorithm!.timeComplexity, const Color(0xFFF44747))),
            const SizedBox(width: 8),
            Expanded(
              child: _buildComplexityItem('Space', _selectedAlgorithm!.spaceComplexity, const Color(0xFF569CD6)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                _selectedAlgorithm!.isStable
                    ? const Color(0xFF4EC9B0).withOpacity(0.2)
                    : const Color(0xFFDCDCAA).withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _selectedAlgorithm!.isStable ? 'Stable' : 'Unstable',
            style: TextStyle(
              color: _selectedAlgorithm!.isStable ? const Color(0xFF4EC9B0) : const Color(0xFFDCDCAA),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildComplexityItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isActive = _activeTabIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _activeTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E1E1E) : const Color(0xFF2D2D30),
          border: Border(bottom: BorderSide(color: isActive ? const Color(0xFF007ACC) : Colors.transparent, width: 2)),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? const Color(0xFFCCCCCC) : const Color(0xFF858585),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInformationTab() {
    if (_selectedAlgorithm == null) {
      return const Center(
        child: Text(
          'Select an algorithm to view information',
          style: TextStyle(color: Color(0xFF858585), fontSize: 16),
        ),
      );
    }

    return Container(
      color: const Color(0xFF1E1E1E),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Algorithm header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007ACC).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.info_outline, color: Color(0xFF007ACC), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedAlgorithm!.name,
                        style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedAlgorithm!.description,
                        style: const TextStyle(color: Color(0xFF858585), fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Complexity information
            _buildInfoSection(
              'Complexity Analysis',
              Icons.analytics,
              const Color(0xFFF44747),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time Complexity Analysis
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF44747).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFF44747).withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time, color: const Color(0xFFF44747), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Time Complexity: ${_selectedAlgorithm!.timeComplexity}',
                              style: const TextStyle(
                                color: Color(0xFFF44747),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _selectedAlgorithm!.getTimeComplexityExplanation(),
                          style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14, height: 1.4),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Space Complexity Analysis
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF569CD6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF569CD6).withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.memory, color: const Color(0xFF569CD6), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Space Complexity: ${_selectedAlgorithm!.spaceComplexity}',
                              style: const TextStyle(
                                color: Color(0xFF569CD6),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _selectedAlgorithm!.getSpaceComplexityExplanation(),
                          style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14, height: 1.4),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Stability Analysis
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (_selectedAlgorithm!.isStable ? const Color(0xFF4EC9B0) : const Color(0xFFDCDCAA))
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: (_selectedAlgorithm!.isStable ? const Color(0xFF4EC9B0) : const Color(0xFFDCDCAA))
                            .withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _selectedAlgorithm!.isStable ? Icons.check_circle : Icons.warning,
                              color: _selectedAlgorithm!.isStable ? const Color(0xFF4EC9B0) : const Color(0xFFDCDCAA),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Stability: ${_selectedAlgorithm!.isStable ? 'Stable' : 'Unstable'}',
                              style: TextStyle(
                                color: _selectedAlgorithm!.isStable ? const Color(0xFF4EC9B0) : const Color(0xFFDCDCAA),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _selectedAlgorithm!.getStabilityExplanation(),
                          style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Advantages
            _buildInfoSection(
              'Advantages',
              Icons.thumb_up,
              const Color(0xFF4EC9B0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    _selectedAlgorithm!.advantages
                        .map((advantage) => _buildListItem(advantage, const Color(0xFF4EC9B0), Icons.check))
                        .toList(),
              ),
            ),

            const SizedBox(height: 32),

            // Disadvantages
            _buildInfoSection(
              'Disadvantages',
              Icons.thumb_down,
              const Color(0xFFF44747),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    _selectedAlgorithm!.disadvantages
                        .map((disadvantage) => _buildListItem(disadvantage, const Color(0xFFF44747), Icons.close))
                        .toList(),
              ),
            ),

            // Algorithm-specific information
            if (_selectedAlgorithm!.name == 'Quick Sort') ...[
              const SizedBox(height: 32),
              _buildQuickSortSpecificInfo(),
            ],

            if (_selectedAlgorithm!.name == 'Bubble Sort') ...[
              const SizedBox(height: 32),
              _buildBubbleSortSpecificInfo(),
            ],

            if (_selectedAlgorithm!.name == 'Heap Sort') ...[const SizedBox(height: 32), _buildHeapSortSpecificInfo()],

            if (_selectedAlgorithm!.name == 'Radix Sort') ...[
              const SizedBox(height: 32),
              _buildRadixSortSpecificInfo(),
            ],

            if (_selectedAlgorithm!.name == 'Shell Sort') ...[
              const SizedBox(height: 32),
              _buildShellSortSpecificInfo(),
            ],

            if (_selectedAlgorithm!.name == 'Counting Sort') ...[
              const SizedBox(height: 32),
              _buildCountingSortSpecificInfo(),
            ],

            if (_selectedAlgorithm!.name == 'Bucket Sort') ...[
              const SizedBox(height: 32),
              _buildBucketSortSpecificInfo(),
            ],

            if (_selectedAlgorithm!.name == 'Tim Sort') ...[const SizedBox(height: 32), _buildTimSortSpecificInfo()],

            if (_selectedAlgorithm!.name == 'Bitonic Sort') ...[
              const SizedBox(height: 32),
              _buildBitonicSortSpecificInfo(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, Color color, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildListItem(String text, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14, height: 1.4))),
        ],
      ),
    );
  }

  Widget _buildQuickSortSpecificInfo() {
    return _buildInfoSection(
      'Specific Information - Quick Sort',
      Icons.psychology,
      const Color(0xFFDCDCAA),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Principle: Divide and Conquer', [
            '1. Choose Pivot: Select an element from the array',
            '2. Partition: Reorganize elements smaller to left, larger to right',
            '3. Recursion: Apply same process to subarrays',
            '4. Base Case: Stop when only one element remains',
          ], const Color(0xFFDCDCAA)),
          const SizedBox(height: 16),
          _buildInfoCard('Pivot Selection Strategies', [
            'First/Last element: Simple but O(n²) on sorted arrays',
            'Random element: Avoids patterns causing worst case',
            'Median: Theoretically ideal but more expensive in practice',
          ], const Color(0xFF569CD6)),
        ],
      ),
    );
  }

  Widget _buildBubbleSortSpecificInfo() {
    return _buildInfoSection(
      'Specific Information - Bubble Sort',
      Icons.bubble_chart,
      const Color(0xFFDCDCAA),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('How it Works', [
            'Multiple passes: Sorts through several iterations',
            'Adjacent comparison: Compares neighboring elements',
            'Bubbling: Large elements "bubble up" like bubbles',
            'Optimization: Detects when array is already sorted',
          ], const Color(0xFFDCDCAA)),
          const SizedBox(height: 16),
          _buildInfoCard('Use Cases', [
            'Education: Excellent for teaching sorting concepts',
            'Small arrays: Functional for very small datasets',
            'Detection: Useful to verify if array is sorted',
          ], const Color(0xFF4EC9B0)),
        ],
      ),
    );
  }

  Widget _buildHeapSortSpecificInfo() {
    return _buildInfoSection(
      'Specific Information - Heap Sort',
      Icons.account_tree,
      const Color(0xFFDCDCAA),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Heap Structure', [
            'Binary Heap: Complete binary tree with heap property',
            'Max-Heap: Parent ≥ children (for ascending sort)',
            'Array representation: left_child = 2i+1, right_child = 2i+2',
            'Root: Always contains the maximum element',
          ], const Color(0xFFDCDCAA)),
          const SizedBox(height: 16),
          _buildInfoCard('Algorithm Phases', [
            '1. Build: Convert array to max-heap O(n)',
            '2. Extract: Repeat n-1 times: remove max and re-heapify',
            '3. Heapify: Restore heap property O(log n)',
            '4. In-place: Use unsorted part as heap',
          ], const Color(0xFF569CD6)),
        ],
      ),
    );
  }

  Widget _buildRadixSortSpecificInfo() {
    return _buildInfoSection(
      'Specific Information - Radix Sort',
      Icons.filter_list,
      const Color(0xFFDCDCAA),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Non-Comparative Algorithm', [
            'LSD: Processes digits from right to left',
            'MSD: Processes digits from left to right',
            'Counting Sort: Used as stable subroutine',
            'Base 10: Processes digits 0-9 in each pass',
          ], const Color(0xFFDCDCAA)),
          const SizedBox(height: 16),
          _buildInfoCard('Practical Applications', [
            'Integer numbers: Especially effective',
            'Strings: With modifications for characters',
            'Numeric keys: IDs, postal codes',
            'Memory-constrained systems',
          ], const Color(0xFF4EC9B0)),
        ],
      ),
    );
  }

  Widget _buildShellSortSpecificInfo() {
    return _buildInfoSection(
      'Specific Information - Shell Sort',
      Icons.layers,
      const Color(0xFFDCDCAA),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Gap Sequences', [
            'Shell original: n/2, n/4, n/8, ..., 1',
            'Knuth: 3k+1 (1, 4, 13, 40, 121, ...)',
            'Sedgewick: 4^i + 3×2^(i-1) + 1',
            'Best sequence is still research topic',
          ], const Color(0xFFDCDCAA)),
          const SizedBox(height: 16),
          _buildInfoCard('Advantages over Insertion Sort', [
            'Moves large elements long distances quickly',
            'Reduces number of shifts needed',
            'Better performance on large arrays',
            'Maintains conceptual simplicity',
          ], const Color(0xFF569CD6)),
        ],
      ),
    );
  }

  Widget _buildCountingSortSpecificInfo() {
    return _buildInfoSection(
      'Specific Information - Counting Sort',
      Icons.calculate,
      const Color(0xFFDCDCAA),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Range Limitations', [
            'Efficient only when k (range) ≤ n',
            'Requires knowing min and max beforehand',
            'Memory grows linearly with range',
            'Variation needed for negative numbers',
          ], const Color(0xFFDCDCAA)),
          const SizedBox(height: 16),
          _buildInfoCard('Practical Applications', [
            'Sort by age (limited range)',
            'Exam scores (0-100)',
            'Subroutine in Radix Sort',
            'Histograms and frequency analysis',
          ], const Color(0xFF4EC9B0)),
        ],
      ),
    );
  }

  Widget _buildBucketSortSpecificInfo() {
    return _buildInfoSection(
      'Specific Information - Bucket Sort',
      Icons.scatter_plot,
      const Color(0xFFDCDCAA),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Element Distribution', [
            'Assumes uniform distribution for best performance',
            'Optimal bucket count: approximately √n',
            'Algorithm per bucket: typically Insertion Sort',
            'Parallelizable: independent buckets',
          ], const Color(0xFFDCDCAA)),
          const SizedBox(height: 16),
          _buildInfoCard('Use Cases', [
            'Floating point numbers in range [0,1)',
            'Data with known distribution',
            'External sorting with limited memory',
            'Preparation for mapping algorithms',
          ], const Color(0xFF569CD6)),
        ],
      ),
    );
  }

  Widget _buildTimSortSpecificInfo() {
    return _buildInfoSection(
      'Specific Information - Tim Sort',
      Icons.auto_fix_high,
      const Color(0xFFDCDCAA),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Standard Implementation', [
            'Fixed RUN of 32 elements for Insertion Sort',
            'Iterative merge: 32→64→128→256...',
            'Similar to Python/Java implementation',
            'Two phases: run sorting + progressive merge',
          ], const Color(0xFFDCDCAA)),
          const SizedBox(height: 16),
          _buildInfoCard('Hybrid Approach Benefits', [
            'Insertion Sort efficient for small runs',
            'Merge Sort stable for large combinations',
            'Takes advantage of memory locality',
            'Balanced between simplicity and performance',
          ], const Color(0xFF4EC9B0)),
        ],
      ),
    );
  }

  Widget _buildBitonicSortSpecificInfo() {
    return _buildInfoSection(
      'Specific Information - Bitonic Sort',
      Icons.compare_arrows,
      const Color(0xFFDCDCAA),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Bitonic Sequence', [
            'First half increasing, second half decreasing',
            'Or vice versa: first decreasing, second increasing',
            'Property: any rotation remains bitonic',
            'Foundation for the sorting algorithm',
          ], const Color(0xFFDCDCAA)),
          const SizedBox(height: 16),
          _buildInfoCard('Parallelization', [
            'Independent comparisons at each level',
            'Ideal for parallel architectures (SIMD)',
            'Predictable memory access pattern for cache',
            'Fixed comparison-exchange network',
          ], const Color(0xFF569CD6)),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<String> items, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(item, style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14, height: 1.4)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 4, spreadRadius: 1)],
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Color(0xFF858585), fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
