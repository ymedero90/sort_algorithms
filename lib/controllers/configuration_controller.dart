import 'package:flutter/material.dart';

import '../models/sorting_algorithm.dart';
import '../services/sorting_service.dart';
import 'sorting_controller.dart';

class ConfigurationController extends ChangeNotifier {
  final SortingController _sortingController;
  final TextEditingController arraySizeController = TextEditingController();

  ConfigurationController(this._sortingController) {
    arraySizeController.text = _sortingController.arraySize.toString();
    _sortingController.addListener(_onSortingControllerChanged);
  }

  // Getters que delegan al SortingController
  bool get isCollapsed => _sortingController.isSidebarCollapsed;
  SortingAlgorithm? get selectedAlgorithm => _sortingController.selectedAlgorithm;
  int get arraySize => _sortingController.arraySize;
  double get animationSpeed => _sortingController.animationSpeed;
  String get playButtonText => _sortingController.playButtonText;
  IconData get playButtonIcon => _sortingController.playButtonIcon;
  Color get playButtonColor => _sortingController.playButtonColor;

  List<SortingAlgorithm> get availableAlgorithms => SortingService.algorithms;

  // Actions
  void toggleCollapse() {
    _sortingController.toggleSidebar();
  }

  void selectAlgorithm(SortingAlgorithm? algorithm) {
    _sortingController.selectAlgorithm(algorithm);
  }

  void updateArraySize(String value) {
    final validation = _sortingController.validateArraySizeInput(value);
    if (validation == null) {
      final size = int.parse(value);
      _sortingController.setArraySize(size);
    }
  }

  void updateAnimationSpeed(double speed) {
    _sortingController.setAnimationSpeed(speed);
  }

  void generateNewArray() {
    // Validar el input actual antes de generar
    final currentText = arraySizeController.text.trim();
    if (currentText.isNotEmpty) {
      final validation = _sortingController.validateArraySizeInput(currentText);
      if (validation == null) {
        final size = int.parse(currentText);
        _sortingController.setArraySize(size);
      } else {
        // Si hay error, corregir a valor por defecto
        arraySizeController.text = '8';
        _sortingController.setArraySize(8);
      }
    }
    _sortingController.generateRandomArray();
  }

  void startPauseAnimation() {
    if (_sortingController.isPlaying) {
      _sortingController.pauseAnimation();
    } else if (_sortingController.isPaused) {
      _sortingController.resumeAnimation();
    } else {
      _sortingController.startAnimation();
    }
  }

  void resetVisualization() {
    _sortingController.resetVisualization();
  }

  // Input Validation
  String? validateArraySizeInput(String input) {
    return _sortingController.validateArraySizeInput(input);
  }

  void handleArraySizeInputComplete() {
    final value = arraySizeController.text.trim();
    if (value.isEmpty) {
      arraySizeController.text = '8';
      _sortingController.setArraySize(8);
      _sortingController.generateRandomArray();
    } else {
      final validation = validateArraySizeInput(value);
      if (validation != null) {
        arraySizeController.text = '8';
        _sortingController.setArraySize(8);
        _sortingController.generateRandomArray();
      }
    }
  }

  void _onSortingControllerChanged() {
    // Sincronizar el campo de texto si el tamaño cambió externamente
    if (arraySizeController.text != _sortingController.arraySize.toString()) {
      arraySizeController.text = _sortingController.arraySize.toString();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _sortingController.removeListener(_onSortingControllerChanged);
    arraySizeController.dispose();
    super.dispose();
  }
}
