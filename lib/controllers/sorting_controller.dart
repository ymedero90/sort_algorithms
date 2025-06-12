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
  double _animationSpeed = 1.0;

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

  // Animation Control
  void setAnimationSpeed(double speed) {
    _animationSpeed = speed;
    notifyListeners();
  }

  void startAnimation() {
    if (_selectedAlgorithm != null && _steps.length == 1) {
      _steps = SortingService.executeAlgorithm(_selectedAlgorithm!, _array);
    }
    _isPlaying = true;
    _isPaused = false;
    notifyListeners();
  }

  void pauseAnimation() {
    _isPlaying = false;
    _isPaused = true;
    notifyListeners();
  }

  void resumeAnimation() {
    _isPlaying = true;
    _isPaused = false;
    notifyListeners();
  }

  void stopAnimation() {
    _isPlaying = false;
    _isPaused = false;
    notifyListeners();
  }

  void resetVisualization() {
    _currentStepIndex = 0;
    _isPlaying = false;
    _isPaused = false;
    notifyListeners();
  }

  // Step Navigation
  void nextStep() {
    if (_currentStepIndex < _steps.length - 1) {
      _currentStepIndex++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStepIndex > 0) {
      _currentStepIndex--;
      notifyListeners();
    }
  }

  void setCurrentStep(int index) {
    if (index >= 0 && index < _steps.length) {
      _currentStepIndex = index;
      notifyListeners();
    }
  }

  // UI State Management
  void setActiveTab(int index) {
    _activeTabIndex = index;
    notifyListeners();
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
    if (_isPlaying && _currentStepIndex < _steps.length - 1) {
      _currentStepIndex++;
      notifyListeners();
    } else if (_currentStepIndex >= _steps.length - 1) {
      stopAnimation();
    }
  }

  // Algorithm Execution
  void executeAlgorithm() {
    if (_selectedAlgorithm != null) {
      _steps = SortingService.executeAlgorithm(_selectedAlgorithm!, _array);
      _currentStepIndex = 0;
      notifyListeners();
    }
  }
}
