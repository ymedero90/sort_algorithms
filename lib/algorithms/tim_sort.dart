import '../models/sort_step.dart';
import '../models/sorting_algorithm.dart';

class TimSort extends SortingAlgorithm {
  List<SortStep> _steps = [];
  static const int RUN = 32;

  @override
  String get name => 'Tim Sort';

  @override
  String get description =>
      'Hybrid sorting algorithm combining Merge Sort and Insertion Sort. Complexity: O(n log n) - Stable';

  @override
  String get timeComplexity => 'O(n log n)';

  @override
  String get spaceComplexity => 'O(n)';

  @override
  bool get isStable => true;

  @override
  List<String> get advantages => [
    'Excellent performance on partially ordered data',
    'Stable algorithm',
    'Adaptive (O(n) in the best case)',
    'Used in real implementations (Python, Java)',
    'Optimized for common patterns',
  ];

  @override
  List<String> get disadvantages => [
    'Complex implementation',
    'Requires additional memory O(n)',
    'Overhead for very small arrays',
    'Sophisticated algorithm for simple cases',
  ];

  @override
  List<String> get pseudocode => [
    'function timSort(arr):',
    '    RUN = 32',
    '    for i = 0; i < len; i += RUN:',
    '        end = min(i + RUN - 1, len - 1)',
    '        insertionSort(arr, i, end)',
    '    size = RUN',
    '    while size < len:',
    '        for left = 0; left < len; left += 2 * size:',
    '            mid = left + size - 1',
    '            right = min(left + 2 * size - 1, len - 1)',
    '            if mid < right:',
    '                merge(arr, left, mid, right)',
    '        size = 2 * size',
    '    return arr',
  ];

  @override
  String getTimeComplexityExplanation() {
    return 'O(n log n) in the worst case, but O(n) in the best case when the data is partially ordered. Identifies and takes advantage of already ordered sequences (runs) to reduce the merge work.';
  }

  @override
  String getSpaceComplexityExplanation() {
    return 'O(n) for the auxiliary array used in the merge operations, similar to traditional Merge Sort.';
  }

  @override
  String getStabilityExplanation() {
    return 'It is stable because both Insertion Sort and Merge Sort are stable, and TimSort carefully preserves the relative order during all operations.';
  }

  @override
  List<SortStep> sort(List<int> array) {
    _steps = [];
    List<int> arr = List.from(array);
    int n = arr.length;

    if (n <= 1) return _steps;

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '🎯 TimSort: Hybrid algorithm with fixed RUN of $RUN elements',
        currentPseudocodeLine: 0,
      ),
    );

    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '📏 RUN = $RUN (fixed size subarray for Insertion Sort)',
        currentPseudocodeLine: 1,
      ),
    );

    // Sort individual subarrays of size RUN using insertion sort
    for (int i = 0; i < n; i += RUN) {
      int end = (i + RUN - 1 < n) ? i + RUN - 1 : n - 1;

      _steps.add(
        SortStep(
          array: List.from(arr),
          comparing: List.generate(end - i + 1, (index) => i + index),
          description: '🔧 Insertion Sort on run [$i, $end] (size ${end - i + 1})',
          currentPseudocodeLine: 2,
        ),
      );

      _insertionSort(arr, i, end);

      _steps.add(
        SortStep(
          array: List.from(arr),
          sorted: List.generate(end - i + 1, (index) => i + index),
          description: '✅ Run [$i, $end] sorted with Insertion Sort',
          currentPseudocodeLine: 4,
        ),
      );
    }

    // Start merging from size RUN
    int size = RUN;
    _steps.add(
      SortStep(
        array: List.from(arr),
        description: '📐 Starting merge phase with size = $size',
        currentPseudocodeLine: 5,
      ),
    );

    while (size < n) {
      _steps.add(
        SortStep(
          array: List.from(arr),
          description: '🔀 Merge phase: merging runs of size $size',
          currentPseudocodeLine: 6,
        ),
      );

      for (int left = 0; left < n; left += 2 * size) {
        int mid = left + size - 1;
        int right = (left + 2 * size - 1 < n - 1) ? left + 2 * size - 1 : n - 1;

        _steps.add(
          SortStep(
            array: List.from(arr),
            description: '📍 Calculating positions: left=$left, mid=$mid, right=$right',
            currentPseudocodeLine: 8,
          ),
        );

        if (mid < right) {
          _steps.add(
            SortStep(
              array: List.from(arr),
              comparing: List.generate(right - left + 1, (i) => left + i),
              description: '🔀 Merging runs: [$left..$mid] with [${mid + 1}..$right]',
              currentPseudocodeLine: 10,
            ),
          );

          _merge(arr, left, mid, right);

          _steps.add(
            SortStep(
              array: List.from(arr),
              sorted: List.generate(right - left + 1, (i) => left + i),
              description: '✅ Merge completed: [$left..$right] (size ${right - left + 1})',
              currentPseudocodeLine: 11,
            ),
          );
        }
      }

      size = 2 * size;
      _steps.add(
        SortStep(array: List.from(arr), description: '📈 Doubling size: size = $size', currentPseudocodeLine: 12),
      );
    }

    _steps.add(
      SortStep(
        array: List.from(arr),
        sorted: List.generate(n, (index) => index),
        description: '🎉 TimSort completed! Hybrid algorithm successful',
        currentPseudocodeLine: 13,
      ),
    );

    return _steps;
  }

  void _insertionSort(List<int> arr, int left, int right) {
    for (int i = left + 1; i <= right; i++) {
      int temp = arr[i];
      int j = i - 1;

      while (j >= left && arr[j] > temp) {
        arr[j + 1] = arr[j];
        j--;
      }
      arr[j + 1] = temp;
    }
  }

  void _merge(List<int> arr, int left, int mid, int right) {
    List<int> leftArr = arr.sublist(left, mid + 1);
    List<int> rightArr = arr.sublist(mid + 1, right + 1);

    int i = 0, j = 0, k = left;

    // Merge elements from leftArr and rightArr back into arr
    while (i < leftArr.length && j < rightArr.length) {
      if (leftArr[i] <= rightArr[j]) {
        arr[k] = leftArr[i];
        i++;
      } else {
        arr[k] = rightArr[j];
        j++;
      }
      k++;
    }

    // Copy remaining elements of leftArr, if any
    while (i < leftArr.length) {
      arr[k] = leftArr[i];
      i++;
      k++;
    }

    // Copy remaining elements of rightArr, if any
    while (j < rightArr.length) {
      arr[k] = rightArr[j];
      j++;
      k++;
    }
  }
}
