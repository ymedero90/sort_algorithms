import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';

class SelectionSort extends SortingAlgorithm {
  List<SortStep> _steps = [];

  @override
  String get name => 'Selection Sort';

  @override
  String get description =>
      'Simple comparison-based algorithm that selects the smallest element and swaps it. Complexity: O(n²) - Unstable';

  @override
  String get timeComplexity => 'O(n²)';

  @override
  String get spaceComplexity => 'O(1)';

  @override
  bool get isStable => false;

  @override
  List<String> get advantages => [
    'Simple to understand and implement',
    'In-place sorting (O(1) space)',
    'Minimum number of swaps (O(n))',
    'Good for small arrays',
    'Performance is not affected by initial order',
  ];

  @override
  List<String> get disadvantages => [
    'Poor time complexity O(n²)',
    'Not stable',
    'Not adaptive (always O(n²))',
    'Many comparisons even for sorted arrays',
  ];

  @override
  List<String> get pseudocode => [
    'function selectionSort(arr):',
    '    for i = 0 to length(arr) - 2:',
    '        minIndex = i',
    '        for j = i + 1 to length(arr) - 1:',
    '            if arr[j] < arr[minIndex]:',
    '                minIndex = j',
    '        if minIndex != i:',
    '            swap(arr[i], arr[minIndex])',
    '    return arr',
  ];

  @override
  String getTimeComplexityExplanation() {
    return 'O(n²) in all cases because it always performs (n-1) + (n-2) + ... + 1 = n(n-1)/2 comparisons, regardless of the initial order of elements.';
  }

  @override
  String getSpaceComplexityExplanation() {
    return 'O(1) because it only uses a constant amount of extra variables (minIndex, temp for swapping) regardless of input size.';
  }

  @override
  String getStabilityExplanation() {
    return 'Not stable because it can swap non-adjacent elements, potentially changing the relative order of equal elements. For example, in [4a, 2, 4b], 4a might be swapped with 2, placing it after 4b.';
  }

  @override
  List<SortStep> sort(List<int> array) {
    // Debug flag - set to true only when debugging this specific algorithm
    const bool debugMode = false;

    if (debugMode) print('🔍 SelectionSort.sort() called with array: $array');

    _steps = [];
    List<int> arr = List.from(array);
    int n = arr.length;

    if (debugMode) print('📝 Initial array length: $n');

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🎯 Selection Sort: Finding minimum elements and placing them in order',
        currentPseudocodeLine: 0,
      ),
    );

    if (debugMode) print('✅ Added initial step. Total steps: ${_steps.length}');

    for (int i = 0; i < n - 1; i++) {
      if (debugMode) print('\n🔄 Outer loop iteration $i (finding minimum for position $i)');

      int minIndex = i;

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [i],
          sorted: List.generate(i, (index) => index),
          description: '🔍 Round ${i + 1}: Finding minimum element for position $i',
          currentPseudocodeLine: 1,
        ),
      );

      if (debugMode) {
        print('📊 Added outer loop step. Array state: $arr');
        print('🎯 Initial minIndex = $i (value: ${arr[i]})');
      }

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: [i],
          description: '📝 Setting minIndex = $i (value: ${arr[i]})',
          currentPseudocodeLine: 2,
        ),
      );

      for (int j = i + 1; j < n; j++) {
        if (debugMode) print('  🔍 Inner loop: comparing arr[$j]=${arr[j]} with arr[$minIndex]=${arr[minIndex]}');

        _steps.add(
          SortStep(
            array: List.from(arr),
            comparing: [j, minIndex],
            sorted: List.generate(i, (index) => index),
            description: '🔍 Comparing arr[$j] = ${arr[j]} with current minimum arr[$minIndex] = ${arr[minIndex]}',
            currentPseudocodeLine: 3,
          ),
        );

        if (arr[j] < arr[minIndex]) {
          if (debugMode) print('  ✅ Found new minimum: arr[$j]=${arr[j]} < arr[$minIndex]=${arr[minIndex]}');

          minIndex = j;

          _steps.add(
            SortStep(
              array: List.from(arr),
              comparing: [j],
              sorted: List.generate(i, (index) => index),
              description: '✅ New minimum found! minIndex = $j (value: ${arr[j]})',
              currentPseudocodeLine: 4,
            ),
          );
        } else {
          if (debugMode) print('  ❌ No change: arr[$j]=${arr[j]} >= arr[$minIndex]=${arr[minIndex]}');
        }
      }

      if (debugMode) print('🏁 Inner loop finished. Final minIndex = $minIndex (value: ${arr[minIndex]})');

      if (minIndex != i) {
        if (debugMode) print('🔄 Swapping needed: arr[$i]=${arr[i]} <-> arr[$minIndex]=${arr[minIndex]}');

        _steps.add(
          SortStep(
            array: List.from(arr),
            swapping: [i, minIndex],
            sorted: List.generate(i, (index) => index),
            description: '🔄 Swapping arr[$i] = ${arr[i]} with arr[$minIndex] = ${arr[minIndex]}',
            currentPseudocodeLine: 6,
          ),
        );

        // Perform swap
        int temp = arr[i];
        arr[i] = arr[minIndex];
        arr[minIndex] = temp;

        if (debugMode) print('✅ Swap completed. New array: $arr');

        _steps.add(
          SortStep(
            array: List.from(arr),
            sorted: List.generate(i + 1, (index) => index),
            description: '✅ Element ${arr[i]} is now in its final position $i',
            currentPseudocodeLine: 7,
          ),
        );
      } else {
        if (debugMode) print('ℹ️  No swap needed: element ${arr[i]} is already in correct position');

        _steps.add(
          SortStep(
            array: List.from(arr),
            sorted: List.generate(i + 1, (index) => index),
            description: '✅ Element ${arr[i]} is already in correct position $i',
            currentPseudocodeLine: 7,
          ),
        );
      }

      if (debugMode) print('📊 End of iteration $i. Total steps so far: ${_steps.length}');
    }

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(n, (index) => index),
        description: '🎉 Selection Sort completed! All elements are in their final positions',
        currentPseudocodeLine: 8,
      ),
    );

    if (debugMode) {
      print('\n🎉 Selection Sort completed!');
      print('📊 Final array: $arr');
      print('📈 Total steps generated: ${_steps.length}');
    }

    return _steps;
  }
}
