import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';

class SelectionSort extends SortingAlgorithm {
  @override
  String get name => 'Selection Sort';

  @override
  String get description =>
      'Finds the minimum element and swaps it with the first position repeatedly. Complexity: O(n²) - Unstable';

  @override
  String get timeComplexity => 'O(n²)';

  @override
  String get spaceComplexity => 'O(1)';

  @override
  bool get isStable => false;

  @override
  List<String> get advantages => [
    'Simple algorithm to understand and implement',
    'No additional memory required (in-place)',
    'Performs exactly n-1 swaps (minimum possible)',
    'Works well for small datasets',
    'Not affected by initial order of elements',
    'Useful when memory writes are expensive',
  ];

  @override
  List<String> get disadvantages => [
    'O(n²) complexity not suitable for large data',
    'Not stable (changes relative order of equal elements)',
    'Poor performance compared to advanced algorithms',
    'Makes many unnecessary comparisons',
    'Not adaptive (same performance regardless of input)',
  ];

  @override
  List<String> get pseudocode => [
    'function selectionSort(arr):',
    '    n = length(arr)',
    '    for i = 0 to n-2:',
    '        min_idx = i',
    '        for j = i+1 to n-1:',
    '            if arr[j] < arr[min_idx]:',
    '                min_idx = j',
    '        if min_idx != i:',
    '            swap(arr[i], arr[min_idx])',
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
        description: '🎯 Selection Sort: Find minimum and place it at the beginning',
        currentPseudocodeLine: 0,
      ),
    );

    steps.add(SortStep(array: List.from(arr), description: '📏 n = ${arr.length}', currentPseudocodeLine: 1));

    for (int i = 0; i < n - 1; i++) {
      steps.add(
        SortStep(
          array: List.from(arr),
          description: '🔄 Pass ${i + 1}: Finding minimum in unsorted portion [$i...${n - 1}]',
          currentPseudocodeLine: 1,
        ),
      );

      steps.add(
        SortStep(array: List.from(arr), description: '📝 Initializing minIndex = $i', currentPseudocodeLine: 2),
      );

      // Assume the current position holds the minimum element
      int minIndex = i;
      steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [i],
          description: '📝 Asumiendo que posición $i contiene el mínimo: min_idx = $i',
          currentPseudocodeLine: 3,
        ),
      );

      // Iterate through the unsorted portion to find the actual minimum
      for (int j = i + 1; j < n; j++) {
        steps.add(
          SortStep(
            array: List.from(arr),
            comparing: [minIndex, j],
            description: '🔍 Comparing arr[$minIndex] = ${arr[minIndex]} with arr[$j] = ${arr[j]}',
            currentPseudocodeLine: 3,
          ),
        );

        if (arr[j] < arr[minIndex]) {
          // Update min_idx if a smaller element is found
          minIndex = j;
          steps.add(
            SortStep(
              array: List.from(arr),
              comparing: [minIndex, j],
              description: '📍 New minimum found! minIndex = $j (value: ${arr[j]})',
              currentPseudocodeLine: 4,
            ),
          );
        }
      }

      // Move minimum element to its correct position
      if (minIndex != i) {
        int temp = arr[i];
        arr[i] = arr[minIndex];
        arr[minIndex] = temp;

        steps.add(
          SortStep(
            array: List.from(arr),
            swapping: [i, minIndex],
            description: '🔄 Swapping arr[$i] = $temp with arr[$minIndex] = ${arr[minIndex]}',
            currentPseudocodeLine: 5,
          ),
        );
      } else {
        steps.add(
          SortStep(
            array: List.from(arr),
            description: '✅ Element ${arr[i]} is already in correct position',
            currentPseudocodeLine: 5,
          ),
        );
      }

      steps.add(
        SortStep(
          array: List.from(arr),
          sorted: List.generate(i + 1, (index) => index),
          description: '✅ Pass ${i + 1} complete: Position $i has correct element ${arr[i]}',
          currentPseudocodeLine: 6,
        ),
      );
    }

    steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(n, (index) => index),
        description: '🎉 Selection Sort completed! Each pass found and placed the minimum element',
        currentPseudocodeLine: 7,
      ),
    );

    return steps;
  }

  @override
  String getTimeComplexityExplanation() {
    return 'O(n²) because it has two nested loops: the outer loop runs n-1 times, and for each iteration, the inner loop performs comparisons to find the minimum. Total comparisons: (n-1) + (n-2) + ... + 1 = n(n-1)/2 ≈ n²/2, which is O(n²). Unlike Bubble Sort, it cannot be optimized for best case.';
  }

  @override
  String getSpaceComplexityExplanation() {
    return 'O(1) because it only uses a constant amount of additional memory: variables for indices (i, j), minimum index (minIndex), and temporary variable for swapping. No auxiliary arrays are needed.';
  }

  @override
  String getStabilityExplanation() {
    return 'It is not stable because it can swap non-adjacent elements, potentially changing the relative order of equal elements. For example, if we have [5a, 3, 5b], after finding minimum 3, we swap 5a with 3, making it [3, 5b, 5a], changing the original order of the equal 5s.';
  }
}
