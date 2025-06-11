import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';

class BubbleSort extends SortingAlgorithm {
  @override
  String get name => 'Bubble Sort';

  @override
  String get description =>
      'The simplest sorting algorithm that works by repeatedly swapping adjacent elements. Complexity: O(n²) - Stable';

  @override
  String get timeComplexity => 'O(n²)';

  @override
  String get spaceComplexity => 'O(1)';

  @override
  bool get isStable => true;

  @override
  List<String> get advantages => [
    'Simplest algorithm to understand and implement',
    'No additional memory required (in-place)',
    'Stable algorithm (maintains relative order)',
    'Automatically detects if array is already sorted',
    'Works well for very small datasets',
    'Useful for educational purposes and demonstration',
  ];

  @override
  List<String> get disadvantages => [
    'O(n²) complexity not suitable for large data',
    'Very poor performance compared to other algorithms',
    'Makes many unnecessary comparisons and swaps',
    'Almost no real-world applications',
    'Mainly limited to academic teaching',
  ];

  @override
  List<String> get pseudocode => [
    'function bubbleSort(arr):',
    '    n = length(arr)',
    '    for i = 0 to n-1:',
    '        swapped = false',
    '        for j = 0 to n-i-2:',
    '            if arr[j] > arr[j+1]:',
    '                swap(arr[j], arr[j+1])',
    '                swapped = true',
    '        if swapped == false:',
    '            break',
    '    return arr',
  ];

  @override
  List<SortStep> sort(List<int> array) {
    List<SortStep> steps = [];
    List<int> arr = List.from(array);
    int n = arr.length;

    steps.add(
      SortStep(
        array: List.from(arr),
        description: '🎯 Bubble Sort: The simplest algorithm. Sorts through multiple passes',
        currentPseudocodeLine: 0,
      ),
    );

    // We sort the array using multiple passes
    for (int i = 0; i < n; i++) {
      bool swapped = false;

      steps.add(
        SortStep(
          array: List.from(arr),
          description:
              '🔄 Pass ${i + 1}: After ${i == 0 ? "this pass" : "$i passes"}, ${i == 0 ? "the maximum element will go" : "the $i largest elements are"} to the end',
          currentPseudocodeLine: 2,
        ),
      );

      steps.add(
        SortStep(array: List.from(arr), description: '📝 Initializing swapped = false', currentPseudocodeLine: 3),
      );

      // After k passes, the largest k elements are in correct position
      for (int j = 0; j < n - i - 1; j++) {
        steps.add(
          SortStep(
            array: List.from(arr),
            comparing: [j, j + 1],
            description: '🔍 Comparing adjacent elements: ${arr[j]} and ${arr[j + 1]}',
            currentPseudocodeLine: 5,
          ),
        );

        // Swap if larger element is before smaller element
        if (arr[j] > arr[j + 1]) {
          int temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;
          swapped = true;

          steps.add(
            SortStep(
              array: List.from(arr),
              swapping: [j, j + 1],
              description: '🔄 Swap: ${arr[j]} < ${arr[j + 1]} (larger element moves toward end)',
              currentPseudocodeLine: 6,
            ),
          );

          steps.add(
            SortStep(
              array: List.from(arr),
              swapping: [j, j + 1],
              description: '📝 swapped = true',
              currentPseudocodeLine: 7,
            ),
          );
        }
      }

      // Mark the correctly positioned elements
      List<int> currentSorted = [];
      for (int k = n - 1 - i; k < n; k++) {
        currentSorted.add(k);
      }

      steps.add(
        SortStep(
          array: List.from(arr),
          sorted: currentSorted,
          description: '✅ Pass ${i + 1} complete: Element ${arr[n - 1 - i]} is in its correct position',
          currentPseudocodeLine: 8,
        ),
      );

      // Optimization: if no swapping occurred, array is sorted
      if (!swapped) {
        steps.add(
          SortStep(
            array: List.from(arr),
            sorted: List.generate(n, (index) => index),
            description: '🚀 Optimization activated! No swaps = Array sorted. Best case: O(n)',
            currentPseudocodeLine: 9,
          ),
        );
        break;
      }
    }

    steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(n, (index) => index),
        description: '🎉 Bubble Sort completed! Each pass placed the largest element in its final position',
        currentPseudocodeLine: 10,
      ),
    );

    return steps;
  }

  @override
  String getTimeComplexityExplanation() {
    return 'O(n²) because it has two nested loops: the outer loop executes n-1 passes, and in each pass, the inner loop performs up to n-1 comparisons. Total: (n-1) × (n-1) ≈ n² comparisons. Even in the best case (already sorted array), without optimization it would be O(n²), but with the "swapped" flag optimization it can be O(n).';
  }

  @override
  String getSpaceComplexityExplanation() {
    return 'O(1) because it only uses a constant amount of additional memory: some variables for indices (i, j) and a temporary variable for swaps. It doesn\'t require auxiliary arrays nor grows with input size.';
  }

  @override
  String getStabilityExplanation() {
    return 'It is stable because it only swaps adjacent elements when the left one is strictly greater than the right one (arr[j] > arr[j+1]). Equal elements are never swapped, maintaining their original relative order.';
  }
}
