import 'sort_step.dart';

abstract class SortingAlgorithm {
  String get name;
  String get description;

  List<SortStep> sort(List<int> array);

  // Educational information
  String get timeComplexity => 'O(n²)';
  String get spaceComplexity => 'O(1)';
  bool get isStable => true;
  List<String> get advantages => [];
  List<String> get disadvantages => [];

  // Pseudocode lines for interactive display
  List<String> get pseudocode => [];

  // Educational information methods
  String getTimeComplexityExplanation() => 'Specific analysis not available for this algorithm.';
  String getSpaceComplexityExplanation() => 'Specific analysis not available for this algorithm.';
  String getStabilityExplanation() => 'Specific analysis not available for this algorithm.';
}
