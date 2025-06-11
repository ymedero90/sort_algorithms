import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';

class InsertionSort extends SortingAlgorithm {
  List<SortStep> _steps = [];

  @override
  String get name => 'Insertion Sort';

  @override
  String get description =>
      'Builds the sorted array one element at a time by inserting each element in its correct position. Complexity: O(n²) - Stable';

  @override
  String get timeComplexity => 'O(n²)';

  @override
  String get spaceComplexity => 'O(1)';

  @override
  bool get isStable => true;

  @override
  List<String> get advantages => [
    'Simple to implement and understand',
    'Efficient for small arrays',
    'Stable algorithm',
    'In-place (no extra memory required)',
    'Adaptive (efficient for nearly sorted data)',
    'Online (can sort data as it arrives)',
  ];

  @override
  List<String> get disadvantages => [
    'O(n²) complexity for large arrays',
    'More comparisons than Selection Sort',
    'Not efficient for large arrays',
    'Poor performance on reverse sorted arrays',
  ];

  @override
  List<String> get pseudocode => [
    'function insertionSort(arr):',
    '    for i = 1 to length(arr) - 1:',
    '        key = arr[i]',
    '        j = i - 1',
    '        while j >= 0 and arr[j] > key:',
    '            arr[j + 1] = arr[j]',
    '            j = j - 1',
    '        arr[j + 1] = key',
    '    return arr',
  ];

  @override
  String getTimeComplexityExplanation() {
    return 'O(n²) in worst case when array is reverse sorted. For each element (n-1 elements), it may need up to i comparisons and shifts. In best case (already sorted) it\'s O(n) because it only needs one comparison per element.';
  }

  @override
  String getSpaceComplexityExplanation() {
    return 'O(1) because it only uses a constant amount of auxiliary variables (key, i, j). All sorting is done in-place without requiring additional arrays.';
  }

  @override
  String getStabilityExplanation() {
    return 'It is stable because it only moves an element to the left if it is strictly smaller than the already sorted elements. Equal elements are never swapped, maintaining their original relative order.';
  }

  @override
  List<SortStep> sort(List<int> array) {
    _steps = [];
    List<int> arr = List.from(array);
    int n = arr.length;

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🎯 Insertion Sort: Build sorted array one element at a time',
        currentPseudocodeLine: 0,
      ),
    );

    for (int i = 1; i < n; i++) {
      int key = arr[i];
      int j = i - 1;

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [i],
          sorted: List.generate(i, (index) => index),
          description: '🔄 Iteration $i: Inserting element ${arr[i]} into sorted portion',
          currentPseudocodeLine: 1,
        ),
      );

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [i],
          description: '📝 key = arr[$i] = $key',
          currentPseudocodeLine: 2,
        ),
      );

      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '📝 j = ${i - 1} (index to find position)',
          currentPseudocodeLine: 3,
        ),
      );

      while (j >= 0 && arr[j] > key) {
        _steps.add(
          SortStep(
            array: List.from(arr),
            comparing: [j, i],
            description: '🔍 Comparing arr[$j] = ${arr[j]} > key = $key',
            currentPseudocodeLine: 4,
          ),
        );

        arr[j + 1] = arr[j];
        _steps.add(
          SortStep(
            array: List.from(arr),
            swapping: [j, j + 1],
            description: '➡️ Shifting ${arr[j + 1]} one position to the right',
            currentPseudocodeLine: 5,
          ),
        );

        j = j - 1;
        _steps.add(SortStep(array: List.from(arr), description: '📝 j = j - 1 = $j', currentPseudocodeLine: 6));
      }

      if (j >= 0) {
        _steps.add(
          SortStep(
            array: List.from(arr),
            comparing: [j],
            description: '🔍 arr[$j] = ${arr[j]} <= key = $key, position found',
            currentPseudocodeLine: 4,
          ),
        );
      }

      arr[j + 1] = key;
      _steps.add(
        SortStep(
          array: List.from(arr),
          swapping: [j + 1],
          sorted: List.generate(i + 1, (index) => index),
          description: '✅ Inserting key = $key at position ${j + 1}',
          currentPseudocodeLine: 7,
        ),
      );
    }

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(n, (index) => index),
        description: '🎉 Insertion Sort completed! Each element was inserted in its correct position',
        currentPseudocodeLine: 8,
      ),
    );

    return _steps;
  }
}
