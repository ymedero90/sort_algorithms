import 'dart:math';

import 'package:flutter/material.dart';

import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';
import '../services/sorting_service.dart';

class SortingController extends ChangeNotifier {
  // Estado del array y visualización
  List<int> _array = [];
  List<SortStep> _steps = [];
  int _currentStepIndex = 0;

  // Estado de la animación
  bool _isPlaying = false;
  bool _isPaused = false;
  double _animationSpeed = 0.5; // Velocidad por defecto más lenta
  bool _isExecutingStep = false; // Nuevo flag para controlar ejecución

  // Configuración
  SortingAlgorithm? _selectedAlgorithm;
  int _arraySize = 8;

  // Estado de la UI
  int _activeTabIndex = 0;
  bool _isVisualizationCollapsed = false;
  bool _isPseudocodeCollapsed = false;
  bool _isSidebarCollapsed = false;

  // Getters
  List<int> get array => _array;
  List<SortStep> get steps => _steps;
  int get currentStepIndex => _currentStepIndex;
  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  double get animationSpeed => _animationSpeed;
  SortingAlgorithm? get selectedAlgorithm => _selectedAlgorithm;
  int get arraySize => _arraySize;
  int get activeTabIndex => _activeTabIndex;
  bool get isVisualizationCollapsed => _isVisualizationCollapsed;
  bool get isPseudocodeCollapsed => _isPseudocodeCollapsed;
  bool get isSidebarCollapsed => _isSidebarCollapsed;

  // UI State Getters
  String get playButtonText {
    if (_isPlaying) return 'Pause';
    if (_isPaused) return 'Resume';
    return 'Start';
  }

  IconData get playButtonIcon {
    if (_isPlaying) return Icons.pause;
    return Icons.play_arrow;
  }

  Color get playButtonColor {
    if (_isPlaying) return const Color(0xFFF44747);
    if (_isPaused) return const Color(0xFFDCDCAA);
    return const Color(0xFF4EC9B0);
  }

  bool get canGoPrevious => _currentStepIndex > 0;
  bool get canGoNext => _currentStepIndex < _steps.length - 1;

  // Inicialización
  void initialize() {
    _selectedAlgorithm = SortingService.algorithms.first;
    generateRandomArray();
  }

  // Array Management
  void generateRandomArray() {
    if (_arraySize < 3 || _arraySize == 0) {
      _arraySize = 8;
    }

    final random = Random();
    _array = List.generate(_arraySize, (_) => random.nextInt(50) + 5);
    _steps = [SortStep(array: List.from(_array), description: '🎯 Initial array generated')];
    _currentStepIndex = 0;
    _isPlaying = false;
    _isPaused = false;
    notifyListeners();
  }

  void setArraySize(int size) {
    if (size >= 3 && size <= 64) {
      _arraySize = size;
      notifyListeners();
    }
  }

  // Algorithm Management
  void selectAlgorithm(SortingAlgorithm? algorithm) {
    _selectedAlgorithm = algorithm;
    _currentStepIndex = 0;
    _isPlaying = false;
    _isPaused = false;
    _steps = [SortStep(array: List.from(_array), description: '🎯 Initial array generated')];
    notifyListeners();
  }

  // Debug flag - set to false to disable debug logging
  static const bool _debugMode = false;

  // Animation Control
  void setAnimationSpeed(double speed) {
    if (_debugMode) print('🎛️ Setting animation speed to: $speed');
    _animationSpeed = speed.clamp(0.1, 2.0); // Limitar rango
    notifyListeners();
  }

  void startAnimation() {
    if (_debugMode) {
      print('▶️ Starting animation...');
      print('📊 Current algorithm: ${_selectedAlgorithm?.name}');
      print('📊 Current steps count: ${_steps.length}');
    }

    if (_selectedAlgorithm != null && _steps.length == 1) {
      if (_debugMode) print('🔄 Executing algorithm to generate steps...');
      _steps = SortingService.executeAlgorithm(_selectedAlgorithm!, _array);
      if (_debugMode) print('✅ Algorithm executed. Generated ${_steps.length} steps');
    }

    _isPlaying = true;
    _isPaused = false;
    _isExecutingStep = false; // Reset flag
    if (_debugMode) print('✅ Animation started. Current step: $_currentStepIndex');
    notifyListeners();
  }

  void pauseAnimation() {
    if (_debugMode) print('⏸️ Pausing animation at step $_currentStepIndex');
    _isPlaying = false;
    _isPaused = true;
    _isExecutingStep = false; // Reset flag
    notifyListeners();
  }

  void resumeAnimation() {
    if (_debugMode) print('▶️ Resuming animation from step $_currentStepIndex');
    _isPlaying = true;
    _isPaused = false;
    _isExecutingStep = false; // Reset flag
    notifyListeners();
  }

  void stopAnimation() {
    if (_debugMode) print('⏹️ Stopping animation');
    _isPlaying = false;
    _isPaused = false;
    _isExecutingStep = false; // Reset flag
    notifyListeners();
  }

  void resetVisualization() {
    if (_debugMode) print('🔄 Resetting visualization to step 0');
    _currentStepIndex = 0;
    _isPlaying = false;
    _isPaused = false;
    _isExecutingStep = false; // Reset flag
    notifyListeners();
  }

  // Step Navigation
  void nextStep() {
    if (_currentStepIndex < _steps.length - 1) {
      _currentStepIndex++;
      if (_debugMode) {
        print('⏭️ Next step: $_currentStepIndex/${_steps.length}');
        print('📝 Step description: ${_steps[_currentStepIndex].description}');
      }
      notifyListeners();
    } else {
      if (_debugMode) print('🚫 Cannot go to next step: already at end');
    }
  }

  void previousStep() {
    if (_currentStepIndex > 0) {
      _currentStepIndex--;
      if (_debugMode) {
        print('⏮️ Previous step: $_currentStepIndex/${_steps.length}');
        print('📝 Step description: ${_steps[_currentStepIndex].description}');
      }
      notifyListeners();
    } else {
      if (_debugMode) print('🚫 Cannot go to previous step: already at beginning');
    }
  }

  void setCurrentStep(int index) {
    if (index >= 0 && index < _steps.length) {
      if (_debugMode) {
        print('🎯 Setting current step to: $index/${_steps.length}');
        print('📝 Step description: ${_steps[_currentStepIndex].description}');
      }
      _currentStepIndex = index;
      notifyListeners();
    } else {
      if (_debugMode) print('🚫 Invalid step index: $index (valid range: 0-${_steps.length - 1})');
    }
  }

  // UI State Management
  void setActiveTab(int index) {
    if (_debugMode) print('📱 Setting active tab to: $index');
    _activeTabIndex = index;
    notifyListeners();
  }

  void setMobileTab(int index) {
    // Para móvil, asegurar que el índice sea válido (0, 1, 2)
    if (index >= 0 && index <= 2) {
      if (_debugMode) print('📱 Setting mobile tab to: $index');
      _activeTabIndex = index;
      notifyListeners();
    }
  }

  void toggleSidebar() {
    _isSidebarCollapsed = !_isSidebarCollapsed;
    notifyListeners();
  }

  void toggleVisualization() {
    _isVisualizationCollapsed = !_isVisualizationCollapsed;
    notifyListeners();
  }

  void togglePseudocode() {
    _isPseudocodeCollapsed = !_isPseudocodeCollapsed;
    notifyListeners();
  }

  // Validation Methods
  bool isValidArraySize(int size) {
    return size >= 3 && size <= 64;
  }

  String? validateArraySizeInput(String input) {
    if (input.trim().isEmpty) {
      return 'Array size cannot be empty';
    }

    final size = int.tryParse(input);
    if (size == null) {
      return 'Invalid number format';
    }

    if (size < 3) {
      return 'Minimum array size is 3 elements';
    }

    if (size > 64) {
      return 'Maximum array size is 64 elements';
    }

    return null;
  }

  // Animation Flow Control
  Future<void> executeAnimationStep() async {
    // Prevenir ejecuciones múltiples
    if (_isExecutingStep) {
      if (_debugMode) print('⚠️ Step execution already in progress, skipping');
      return;
    }

    if (!_isPlaying) {
      if (_debugMode) print('⏸️ Animation not playing, skipping step');
      return;
    }

    if (_currentStepIndex >= _steps.length - 1) {
      if (_debugMode) print('🏁 Animation completed: reached end of steps');
      stopAnimation();
      return;
    }

    _isExecutingStep = true;

    try {
      _currentStepIndex++;
      if (_debugMode) {
        print('🎬 Animation step: $_currentStepIndex/${_steps.length}');
        print('📝 Current step: ${_steps[_currentStepIndex].description}');
      }
      notifyListeners();
    } finally {
      _isExecutingStep = false;
    }
  }

  // Algorithm Execution
  void executeAlgorithm() {
    if (_selectedAlgorithm != null) {
      if (_debugMode) {
        print('🚀 Executing algorithm: ${_selectedAlgorithm!.name}');
        print('📊 Input array: $_array');
      }

      _steps = SortingService.executeAlgorithm(_selectedAlgorithm!, _array);
      _currentStepIndex = 0;

      if (_debugMode) {
        print('✅ Algorithm execution completed');
        print('📈 Generated ${_steps.length} steps');
        print('🎯 Reset to step 0');
      }

      notifyListeners();
    } else {
      if (_debugMode) print('🚫 Cannot execute: no algorithm selected');
    }
  }
}
