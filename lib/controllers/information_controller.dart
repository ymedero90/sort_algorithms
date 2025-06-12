import 'package:flutter/material.dart';

import '../models/sorting_algorithm.dart';
import 'sorting_controller.dart';

class InformationController extends ChangeNotifier {
  final SortingController _sortingController;

  InformationController(this._sortingController) {
    _sortingController.addListener(_onSortingControllerChanged);
  }

  // Getters
  SortingAlgorithm? get algorithm => _sortingController.selectedAlgorithm;
  bool get hasAlgorithm => algorithm != null;

  // Información del algoritmo
  String get algorithmName => algorithm?.name ?? '';
  String get algorithmDescription => algorithm?.description ?? '';
  String get timeComplexity => algorithm?.timeComplexity ?? '';
  String get spaceComplexity => algorithm?.spaceComplexity ?? '';
  bool get isStable => algorithm?.isStable ?? false;
  List<String> get advantages => algorithm?.advantages ?? [];
  List<String> get disadvantages => algorithm?.disadvantages ?? [];

  // Explicaciones detalladas
  String get timeComplexityExplanation => algorithm?.getTimeComplexityExplanation() ?? '';
  String get spaceComplexityExplanation => algorithm?.getSpaceComplexityExplanation() ?? '';
  String get stabilityExplanation => algorithm?.getStabilityExplanation() ?? '';

  // Información específica del algoritmo
  bool get hasSpecificInfo => algorithm != null && _getSpecificInfoSections().isNotEmpty;

  List<SpecificInfoSection> _getSpecificInfoSections() {
    if (algorithm == null) return [];

    switch (algorithm!.name) {
      case 'Quick Sort':
        return _getQuickSortInfo();
      case 'Bubble Sort':
        return _getBubbleSortInfo();
      case 'Heap Sort':
        return _getHeapSortInfo();
      case 'Radix Sort':
        return _getRadixSortInfo();
      case 'Shell Sort':
        return _getShellSortInfo();
      case 'Counting Sort':
        return _getCountingSortInfo();
      case 'Bucket Sort':
        return _getBucketSortInfo();
      case 'Tim Sort':
        return _getTimSortInfo();
      case 'Bitonic Sort':
        return _getBitonicSortInfo();
      default:
        return [];
    }
  }

  List<SpecificInfoSection> get specificInfoSections => _getSpecificInfoSections();

  List<SpecificInfoSection> _getQuickSortInfo() {
    return [
      SpecificInfoSection(
        title: 'Principle: Divide and Conquer',
        items: [
          '1. Choose Pivot: Select an element from the array',
          '2. Partition: Reorganize elements smaller to left, larger to right',
          '3. Recursion: Apply same process to subarrays',
          '4. Base Case: Stop when only one element remains',
        ],
        color: const Color(0xFFDCDCAA),
      ),
      SpecificInfoSection(
        title: 'Pivot Selection Strategies',
        items: [
          'First/Last element: Simple but O(n²) on sorted arrays',
          'Random element: Avoids patterns causing worst case',
          'Median: Theoretically ideal but more expensive in practice',
        ],
        color: const Color(0xFF569CD6),
      ),
    ];
  }

  List<SpecificInfoSection> _getBubbleSortInfo() {
    return [
      SpecificInfoSection(
        title: 'How it Works',
        items: [
          'Multiple passes: Sorts through several iterations',
          'Adjacent comparison: Compares neighboring elements',
          'Bubbling: Large elements "bubble up" like bubbles',
          'Optimization: Detects when array is already sorted',
        ],
        color: const Color(0xFFDCDCAA),
      ),
      SpecificInfoSection(
        title: 'Use Cases',
        items: [
          'Education: Excellent for teaching sorting concepts',
          'Small arrays: Functional for very small datasets',
          'Detection: Useful to verify if array is sorted',
        ],
        color: const Color(0xFF4EC9B0),
      ),
    ];
  }

  // Agregar métodos similares para otros algoritmos...
  List<SpecificInfoSection> _getHeapSortInfo() {
    return [
      SpecificInfoSection(
        title: 'Heap Structure',
        items: [
          'Binary Heap: Complete binary tree with heap property',
          'Max-Heap: Parent ≥ children (for ascending sort)',
          'Array representation: left_child = 2i+1, right_child = 2i+2',
          'Root: Always contains the maximum element',
        ],
        color: const Color(0xFFDCDCAA),
      ),
    ];
  }

  List<SpecificInfoSection> _getRadixSortInfo() => [];
  List<SpecificInfoSection> _getShellSortInfo() => [];
  List<SpecificInfoSection> _getCountingSortInfo() => [];
  List<SpecificInfoSection> _getBucketSortInfo() => [];
  List<SpecificInfoSection> _getTimSortInfo() => [];
  List<SpecificInfoSection> _getBitonicSortInfo() => [];

  void _onSortingControllerChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _sortingController.removeListener(_onSortingControllerChanged);
    super.dispose();
  }
}

class SpecificInfoSection {
  final String title;
  final List<String> items;
  final Color color;

  SpecificInfoSection({required this.title, required this.items, required this.color});
}
