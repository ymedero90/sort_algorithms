import 'package:flutter/material.dart';

import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';
import 'sorting_controller.dart';

class VisualizationController extends ChangeNotifier {
  final SortingController _sortingController;

  VisualizationController(this._sortingController) {
    _sortingController.addListener(_onSortingControllerChanged);
  }

  // Getters que delegan al SortingController
  List<SortStep> get steps => _sortingController.steps;
  int get currentStepIndex => _sortingController.currentStepIndex;
  SortingAlgorithm? get selectedAlgorithm => _sortingController.selectedAlgorithm;
  bool get isVisualizationCollapsed => _sortingController.isVisualizationCollapsed;
  bool get isPseudocodeCollapsed => _sortingController.isPseudocodeCollapsed;

  // Estado específico de la visualización
  SortStep? get currentStep {
    if (steps.isNotEmpty && currentStepIndex < steps.length) {
      return steps[currentStepIndex];
    }
    return null;
  }

  bool get hasSteps => steps.isNotEmpty;
  bool get hasCurrentLine => currentStep?.currentPseudocodeLine != null;
  int? get currentPseudocodeLine => currentStep?.currentPseudocodeLine;

  // Actions
  void toggleVisualization() {
    _sortingController.toggleVisualization();
  }

  void togglePseudocode() {
    _sortingController.togglePseudocode();
  }

  // Información para la leyenda
  List<LegendItem> get legendItems => [
    LegendItem(color: const Color(0xFF569CD6), label: 'Normal', description: 'Elements in their current position'),
    LegendItem(color: const Color(0xFFDCDCAA), label: 'Comparing', description: 'Elements being compared'),
    LegendItem(color: const Color(0xFFF44747), label: 'Swapping', description: 'Elements being swapped'),
    LegendItem(color: const Color(0xFF4EC9B0), label: 'Sorted', description: 'Elements in their final sorted position'),
  ];

  void _onSortingControllerChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _sortingController.removeListener(_onSortingControllerChanged);
    super.dispose();
  }
}

class LegendItem {
  final Color color;
  final String label;
  final String description;

  LegendItem({required this.color, required this.label, required this.description});
}
